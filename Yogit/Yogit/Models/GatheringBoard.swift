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

struct BoardWithMode {
    var mode: Mode?
    var userIds: [Int64]?
    var boardId: Int64?
    var hostId: Int64?
    var title: String?
    var address: String?
    var addressDetail: String?
    var longitute: Double?
    var latitude: Double?
    var date: String?
    var notice: String?
    var city: String?
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
  
    init(mode: Mode? = nil, userIds: [Int64]? = nil, boardId: Int64? = nil,hostId: Int64? = nil, title: String? = nil, address: String? = nil, addressDetail: String? = nil, longitute: Double? = nil, latitude: Double? = nil, date: String? = nil, notice: String? = nil, city: String? = nil, introduction: String? = nil, kindOfPerson: String? = nil, totalMember: Int? = nil, categoryId: Int? = nil, deleteImageIds: [Int64]? = nil, downloadImages: [String] = [], uploadImages: [UIImage] = [], imageIds: [Int64] = [], memberImages: [String]? = nil, currentMember: Int? = nil, hostName: String? = nil, hostImage: String? = nil, isJoinedUser: Bool = false) {
        self.mode = mode
        self.userIds = userIds
        self.hostId = hostId
        self.title = title
        self.address = address
        self.addressDetail = addressDetail
        self.longitute = longitute
        self.latitude = latitude
        self.date = date
        self.notice = notice
        self.city = city
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
