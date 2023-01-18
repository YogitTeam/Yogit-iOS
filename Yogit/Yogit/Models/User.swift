//
//  User.swift
//  Yogit
//
//  Created by Junseo Park on 2022/09/11.
//

import Foundation
import UIKit

struct UserImagesData {
    var deleteUserImageIds: [Int64]?
    var uploadImages: [UIImage]
    var downloadImages: [String]
    var uploadProfileImage: UIImage?
    var imageIds: [Int64]
    var newImagesIdx: Int

    init(deleteUserImageIds: [Int64]? = nil, uploadImages: [UIImage] = [], downloadImages: [String] = [],uploadProfileImage: UIImage? = nil, imageIds: [Int64] = [], newImagesIdx: Int = 0) {
        self.deleteUserImageIds = deleteUserImageIds
        self.uploadImages = uploadImages
        self.downloadImages = downloadImages
        self.uploadProfileImage = uploadProfileImage
        self.imageIds = imageIds
        self.newImagesIdx = newImagesIdx
    }
}

//struct UserImagesData {
//    var deleteUserImageIds: [Int64]?
//    var uploadImages: [String]
//    var uploadProfileImage: String?
//    var imageIds: [Int64]
//    var newImagesIdx: Int
//    
//    init(deleteUserImageIds: [Int64]? = nil, uploadImages: [String] = [], uploadProfileImage: String? = nil, imageIds: [Int64] = [], newImagesIdx: Int = 0) {
//        self.deleteUserImageIds = deleteUserImageIds
//        self.uploadImages = uploadImages
//        self.uploadProfileImage = uploadProfileImage
//        self.imageIds = imageIds
//        self.newImagesIdx = newImagesIdx
//    }
//}

struct PatchUserImages {
    let userId: Int64
    let refreshToken: String
    let deleteUserImageIds: [Int64]?
    let uploadImages: [UIImage]
    let uploadProfileImage: UIImage

    init(userId: Int64, refreshToken: String, deleteUserImageIds: [Int64]? = nil, uploadImages: [UIImage], uploadProfileImage: UIImage) {
        self.userId = userId
        self.refreshToken = refreshToken
        self.deleteUserImageIds = deleteUserImageIds
        self.uploadImages = uploadImages
        self.uploadProfileImage = uploadProfileImage
    }
}

struct GetUserImages: Encodable {
    let refreshToken: String
    let userId: Int64
    
    init(refreshToken: String, userId: Int64) {
        self.refreshToken = refreshToken
        self.userId = userId
    }
}

// click sign up >> post
    
//struct UserProfile: Decodable {
//    var gender: String?
//    var languageNames: [String]?
//    var languageLevels: [String]?
//    var nationality: String?
//    var refreshToken: String?
//    var userAge: Int?
//    var userId: Int64?
//    var userName: String?
//    
//    init(gender: String? = nil, languageNames: [String]? = nil, languageLevels: [String]? = nil, nationality: String? = nil, refreshToken: String? = nil, userAge: Int? = nil, userId: Int64? = nil, userName: String? = nil) {
//        self.gender = gender
//        self.languageNames = languageNames
//        self.languageLevels = languageLevels
//        self.nationality = nationality
//        self.refreshToken = refreshToken
//        self.userAge = userAge
//        self.userId = userId
//        self.userName = userName
//    }
//}

//struct ServiceUserProfile {
//    var age: Int?
//    var gender: String?
//    var city, phone, aboutMe, administrativeArea: String?
//    var interests: [String]?
//    var languageLevels, languageNames: [String]?
//    var latitude: Double?
//    var longtitude: Double?
//    var memberTemp: Double?
//    var name, nationality, profileImg: String?
//    var userId: Int64?
//    var userStatus: String?
//    var login_id: String?
//    var countryEngNm, downloadURL: String?
//
//    init(age: Int? = nil, gender: String? = nil, city: String? = nil, phone: String? = nil, aboutMe: String? = nil, administrativeArea: String? = nil, interests: [String]? = nil, languageLevels: [String]? = nil, languageNames: [String]? = nil, latitude: Double? = nil, longtitude: Double? = nil, memberTemp: Double? = nil, name: String? = nil, nationality: String? = nil, profileImg: String? = nil, userId: Int64? = nil, userStatus: String? = nil, login_id: String? = nil, countryEngNm: String? = nil, downloadURL: String? = nil) {
//        self.age = age
//        self.gender = gender
//        self.city = city
//        self.phone = phone
//        self.aboutMe = aboutMe
//        self.administrativeArea = administrativeArea
//        self.interests = interests
//        self.languageLevels = languageLevels
//        self.languageNames = languageNames
//        self.latitude = latitude
//        self.longtitude = longtitude
//        self.memberTemp = memberTemp
//        self.name = name
//        self.nationality = nationality
//        self.profileImg = profileImg
//        self.userId = userId
//        self.userStatus = userStatus
//        self.login_id = login_id
//        self.countryEngNm = countryEngNm
//        self.downloadURL = downloadURL
//    }
//}
