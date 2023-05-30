//
//  SignInWIthAppleManager.swift
//  Yogit
//
//  Created by Junseo Park on 2022/09/19.
//

import Foundation
import AuthenticationServices

// 공통 유저 상태 변경 API 호출 프로토콜
private protocol UserStausAPICall {
    func signUp<T: Encodable>(signUpReq: T, completion: @escaping (UserSessionManager.Response) -> Void)
    func logIn<T: Encodable>(logInReq: T, userItem: UserItem, completion: @escaping (UserSessionManager.Response) -> Void) // userStatus만 정보 업데이트
    func logOut<T: Encodable>(logOutReq: T, userItem: UserItem, completion: @escaping (UserSessionManager.Response) -> Void) // userStatus만 정보 업데이트
    func deleteAccount<T: Encodable>(deleteAccountReq: T, userItem: UserItem, completion: @escaping (UserSessionManager.Response) -> Void)
}

private protocol UserStatusLocalDBHandle {
    func saveLocalDBWhenLogIn(userItem: UserItem)
    func deleteLocalDBWhenLogOut()
    func deleteLocalDBWhenDeleteAccount()
}

final class UserSessionManager {
    enum Response {
        case success
        case badResponse
        case failureResponse
    }
    
    enum AuthState: String {
        case undefine
        case signInSNS = "LOGIN"
        case signInService
        case signOut = "LOGOUT"
        case deleteAccout
    }

    enum Service: String {
        case APPLE_SIGNIN = "APPLE"
        case FACEBOOK_SIGNIN = "FACEBOOK"
        
        enum UserInit { // 초기 애플 서버 권한 인증시 이메일과 이름 한번만 제공, 해당 키로 키체인에 유저의 이메일과 이름 저장 해놓는다.
            static let APPLE: String = "APPLE_USER_INFO"
        }
    }
    
    static let shared = UserSessionManager()
    
    static let currentServiceTypeIdentifier = "CurrentServiceType"
    
    static func checkUserAuth(completion: @escaping (AuthState) -> ()) {
        // 현재 로그인된 서비스 API 확인 및 키체인 유저 정보 유무 확인
        guard let identifier = UserDefaults.standard.object(forKey: currentServiceTypeIdentifier) as? String,
              let userItem = try? KeychainManager.getUserItem(serviceType: identifier) else {
            completion(.undefine)
            return
        }

        switch userItem.userType { // 로그인 API 서비스 명
        case Service.APPLE_SIGNIN.rawValue: // 애플 로그인
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            appleIDProvider.getCredentialState(forUserID: userItem.account.identifier) { (credentialState, error) in
                switch credentialState {
                    case .notFound: // 회원가입 안한 유저/잘못된 serIdendifier로 credentialState를 조회시/애플 로그인 시스템에 문제 발생, 회원가입 화면 전환
                        completion(.undefine)
                    case .authorized: // The Apple ID credential is valid, 홈 화면 전환
                        if userItem.account.hasRequirementInfo {  // 사용자 가입 필수 정보 저장 후
                            completion(.signInService)
                        }
                        else { // 애플 로그인만한 상태 (사용자 가입 필수 정보 저장 이전), 로그인 화면 전환
                            completion(.signInSNS)
                        }
                    case .revoked: // 애플 ID 사용 중단, 로그인 화면 전환 및 회원 탈퇴 요청
                        completion(.deleteAccout)
                    default:
                        break
                }
            }
        default: fatalError("Not support service SignIn")
        }
    }
}

extension UserSessionManager: UserStausAPICall {
    
    func signUp<T>(signUpReq: T, completion: @escaping (Response) -> Void) where T : Encodable {
        var router: SessionRouter?
        if let parameters = signUpReq as? Account {
            router = SessionRouter.signUpApple(parameters: parameters)
        }
        
        AlamofireManager.shared.session
            .request(router!)
            .validate(statusCode: 200..<501)
            .responseDecodable(of: APIResponse<UserItem>.self) { response in
            switch response.result {
            case .success:
                if let value = response.value, value.httpCode == 200 || value.httpCode == 201, let data = value.data {
                    do {
                        try KeychainManager.saveUserItem(userItem: data)
                        self.saveLocalDBWhenLogIn(userItem: data)
                    } catch {
                        print("KeychainManager saveUserItem error \(error.localizedDescription)")
                    }
                    completion(.success)
                } else {
                    completion(.badResponse)
                }
            case let .failure(error): // 응답실패시 다시 요청해도 userItem 반환하게 해야함
                print("signUpApple", error)
                completion(.failureResponse)
            }
        }
    }
    
