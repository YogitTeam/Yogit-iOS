//
//  GatheringBoard.swift
//  Yogit
//
//  Created by Junseo Park on 2022/11/11.
//

import Foundation
import UIKit

enum Mode {
    case post
    case edit
    case create
    case refresh
}

//enum MethodMode {
//    case create
//    case edit
//    case search
//    case upload
//    case delete
//}


// 게시글 이미지 로직
// 등록: images만 요청
// 수정: images 파일 따로, imageIds 따로 요청 (새로 추가된 imagesIds는 -1로)

//struct BoardWithMode {
//    var mode: Mode?
//    var boardReq: CreateBoardReq?
//    var boardId: Int64?
//    var imageIds: [Int64]?
//    var images: [UIImage]?
//
//    init(mode: Mode? = nil, boardReq: CreateBoardReq, boardId: Int64?, imageIds: [Int64]?, images: [UIImage]?) {
//        self.mode = mode
//        self.boardReq = boardReq
//        self.boardId = boardId
//        self.imageIds = imageIds
//        self.images = images
//    }
//}

//struct BoardWithMode {
//    var mode: Mode?
//    var boardReq: CreateBoardReq?
//    var boardId: Int64?
//    var imageIds: [Int64]?
//    var images: [UIImage]?
//
//    var deleteUserImageIds: [Int64]?
//    var uploadImages: [UIImage]
//    var downloadImages: [String]
//    var uploadProfileImage: UIImage?
//    var downloadProfileImage: String?
//    var imageIds: [Int64]
//    var newImagesIdx: Int
//
//    init(deleteUserImageIds: [Int64]? = nil, uploadImages: [UIImage] = [], downloadImages: [String] = [],uploadProfileImage: UIImage? = nil, downloadProfileImage: String? = nil, imageIds: [Int64] = [], newImagesIdx: Int = 0) {
//        self.deleteUserImageIds = deleteUserImageIds
//        self.uploadImages = uploadImages
//        self.downloadImages = downloadImages
//        self.uploadProfileImage = uploadProfileImage
//        self.imageIds = imageIds
//        self.newImagesIdx = newImagesIdx
//    }
//}

struct BoardWithMode {
    var mode: Mode?
    var boardId: Int64?
    var hostId: Int64?
    var title: String?
    var address: String?
    var addressDetail: String?
    var longitute: Double?
    var latitude: Double?
    var date: String?
    var notice: String?
    var cityName: String?
    var introduction: String?
    var kindOfPerson: String?
    var totalMember: Int?
    var categoryId: Int?
    var deleteImageIds: [Int64]? // deleteDownloadImageIds: [Int64]?
    var downloadImages: [String] // downloadBoardImages
    var uploadImages: [UIImage] // uploadBoardImages
    var imageIds: [Int64]
    var memberImages: [String]?
    var currentMember: Int?
    var hostName: String?
    var hostImage: String?
    var isJoinedUser: Bool
  
    init(mode: Mode? = nil, boardId: Int64? = nil,hostId: Int64? = nil, title: String? = nil, address: String? = nil, addressDetail: String? = nil, longitute: Double? = nil, latitude: Double? = nil, date: String? = nil, notice: String? = nil, cityName: String? = nil, introduction: String? = nil, kindOfPerson: String? = nil, totalMember: Int? = nil, categoryId: Int? = nil, deleteImageIds: [Int64]? = nil, downloadImages: [String] = [], uploadImages: [UIImage] = [], imageIds: [Int64] = [], memberImages: [String]? = nil, currentMember: Int? = nil, hostName: String? = nil, hostImage: String? = nil, isJoinedUser: Bool = false) {
        self.mode = mode
        self.hostId = hostId
        self.title = title
        self.address = address
        self.addressDetail = addressDetail
        self.longitute = longitute
        self.latitude = latitude
        self.date = date
        self.notice = notice
        self.cityName = cityName
        self.introduction = introduction
        self.kindOfPerson = kindOfPerson
        self.totalMember = totalMember
        self.categoryId = categoryId
        self.deleteImageIds = deleteImageIds
        self.downloadImages = downloadImages
        self.uploadImages = uploadImages
        self.imageIds = imageIds
        self.currentMember = currentMember
        self.hostName = hostName
        self.isJoinedUser = isJoinedUser
    }
}

