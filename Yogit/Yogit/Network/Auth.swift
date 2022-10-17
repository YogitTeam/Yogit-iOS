//
//  SignIn.swift
//  Yogit
//
//  Created by Junseo Park on 2022/09/29.
//

import Foundation

struct SignInWithAppleInfo: Encodable {
    let userName: String?
    let userEmail: String?
    let userIdentifier: String
    let identityToken: String
    let authorizationCode: String
    let realUserStatus: Int
}

//struct AppleToken: Codable {
//    let accessToken: Data?
//    let refreshToken: Data?
////    let requirementData: Bool?
//}

struct Account: Codable {
    let userName: String?
    let userEmail: String?
    let userIdentifier: String
    let userId: Int
}

struct UserItem: Codable {
    let accunt: Account
    var service: String
    let token: String
}