    func logIn<T>(logInReq: T, userItem: UserItem, completion: @escaping (Response) -> Void) where T : Encodable {
        var router: SessionRouter?
        if let parameters = logInReq as? LogInAppleReq {
            router = SessionRouter.logInApple(parameters: parameters)
        }
        AlamofireManager.shared.session
            .request(router!)
            .validate(statusCode: 200..<501)
            .responseDecodable(of: APIResponse<UserItem>.self) { response in
            switch response.result {
            case .success:
                if let value = response.value, value.httpCode == 200 || value.httpCode == 201, let data = value.data {
                    userItem.userStatus = data.userStatus
                    do {
                        try KeychainManager.updateUserItem(userItem: userItem)
                        self.saveLocalDBWhenLogIn(userItem: data)
                    } catch {
                        print("KeychainManager.updateUserItem \(error.localizedDescription)")
                    }
                    completion(.success)
                } else {
                    completion(.badResponse)
                }
            case let .failure(error):
                print("LogIn", error)
                completion(.failureResponse)
            }
        }
    }
    
    func logOut<T>(logOutReq: T, userItem: UserItem, completion: @escaping (Response) -> Void) where T : Encodable {
        var router: SessionRouter?
        if let parameters = logOutReq as? LogOutAppleReq {
            router = SessionRouter.logOut(parameters: parameters)
        }
        AlamofireManager.shared.session
            .request(router!)
            .validate(statusCode: 200..<501)
            .responseDecodable(of: APIResponse<LogOutAppleRes>.self) { response in
            switch response.result {
            case .success:
                if let value = response.value, value.httpCode == 200 || value.httpCode == 201, let data = value.data {
                    do {
                        userItem.userStatus = data.userStatus
                        try KeychainManager.updateUserItem(userItem: userItem)
                        self.deleteLocalDBWhenLogOut()
                    } catch {
                        print("KeychainManager.deleteUserItem \(error.localizedDescription)")
                    }
                    completion(.success)
                } else {
                    completion(.badResponse)
                }
            case let .failure(error):
                print("Logout error", error)
                completion(.failureResponse)
            }
        }
    }
    
    func deleteAccount<T>(deleteAccountReq: T, userItem: UserItem, completion: @escaping (Response) -> Void) where T : Encodable {
        var router: SessionRouter?
        if let parameters = deleteAccountReq as? DeleteAppleAccountReq {
            router = SessionRouter.deleteApple(parameters: parameters)
        }
        AlamofireManager.shared.session
            .request(router!)
            .validate(statusCode: 200..<501)
            .responseDecodable(of: APIResponse<String>.self) { response in
            switch response.result {
            case .success:
                guard let value = response.value else { return }
                if value.httpCode == 200 || value.httpCode == 201 {
                    do {
                        try KeychainManager.deleteUserItem(userItem: userItem)
                        self.deleteLocalDBWhenDeleteAccount()
                    } catch {
                        print("KeychainManager.deleteUserItem \(error.localizedDescription)")
                    }
                    completion(.success)
                } else {
                    completion(.badResponse)
                }
            case let .failure(error):
                print("Delete account", error)
                completion(.failureResponse)
            }
        }
    }  
}

extension UserSessionManager: UserStatusLocalDBHandle {
    func saveLocalDBWhenLogIn(userItem: UserItem) {
        UserDefaults.standard.set(userItem.userType, forKey: UserSessionManager.currentServiceTypeIdentifier)
    }
    
    func deleteLocalDBWhenLogOut() {
        UserDefaults.standard.removeObject(forKey: UserSessionManager.currentServiceTypeIdentifier) // 앱 로그아웃/삭제 후 로그인(유저 디폴트 삭제됨) 혹은 로그아웃
        UserDefaults.standard.removeObject(forKey: Preferences.PUSH_NOTIFICATION)  // 앱 앱 로그아웃/삭제 후 디바이스 토큰 삭재
    }

    func deleteLocalDBWhenDeleteAccount() {
        UserDefaults.standard.removeObject(forKey: UserSessionManager.currentServiceTypeIdentifier) // 앱 삭제후 로그인(유저 디폴트 삭제됨) 혹은 로그아웃
        UserDefaults.standard.removeObject(forKey: Preferences.PUSH_NOTIFICATION) // 앱 삭제후 디바이스 토큰 삭제
        PushNotificationManager.deleteAllNotifications()
    }
}