struct UpdateBoard {
    let userId: Int64
    let refreshToken: String
    let boardId: Int64?
    let hostId: Int64
    let title: String
    let address: String
    let addressDetail: String?
    let longitute: Double
    let latitude: Double
    let date: String
    let notice: String?
    let cityName: String
    let introduction: String
    let kindOfPerson: String
    let totalMember: Int
    let categoryId: Int
    let deleteImageIds: [Int64]?
    let images: [UIImage]
    
    init(userId: Int64, refreshToken: String, boardId: Int64?, hostId: Int64, title: String, address: String, addressDetail: String?, longitute: Double, latitude: Double, date: String, notice: String?, cityName: String, introduction: String, kindOfPerson: String, totalMember: Int, categoryId: Int, deleteImageIds: [Int64]?, images: [UIImage]) {
        self.userId = userId
        self.refreshToken = refreshToken
        self.boardId = boardId
        self.hostId = hostId
        self.title = title
        self.address = address
        self.addressDetail = addressDetail
        self.longitute = longitute
        self.latitude = latitude
        self.date = date
        self.notice = notice
        self.cityName = cityName
        self.introduction = introduction
        self.kindOfPerson = kindOfPerson
        self.totalMember = totalMember
        self.categoryId = categoryId
        self.deleteImageIds = deleteImageIds
        self.images = images
    }
}

//struct CreateBoard: Equatable { // images 제외
//    var hostId: Int64?
//    var title: String?
//    var address: String?
//    var addressDetail: String?
//    var longitute: Double?
//    var latitude: Double?
//    var date: String?
//    var notice: String?
//    var cityName: String?
//    var introduction: String?
//    var kindOfPerson: String?
//    var totalMember: Int?
//    var categoryId: Int?
//    var refreshToken: String?
//    
//    init(hostId: Int64? = nil, title: String? = nil, address: String? = nil, addressDetail: String? = nil, longitute: Double? = nil, latitude: Double? = nil, date: String? = nil, notice: String? = nil, cityName: String? = nil, introduction: String? = nil, kindOfPerson: String? = nil, totalMember: Int? = nil, categoryId: Int? = nil, refreshToken: String? = nil) {
//        self.hostId = hostId
//        self.title = title
//        self.address = address
//        self.addressDetail = addressDetail
//        self.longitute = longitute
//        self.latitude = latitude
//        self.date = date
//        self.notice = notice
//        self.cityName = cityName
//        self.introduction = introduction
//        self.kindOfPerson = kindOfPerson
//        self.totalMember = totalMember
//        self.categoryId = categoryId
//        self.refreshToken = refreshToken
//    }
//}
//
//
//class BoardDetailForEdit {
//    var boardId: Int64?
//    var hostId: Int64?
//    var title: String?
//    var address: String?
//    var addressDetail: String?
//    var longitute: Double?
//    var latitude: Double?
//    var date: String?
//    var notice: String?
//    var cityName: String?
//    var introduction: String?
//    var kindOfPerson: String?
//    var totalMember: Int?
//    var categoryId: Int?
//    var images: [UIImage]?
//    var refreshToken: String?
//
//    init(boardId: Int64? = nil, hostId: Int64? = nil, title: String? = nil, address: String? = nil, addressDetail: String? = nil, longitute: Double? = nil, latitude: Double? = nil, date: String? = nil, notice: String? = nil, cityName: String? = nil, introduction: String? = nil, kindOfPerson: String? = nil, totalMember: Int? = nil, categoryId: Int? = nil, images: [UIImage]? = nil, refreshToken: String? = nil) {
//        self.boardId = boardId
//        self.hostId = hostId
//        self.title = title
//        self.address = address
//        self.addressDetail = addressDetail
//        self.longitute = longitute
//        self.latitude = latitude
//        self.date = date
//        self.notice = notice
//        self.cityName = cityName
//        self.introduction = introduction
//        self.kindOfPerson = kindOfPerson
//        self.totalMember = totalMember
//        self.categoryId = categoryId
//        self.images = images
//        self.refreshToken = refreshToken
//    }
//}
