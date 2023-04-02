//
//  Board.swift
//  Yogit
//
//  Created by Junseo Park on 2022/11/23.
//

import Foundation

struct GetBoardsByCategoryReq: Encodable {
    let categoryId: Int
    let cursor: Int
    let refreshToken: String
    let userId: Int64
    
    init(categoryId: Int, cursor: Int, refreshToken: String, userId: Int64) {
        self.categoryId = categoryId
        self.cursor = cursor
        self.refreshToken = refreshToken
        self.userId = userId
    }
}



struct GetAllBoardsReq: Encodable {
    let cursor: Int
    let refreshToken: String
    let userId: Int64
    
    init(cursor: Int, refreshToken: String, userId: Int64) {
        self.cursor = cursor
        self.refreshToken = refreshToken
        self.userId = userId
    }
}

struct GetBoardDetail: Encodable {
    let boardId: Int64
    let refreshToken: String
    let userId: Int64
    
    init(boardId: Int64, refreshToken: String, userId: Int64) {
        self.boardId = boardId
        self.refreshToken = refreshToken
        self.userId = userId
    }
}

struct DeleteBoardReq: Encodable {
    let boardId: Int64
    let refreshToken: String
    let hostId: Int64
    
    init(boardId: Int64, refreshToken: String, hostId: Int64) {
        self.boardId = boardId
        self.refreshToken = refreshToken
        self.hostId = hostId
    }
}

struct DeleteBoardRes: Decodable {
    let status: String
    
    init(status: String) {
        self.status = status
    }
}

struct BoardUserReq: Encodable {
    let boardId: Int64
    let refreshToken: String
    let userId: Int64
    
    init(boardId: Int64, refreshToken: String, userId: Int64) {
        self.boardId = boardId
        self.refreshToken = refreshToken
        self.userId = userId
    }
}

struct BoardUserRes: Decodable {
    let boardID, boardUserID, userID: Int
    let userIDS: [Int]
    let userImageUrls: [String]

    enum CodingKeys: String, CodingKey {
        case boardID = "boardId"
        case boardUserID = "boardUserId"
        case userID = "userId"
        case userIDS = "userIds"
        case userImageUrls
    }
}

struct GetMyClub: Encodable {
    let cursor: Int
    let myClubType, refreshToken: String
    let userId: Int64
    
    init(cursor: Int, myClubType: String, refreshToken: String, userId: Int64) {
        self.cursor = cursor
        self.myClubType = myClubType
        self.refreshToken = refreshToken
        self.userId = userId
    }
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

// MARK: - Datum

class GetBoardsByCategoryRes: Decodable {
    let getAllBoardResList: [Board]
    let totalPage: Int
    
    enum CodingKeys: CodingKey {
        case getAllBoardResList
        case totalPage
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.getAllBoardResList = try container.decode([Board].self, forKey: .getAllBoardResList)
        self.totalPage = try container.decode(Int.self, forKey: .totalPage)
    }
}

class Board: Decodable {
    let categoryID, cityID, currentMember: Int
    let date, cityName: String
    let imageID: Int
    let imageURL, status, title: String
    let profileImgUrls: [String]
    let totalMember: Int
    let boardID: Int64

    enum CodingKeys: String, CodingKey {
        case boardID = "boardId"
        case categoryID = "categoryId"
        case cityID = "cityId"
        case currentMember, date
        case imageID = "imageId"
        case imageURL = "imageUrl"
        case profileImgUrls
        case status, title, totalMember
        case cityName
    }

    init(categoryID: Int, cityID: Int, currentMember: Int, date: String, cityName: String, imageID: Int, imageURL: String, profileImgUrls: [String], status: String, title: String, totalMember: Int, boardID: Int64) {
        self.categoryID = categoryID
        self.cityID = cityID
        self.currentMember = currentMember
        self.date = date
        self.cityName = cityName
        self.imageID = imageID
        self.imageURL = imageURL
        self.profileImgUrls = profileImgUrls
        self.status = status
        self.title = title
        self.totalMember = totalMember
        self.boardID = boardID
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
    let hostName: String?
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
    let userImageUrls: [String]
    let userIds: [Int64]?
    let isJoinedUser: Bool

    init(address: String, boardId: Int64, addressDetail: String?, categoryId: Int, categoryName: String, cityId: Int, createdAt: String, currentMember: Int, date: String, hostId: Int64, hostName: String, cityName: String, imageIds: [Int64], imageUrls: [String], introduction: String, kindOfPerson: String, latitude: Double, longitute: Double, profileImgUrl: String, status: String, title: String, notice: String?, totalMember: Int, updatedAt: String, userImageUrls: [String], userIds: [Int64]?, isJoinedUser: Bool) {
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
        self.isJoinedUser = isJoinedUser
    }
}
