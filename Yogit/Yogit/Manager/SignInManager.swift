//
//  SignInWIthAppleManager.swift
//  Yogit
//
//  Created by Junseo Park on 2022/09/19.
//

import Foundation
import AuthenticationServices

enum AuthState {
    case undefine, signOut
    case signInNotFull, signInFull
    
//    enum RequirementInfoState  {
//        case full, notFull
//    }
}

enum RootViewState {
    case loginView, homeView, setProfileView
}

struct SignInManager {
    
//    static let userIdentifierKey = "userIdentifier"
//    static let identityTokenKey = "identityToken"
//    static let accessTokenKey = "accessToken"
//    static let refreshTokenKey = "refreshToken"

    
    static func checkUserAuth(completion: @escaping (AuthState) -> ()) {
        
        // 토큰 확인
        guard let userItem = try? KeychainManager.getUserItem() else {
            completion(.undefine)
            return
        }
        
        
        switch userItem.userType { // service name
        case Service.APPLE_SIGNIN: //
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            appleIDProvider.getCredentialState(forUserID: userItem.account.identifier) { (credentialState, error) in
                switch credentialState {
                case .notFound: // The Apple ID credential was not found, so show the sign-in UI.
                    completion(.undefine)
                    break
                case .authorized: // The Apple ID credential is valid.
                    if userItem.account.hasRequirementInfo { completion(.signInFull) }
                    else { completion(.signInNotFull) }
                    break
                case .revoked: // The Apple ID credential is either revoked, so show the sign-in UI.
                    completion(.signOut)
                    break
                default:
                    break
                }
            }
        default: fatalError("Not support service SignIn")
        }
    }
}



