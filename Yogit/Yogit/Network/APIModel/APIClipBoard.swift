//
//  APIClipBoard.swift
//  Yogit
//
//  Created by Junseo Park on 2022/12/07.
//

import Foundation

struct GetAllClipBoardsReq: Encodable {
    let boardId: Int64
    let cursor: Int
    let refreshToken: String
    let userId: Int64
}

class ClipBoardResInfo: Decodable {
    let getClipBoardResList: [GetAllClipBoardsRes]
    let totalPage: Int
    
    init(getClipBoardResList: [GetAllClipBoardsRes], totalPage: Int) {
        self.getClipBoardResList = getClipBoardResList
        self.totalPage = totalPage
    }
}

class GetAllClipBoardsRes: Decodable {
    let boardID: Int64
    let clipBoardID: Int64
    let commentCnt: Int
    let createdAt, profileImgURL: String
    let commentResList: [String]
    var content: String
    let status, updatedAt: String
    let title: String?
    let userID: Int64
    let userName: String

    enum CodingKeys: String, CodingKey {
        case boardID = "boardId"
        case clipBoardID = "clipBoardId"
        case commentCnt, commentResList, content, createdAt
        case profileImgURL = "profileImgUrl"
        case status, title, updatedAt
        case userID = "userId"
        case userName
    }
    
    init(boardID: Int64, clipBoardID: Int64, commentCnt: Int, createdAt: String, profileImgURL: String, commentResList: [String], content: String, status: String, updatedAt: String, title: String?, userID: Int64, userName: String) {
        self.boardID = boardID
        self.clipBoardID = clipBoardID
        self.commentCnt = commentCnt
        self.createdAt = createdAt
        self.profileImgURL = profileImgURL
        self.commentResList = commentResList
        self.content = content
        self.status = status
        self.updatedAt = updatedAt
        self.title = title
        self.userID = userID
        self.userName = userName
    }
}

struct CreateClipBoardReq: Encodable {
    let boardID: Int64
    let content, refreshToken, title: String
    let userID: Int64

    enum CodingKeys: String, CodingKey {
        case boardID = "boardId"
        case content, refreshToken, title
        case userID = "userId"
    }
    
    init(boardID: Int64, content: String, refreshToken: String, title: String, userID: Int64) {
        self.boardID = boardID
        self.content = content
        self.refreshToken = refreshToken
        self.title = title
        self.userID = userID
    }
}



