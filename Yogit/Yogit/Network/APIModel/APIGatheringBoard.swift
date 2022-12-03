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
    let boardId: Int
    let refreshToken: String
    let userId: Int64
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
class Board: Codable {
    let boardID, categoryID, cityID, currentMember: Int
    let date: String
    let imageID: Int
    let imageURL, profileImgURL, status, title: String
    let totalMember: Int

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

    init(boardID: Int, categoryID: Int, cityID: Int, currentMember: Int, date: String, imageID: Int, imageURL: String, profileImgURL: String, status: String, title: String, totalMember: Int) {
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
    let addressDetail: String?
    let boardID, categoryID: Int
    let categoryName: String
    let cityID: Int
    let createdAt: String
    let currentMember: Int
    let date: String
    let hostID: Int64
    let hostName: String
    let imageIDS: [Int]
    let imageUrls: [String]
    let introduction, kindOfPerson: String
    let latitude: Double
    let longitute: Double
    let profileImgURL, status, title: String
    let notice: String?
    let totalMember: Int
    let updatedAt: String

    enum CodingKeys: String, CodingKey {
        case address, addressDetail
        case boardID = "boardId"
        case categoryID = "categoryId"
        case categoryName
        case cityID = "cityId"
        case createdAt, currentMember, date
        case hostID = "hostId"
        case hostName
        case imageIDS = "imageIds"
        case imageUrls, introduction, kindOfPerson, latitude, longitute, notice
        case profileImgURL = "profileImgUrl"
        case status, title, totalMember, updatedAt
    }

    init(address: String, addressDetail: String?, boardID: Int, categoryID: Int, categoryName: String, cityID: Int, createdAt: String, currentMember: Int, date: String, hostID: Int64, hostName: String, imageIDS: [Int], imageUrls: [String], introduction: String, kindOfPerson: String, latitude: Double, longitute: Double, profileImgURL: String, status: String, title: String, notice: String?, totalMember: Int, updatedAt: String) {
        self.address = address
        self.addressDetail = addressDetail
        self.boardID = boardID
        self.categoryID = categoryID
        self.categoryName = categoryName
        self.cityID = cityID
        self.createdAt = createdAt
        self.currentMember = currentMember
        self.date = date
        self.hostID = hostID
        self.hostName = hostName
        self.imageIDS = imageIDS
        self.imageUrls = imageUrls
        self.introduction = introduction
        self.kindOfPerson = kindOfPerson
        self.latitude = latitude
        self.longitute = longitute
        self.profileImgURL = profileImgURL
        self.status = status
        self.title = title
        self.notice = notice
        self.totalMember = totalMember
        self.updatedAt = updatedAt
    }
}

