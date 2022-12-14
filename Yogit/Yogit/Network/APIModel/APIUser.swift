//
//  APIModel.swift
//  Yogit
//
//  Created by Junseo Park on 2022/11/23.
//

import Foundation

struct SendDeviceToken: Encodable {
    let deviceToken: String
    let refreshToken: String
    let userId: Int64

    init(deviceToken: String, refreshToken: String, userId: Int64) {
        self.deviceToken = deviceToken
        self.refreshToken = refreshToken
        self.userId = userId
    }
}

struct GetUserProfileImages: Encodable {
    let refreshToken: String
    let userId: Int64
    
    init(refreshToken: String, userId: Int64) {
        self.refreshToken = refreshToken
        self.userId = userId
    }
}

class Account: Codable {
    let state: String
    let code: String
    let id_token: String
    let user: User
    let identifier: String
    var hasRequirementInfo: Bool
    
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
    var deviceToken: String?
    
    init(account: Account, access_token: String, expires_in: Int64, id_token: String, refresh_token: String, token_type: String, userType: String, userId: Int64, deviceToken: String?) {
        self.account = account
        self.access_token = access_token
        self.expires_in = expires_in
        self.id_token = id_token
        self.refresh_token = refresh_token
        self.token_type = token_type
        self.userType = userType
        self.userId = userId
        self.deviceToken = deviceToken
    }
}

class UserProfileImages: Decodable {
    let imageUrls: [String]
    let profileImageUrl: String
    let userImageIds: [Int64]
    
    init(imageUrls: [String], profileImageUrl: String, userImageIds: [Int64]) {
        self.imageUrls = imageUrls
        self.profileImageUrl = profileImageUrl
        self.userImageIds = userImageIds
    }
}

class ServiceUserProfile: Codable {
    let age: Int
    let gender: String
    let city, phone, aboutMe, administrativeArea: String?
    let interests: [String]?
    let languageLevels, languageNames: [String]
    let latitude: Double?
    let longtitude: Double?
    let memberTemp: Double?
    let name, nationality, profileImg: String
    let userId: Int64
    let userStatus: String?
    let login_id: String?
    let countryEngNm, downloadURL: String?

    init(age: Int, gender: String, city: String?, phone: String?, aboutMe: String?, administrativeArea: String?, interests: [String]?, languageLevels: [String], languageNames: [String], latitude: Double?, longtitude: Double?, memberTemp: Double?, name: String, nationality: String, profileImg: String, userId: Int64, userStatus: String?, login_id: String?, countryEngNm: String?, downloadURL: String?) {
        self.age = age
        self.gender = gender
        self.city = city
        self.phone = phone
        self.aboutMe = aboutMe
        self.administrativeArea = administrativeArea
        self.interests = interests
        self.languageLevels = languageLevels
        self.languageNames = languageNames
        self.latitude = latitude
        self.longtitude = longtitude
        self.memberTemp = memberTemp
        self.name = name
        self.nationality = nationality
        self.profileImg = profileImg
        self.userId = userId
        self.userStatus = userStatus
        self.login_id = login_id
        self.countryEngNm = countryEngNm
        self.downloadURL = downloadURL
    }
}

struct GetUserProfile: Encodable {
    let refreshToken: String
    let refreshTokenUserId: Int64
    let userId: Int64
    
    init(refreshToken: String, refreshTokenUserId: Int64, userId: Int64) {
        self.refreshToken = refreshToken
        self.refreshTokenUserId = refreshTokenUserId
        self.userId = userId
    }
}


//class ServiceUserProfile: Codable {
//    let aboutMe, administrativeArea: String?
//    let age: Int
//    let city, countryEngNm, downloadURL, gender: String
//    let interests, languageLevels, languageNames: [String]
//    let latitude, longtitude, memberTemp: Int
//    let name, nationality, phone, profileImg: String
//    let userID: Int
//    let userStatus: String
//
//    enum CodingKeys: String, CodingKey {
//        case aboutMe, administrativeArea, age, city
//        case countryEngNm = "country_eng_nm"
//        case downloadURL = "download_url"
//        case gender, interests, languageLevels, languageNames, latitude, longtitude, memberTemp, name, nationality, phone, profileImg
//        case userID = "userId"
//        case userStatus
//    }
//
//    init(aboutMe: String, administrativeArea: String, age: Int, city: String, countryEngNm: String, downloadURL: String, gender: String, interests: [String], languageLevels: [String], languageNames: [String], latitude: Int, longtitude: Int, memberTemp: Int, name: String, nationality: String, phone: String, profileImg: String, userID: Int, userStatus: String) {
//        self.aboutMe = aboutMe
//        self.administrativeArea = administrativeArea
//        self.age = age
//        self.city = city
//        self.countryEngNm = countryEngNm
//        self.downloadURL = downloadURL
//        self.gender = gender
//        self.interests = interests
//        self.languageLevels = languageLevels
//        self.languageNames = languageNames
//        self.latitude = latitude
//        self.longtitude = longtitude
//        self.memberTemp = memberTemp
//        self.name = name
//        self.nationality = nationality
//        self.phone = phone
//        self.profileImg = profileImg
//        self.userID = userID
//        self.userStatus = userStatus
//    }
//}
