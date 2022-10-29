//
//  SignInWIthAppleManager.swift
//  Yogit
//
//  Created by Junseo Park on 2022/09/19.
//

import Foundation
import AuthenticationServices

enum AuthState {
    case undefined, signedIn, signedOut
    
    enum RequirementInfoState {
        case full, notFull
    }
}

enum RootViewState {
    case loginView, homeView, setUpProfileView
}

struct SignInManager {
    
    static let userIdentifierKey = "userIdentifier"
    static let identityTokenKey = "identityToken"
    static let accessTokenKey = "accessToken"
    static let refreshTokenKey = "refreshToken"
//    static let tokenElementKey = "tokenElement"
    
//    let userIdentifier = UserDefaults.standard.string(forKey: userIdentifierKey)
    
    static func checkUserAuth(completion: @escaping (AuthState) -> ()) {
        
        // changed to the refresh token
        // check token is existed
//        guard let userIdentifier = UserDefaults.standard.string(forKey: userIdentifierKey) else {
//            print("User Identifier not exist")
//            completion(.undefined)
//            return
//        }
        
        guard let userItem = try? KeychainManager.getUserItem() else {
            completion(.undefined)
            return
        }
        
        if userItem.service == Service.APPLE_SIGNIN {
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            appleIDProvider.getCredentialState(forUserID: userItem.accunt.userIdentifier) { (credentialState, error) in
                switch credentialState {
                case .notFound: // The Apple ID credential was not found, so show the sign-in UI.
                    completion(.undefined)
                    break
                case .authorized: // The Apple ID credential is valid.
                    completion(.signedIn)
                    break
                case .revoked: // The Apple ID credential is either revoked, so show the sign-in UI.
                    completion(.signedOut)
                    break
                default:
                    break
                }
            }
        }
        
//        guard let tokenElement = UserDefaults.standard.dictionary(forKey: tokenElementKey) else {
//            print("Token not exist")
//            completion(.undefined)
//            return
//        }
//
//        let tokenSource = UserDefaults.standard.dictionary(forKey: tokenElementKey)
//
//        // "tokenElement"
//        if tokenElement.keys.description == Token.APPLE_TOKEN {
//            // refactoring keychian
//            let appleIDProvider = ASAuthorizationAppleIDProvider()
//            appleIDProvider.getCredentialState(forUserID: userIdentifier) { (credentialState, error) in
//                switch credentialState {
//                    case .notFound: // The Apple ID credential was not found, so show the sign-in UI.
//                        completion(.undefined)
//                        break
//                    case .authorized: // The Apple ID credential is valid.
//                        completion(.signedIn)
//                        break
//                    case .revoked: // The Apple ID credential is either revoked, so show the sign-in UI.
//                        completion(.signedOut)
//                        break
//                    default:
//                        break
//                }
//            }
//        }
//        if userIdentifier == "" {
//            print("User identifier is empty string")
//            completion(.undefined)
//        }
        
        
    }
}



