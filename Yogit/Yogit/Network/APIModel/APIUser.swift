//
//  APIModel.swift
//  Yogit
//
//  Created by Junseo Park on 2022/11/23.
//

import Foundation

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

class UserProfileImages: Decodable {
    let imageUrls: [String]?
    let profileImageUrl: String?

    enum CodingKeys: String, CodingKey {
        case imageUrls
        case profileImageUrl
    }
    
    init(imageUrls: [String]?, profileImageUrl: String?) {
        self.imageUrls = imageUrls
        self.profileImageUrl = profileImageUrl
    }
}

