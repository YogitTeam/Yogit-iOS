//
//  SignInWIthAppleManager.swift
//  Yogit
//
//  Created by Junseo Park on 2022/09/19.
//

import Foundation
import AuthenticationServices

final class SessionManager {
    enum AuthState: String {
        case undefine
        case signInSNS = "LOGIN"
        case signInService
        case signOut = "LOGOUT"
        case deleteAccout
    }

    enum Service {
        static let APPLE_SIGNIN: String = "APPLE"
        static let FACEBOOK_SIGNIN: String = "FACEBOOK"
        
        enum UserInit { // 초기 애플 서버 권한 인증시 이메일과 이름 한번만 제공하여 해당 키로 키체인에 유저의 이메일과 이름 저장 해놓는다.
            static let APPLE: String = "APPLE_USER_INFO"
        }
    }
    
    static let shared = SessionManager()
    
    static let currentServiceTypeIdentifier = "CurrentServiceType"
    
    static func checkUserAuth(completion: @escaping (AuthState) -> ()) {
        // 현재 로그인된 서비스 API 체크 및 키첸인 사용자 계정 정보 유무 확인
        guard let identifier = UserDefaults.standard.object(forKey: SessionManager.currentServiceTypeIdentifier) as? String,
              let userItem = try? KeychainManager.getUserItem(serviceType: identifier) else {
            completion(.undefine)
            return
        }

        switch userItem.userType { // 로그인 API 서비스 명
        case Service.APPLE_SIGNIN: // 애플 로그인
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            appleIDProvider.getCredentialState(forUserID: userItem.account.identifier) { (credentialState, error) in
                switch credentialState {
                    case .notFound: // 회원가입 안한 유저나 잘못된 만약 잘못된 UserIdendifier로 credentialState를 조회시/애플 로그인 시스템에 문제 발생시, so show the sign-in UI.
                        completion(.undefine)
                    case .authorized: // The Apple ID credential is valid, 홈 화면 전환
                        if userItem.account.hasRequirementInfo {  // 사용자 가입 필수 정보 저장 후
                            completion(.signInService)
                        }
                        else { // 애플 로그인만한 상태, 사용자 가입 필수 정보 저장 이전
                            completion(.signInSNS)
                        }
                    case .revoked: // 애플 계정 사용 중단 혹은 계정 삭제시, 로그인 화면 전환
                        completion(.deleteAccout)
                    default:
                        break
                }
            }
        default: fatalError("Not support service SignIn")
        }
    }
    
    static func saveCountryCode(code: ServiceCountry) { // country save (server country)
        UserDefaults.standard.set(code.rawValue, forKey: ServiceCountry.identifier)
    }
    
    static func getSavedCountryCode() -> String? {
        guard let code = UserDefaults.standard.object(forKey: ServiceCountry.identifier) as? ServiceCountry.RawValue else { return nil }
        return code
    }
}

