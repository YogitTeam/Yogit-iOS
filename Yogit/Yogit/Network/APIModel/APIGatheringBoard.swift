//
//  Board.swift
//  Yogit
//
//  Created by Junseo Park on 2022/11/23.
//

import Foundation

struct GetAllBoardsReq: Encodable {
    let cursor: Int
    let refreshToken: String
    let userId: Int64
}

struct GetBoardDetail: Encodable {
    let boardId: Int64
    let refreshToken: String
    let userId: Int64
}

struct ApplyGathering: Encodable {
    let boardId: Int64
    let refreshToken: String
    let userId: Int64
}

struct CreateBoardReq: Encodable { // images 제외
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
    var refreshToken: String?
    
    init(hostId: Int64? = nil, title: String? = nil, address: String? = nil, addressDetail: String? = nil, longitute: Double? = nil, latitude: Double? = nil, date: String? = nil, notice: String? = nil, cityName: String? = nil, introduction: String? = nil, kindOfPerson: String? = nil, totalMember: Int? = nil, categoryId: Int? = nil, refreshToken: String? = nil) {
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
        self.refreshToken = refreshToken
    }
}

struct DeleteBoardImageReq: Encodable {
    let boardId: Int64
    let boardImageId: Int64
    let refreshToken: String
    let userId: Int64

    init(boardId: Int64, boardImageId: Int64, refreshToken: String, userId: Int64) {
        self.boardId = boardId
        self.boardImageId = boardImageId
        self.refreshToken = refreshToken
        self.userId = userId
    }
}


struct BoardReport: Encodable {
    let content: String
    let refreshToken: String
    let reportType: String
    let reportedBoardID: Int64
    let reportedUserID: Int64
    let reportingUserID: Int64
    
    init(content: String, refreshToken: String, reportType: String, reportedBoardID: Int64, reportedUserID: Int64, reportingUserID: Int64) {
        self.content = content
        self.refreshToken = refreshToken
        self.reportType = reportType
        self.reportedBoardID = reportedBoardID
        self.reportedUserID = reportedUserID
        self.reportingUserID = reportingUserID
    }
}

class APIBoardResponse: Decodable {
    let data: [[Board]]
    let httpCode: Int
    let httpStatus, localDateTime, message: String
    let success: Bool

    init(data: [[Board]], httpCode: Int, httpStatus: String, localDateTime: String, message: String, success: Bool) {
        self.data = data
        self.httpCode = httpCode
        self.httpStatus = httpStatus
        self.localDateTime = localDateTime
        self.message = message
        self.success = success
    }
}

// MARK: - Datum
class Board: Decodable {
    let categoryID, cityID, currentMember: Int
    let date: String
    let imageID: Int
    let imageURL, profileImgURL, status, title: String
    let totalMember: Int
    let boardID: Int64

    enum CodingKeys: String, CodingKey {
        case boardID = "boardId"
        case categoryID = "categoryId"
        case cityID = "cityId"
        case currentMember, date
        case imageID = "imageId"
        case imageURL = "imageUrl"
        case profileImgURL = "profileImgUrl"
        case status, title, totalMember
    }

    init(boardID: Int64, categoryID: Int, cityID: Int, currentMember: Int, date: String, imageID: Int, imageURL: String, profileImgURL: String, status: String, title: String, totalMember: Int) {
        self.boardID = boardID
        self.categoryID = categoryID
        self.cityID = cityID
        self.currentMember = currentMember
        self.date = date
        self.imageID = imageID
        self.imageURL = imageURL
        self.profileImgURL = profileImgURL
        self.status = status
        self.title = title
        self.totalMember = totalMember
    }
}

// when edit the board, convey after data convert to next vc struct createboardreq
class BoardDetail: Decodable {
    let address: String
    let boardId: Int64
    let addressDetail: String?
    let categoryId: Int
    let categoryName: String
    let cityId: Int
    let createdAt: String
    let currentMember: Int
    let date: String
    let hostId: Int64
    let hostName: String
    let cityName: String
    let imageIds: [Int64]
    let imageUrls: [String]
    let introduction, kindOfPerson: String
    let latitude: Double
    let longitute: Double
    let profileImgUrl, status, title: String
    let notice: String?
    let totalMember: Int
    let updatedAt: String
    let userImageUrls: [String]?
    let userIds: [Int64]?

    init(address: String, boardId: Int64, addressDetail: String?, categoryId: Int, categoryName: String, cityId: Int, createdAt: String, currentMember: Int, date: String, hostId: Int64, hostName: String, cityName: String, imageIds: [Int64], imageUrls: [String], introduction: String, kindOfPerson: String, latitude: Double, longitute: Double, profileImgUrl: String, status: String, title: String, notice: String?, totalMember: Int, updatedAt: String, userImageUrls: [String]?, userIds: [Int64]?) {
        self.address = address
        self.boardId = boardId
        self.addressDetail = addressDetail
        self.categoryId = categoryId
        self.categoryName = categoryName
        self.cityId = cityId
        self.createdAt = createdAt
        self.currentMember = currentMember
        self.date = date
        self.hostId = hostId
        self.hostName = hostName
        self.cityName = cityName
        self.imageIds = imageIds
        self.imageUrls = imageUrls
        self.introduction = introduction
        self.kindOfPerson = kindOfPerson
        self.latitude = latitude
        self.longitute = longitute
        self.profileImgUrl = profileImgUrl
        self.status = status
        self.title = title
        self.notice = notice
        self.totalMember = totalMember
        self.updatedAt = updatedAt
        self.userImageUrls = userImageUrls
        self.userIds = userIds
    }
}
