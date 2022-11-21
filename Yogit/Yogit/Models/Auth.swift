//
//  SignIn.swift
//  Yogit
//
//  Created by Junseo Park on 2022/09/29.
//

import Foundation

//struct SignInWithAppleInfo: Encodable {
//    let userName: String?
//    let userEmail: String?
//    let userIdentifier: String
//    let identityToken: String
//    let authorizationCode: String
//    let realUserStatus: Int
//}

//struct AppleToken: Codable {
//    let accessToken: Data?
//    let refreshToken: Data?
////    let requirementData: Bool?
//}


//"user": [
//    "name": [
//        "firstName": givenName,
//        "lastName": familyName
//        ],
//    "email": userEmail
//]

// request to server: userName, userEmail, userIdentifier
struct Account: Codable {
    let userName: String
    let userEmail: String
    let userIdentifier: String
    let userId: Int
    var hasRequirementInfo: Bool = false
}

struct UserItem: Codable {
    let accunt: Account
    let service: String
    let access_token: String
    let expires_in: Int64
    let id_token: String
    let refresh_token: String
    let token_type: String
}

//access_token: "a66b1154c60e84f239cbdc174fc022616.0.sryrq.Ng_12fnDPcnHmB-XH_76Bg",
//expires_in: 3600,
//id_token: "eyJraWQiOiJXNldjT0tCIiwiYWxnIjoiUlMyNTYifQ.eyJpc3MiOiJodHRwczovL2FwcGxlaWQuYXBwbGUuY29tIiwiYXVkIjoiY29tLkJyYW5jaC5zZXJ2aWNlIiwiZXhwIjoxNjY3NTQ3NjA5LCJpYXQiOjE2Njc0NjEyMDksInN1YiI6IjAwMTgxMC42OWM2NTk2NDg0YTQ0ZTQwODg5MWRhNjk2NDJhMTExZS4wMjQ2Iiwibm9uY2UiOiIyMEIyMEQtMFM4LTFLOCIsImF0X2hhc2giOiJjMklHYmhnbzVtMXJ5QUFLeGg1SG5RIiwiZW1haWwiOiI0aHh2Z3FncjQyQHByaXZhdGVyZWxheS5hcHBsZWlkLmNvbSIsImVtYWlsX3ZlcmlmaWVkIjoidHJ1ZSIsImlzX3ByaXZhdGVfZW1haWwiOiJ0cnVlIiwiYXV0aF90aW1lIjoxNjY3NDYxMjA2LCJub25jZV9zdXBwb3J0ZWQiOnRydWV9.S0eaPCzz-VtNOVtFqW86PrIT0GefmvwSuAAQymNrf0ju02qRgxVe8E7QaXZpSmbqQUqRbyAOVQDGO_VstE8d2Sj2Jd96fkaU2bBDYMqlrysSm7gNGFAHABGR99II4kHuEk1uLA_sAlMbQYVt7LMpMvmHg_WHdFVknprY2Lri54Rg3lS0dhZM7Rnzrvn7U0CbmvV2J8hEIwGcmu2Cp0S9-3bWO4Fo3Sy06xK1aw-VHgBiAmUnauiRErN16P8hN2UuPnaimLRkYegaAQ-CZQMQ9Yi3IPnJ0Bu-NIKiHa6yxseJdenLw5-vBQ07fPTTW8UfXMEwC8qFTMEMpttVVvM52A",
//refresh_token: "ra4530bbe2f3c44988663ccf2bc38f3c9.0.sryrq.KKUEyH8mmC7X5wWgGdZ9RA",
//token_type: "Bearer"


