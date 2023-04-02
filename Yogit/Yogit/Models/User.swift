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
    var downloadProfileImage: String?
    var imageIds: [Int64]

    init(deleteUserImageIds: [Int64]? = nil, uploadImages: [UIImage] = [], downloadImages: [String] = [], uploadProfileImage: UIImage? = nil, downloadProfileImage: String? = nil, imageIds: [Int64] = []) {
        self.deleteUserImageIds = deleteUserImageIds
        self.uploadImages = uploadImages
        self.downloadImages = downloadImages
        self.uploadProfileImage = uploadProfileImage
        self.imageIds = imageIds
    }
}

struct PatchUserImages {
    let userId: Int64
    let refreshToken: String
    let deleteUserImageIds: [Int64]?
    let uploadImages: [UIImage]
    let uploadProfileImage: UIImage?

    init(userId: Int64, refreshToken: String, deleteUserImageIds: [Int64]?, uploadImages: [UIImage], uploadProfileImage: UIImage?) {
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


struct FetchUserProfile: Decodable {
    let city, aboutMe, job, phone: String?
    let age: Int?
    let imageUrls: [String]
    let interests: [String]?
    let languageCodes: [String]
    let languageLevels: [Int]
    let latitude, longtitude, memberTemp: Double?
    let name, nationality, gender: String?
    let profileImg: String
    let userId: Int
    let userStatus: String?
    let isBlockingUser: Int?

    enum CodingKeys: String, CodingKey {
        case aboutMe, age, city
        case gender, imageUrls, interests, job, languageLevels, languageCodes, latitude, longtitude, memberTemp, name, nationality, phone, profileImg
        case userId
        case userStatus
        case isBlockingUser
    }
    
    init(city: String?, aboutMe: String?, job: String?, phone: String?, age: Int?, imageUrls: [String], interests: [String]?, languageLevels: [Int], languageCodes: [String], latitude: Double?, longtitude: Double?, memberTemp: Double?, name: String?, nationality: String?, profileImg: String, gender: String?, userId: Int, userStatus: String?, isBlockingUser: Int?) {
        self.city = city
        self.aboutMe = aboutMe
        self.job = job
        self.phone = phone
        self.age = age
        self.imageUrls = imageUrls
        self.interests = interests
        self.languageLevels = languageLevels
        self.languageCodes = languageCodes
        self.latitude = latitude
        self.longtitude = longtitude
        self.memberTemp = memberTemp
        self.name = name
        self.nationality = nationality
        self.profileImg = profileImg
        self.gender = gender
        self.userId = userId
        self.userStatus = userStatus
        self.isBlockingUser = isBlockingUser
    }
}
