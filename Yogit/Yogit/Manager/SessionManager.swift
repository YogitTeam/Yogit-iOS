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
        case signInSNS = "LOGIN", signInService
        case signOut = "LOGOUT"
        case deleteAccout
    }

    enum Service {
        static let APPLE_SIGNIN: String = "APPLE"
        static let FACEBOOK_SIGNIN: String = "FACEBOOK"
        
        enum User {
            static let APPLE: String = "APPLE_USER_INFO"
        }
    }
    
    static let shared = SessionManager()
    static let currentServiceTypeIdentifier = "CurrentServiceType"
    
    static func checkUserAuth(completion: @escaping (AuthState) -> ()) {
        // 현재 로그인된 userType 체크, 유저 디폴트에 없으면 loginView화면으로 completion(.undefine) 반환
        // 토큰 확인 (계정 삭제나, 처음 회원가입시 nil)
        guard let identifier = UserDefaults.standard.object(forKey: SessionManager.currentServiceTypeIdentifier) as? String, let userItem = try? KeychainManager.getUserItem(serviceType: identifier) else {
            completion(.undefine)
            return
        }

        switch userItem.userType { // service name
        case Service.APPLE_SIGNIN: //
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            appleIDProvider.getCredentialState(forUserID: userItem.account.identifier) { (credentialState, error) in
                switch credentialState {
                case .notFound: // 회원가입 안한 유저나 잘못된 만약 잘못된 UserIdendifier로 credentialState를 조회했거나, 애플 로그인 시스템에 문제가 있을 때, so show the sign-in UI.
                    completion(.undefine)
                    break
                case .authorized: // The Apple ID credential is valid. / 회원 가입시 자격권한 승인된 사람
                    print("Authorized userItem.account.hasRequirementInfo", userItem.account.hasRequirementInfo)
                    if userItem.account.hasRequirementInfo { completion(.signInService) } // 서비스 로그인 (필수 정보 기입)
                    else { completion(.signInSNS) } // 애플 로그인 (애플 로그인만한 상태, 필수 정보 미기입)
                    break
                case .revoked: // 애플 계정 사용 중단 혹은 계정삭제, so show the sign-in UI. (refresh token 만료됨 & 애플 자격증명 삭제됨)
                    // 애플 키체인 삭제
                    // 현재 로그인 type 삭제 (내부 구현)
                    completion(.deleteAccout)
                    print("애플 credentialState == .revoke")
                    break
                default:
                    break
                }
            }
        default: fatalError("Not support service SignIn")
        }
    }
}

