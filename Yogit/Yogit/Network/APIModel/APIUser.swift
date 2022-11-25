//
//  APIModel.swift
//  Yogit
//
//  Created by Junseo Park on 2022/11/23.
//

import Foundation

class Account: Codable {
    let state: String
    let code: String
    let id_token: String
    let user: User
    let identifier: String
    let hasRequirementInfo: Bool
    
    init(state: String, code: String, id_token: String, user: User, identifier: String, hasRequirementInfo: Bool) {
        self.state = state
        self.code = code
        self.id_token = id_token
        self.user = user
        self.identifier = identifier
        self.hasRequirementInfo = hasRequirementInfo
    }
}

class Name: Codable {
    let firstName: String
    let lastName: String
    
    init(firstName: String, lastName: String) {
        self.firstName = firstName
        self.lastName = lastName
    }
}

class User: Codable {
    let name: Name
    let email: String
    
    init(name: Name, email: String) {
        self.name = name
        self.email = email
    }
}

class UserItem: Codable {
    let account: Account
    let access_token: String
    let expires_in: Int64
    let id_token: String
    let refresh_token: String
    let token_type: String
    let userType: String
    let userId: Int64
    
    init(account: Account, access_token: String, expires_in: Int64, id_token: String, refresh_token: String, token_type: String, userType: String, userId: Int64) {
        self.account = account
        self.access_token = access_token
        self.expires_in = expires_in
        self.id_token = id_token
        self.refresh_token = refresh_token
        self.token_type = token_type
        self.userType = userType
        self.userId = userId
    }
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

