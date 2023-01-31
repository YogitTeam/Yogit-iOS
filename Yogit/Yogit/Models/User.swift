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

