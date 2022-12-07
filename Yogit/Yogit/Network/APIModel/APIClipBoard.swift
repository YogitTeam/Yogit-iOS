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

struct GetAllClipBoardsRes: Decodable {
    let boardID: Int64
    let clipBoardID: Int64
    let commentCnt: Int
    let commentResList, content, createdAt, profileImgURL: String
    let status, title, updatedAt: String
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
    
    init(boardID: Int64, clipBoardID: Int64, commentCnt: Int, commentResList: String, content: String, createdAt: String, profileImgURL: String, status: String, title: String, updatedAt: String, userID: Int64, userName: String) {
        self.boardID = boardID
        self.clipBoardID = clipBoardID
        self.commentCnt = commentCnt
        self.commentResList = commentResList
        self.content = content
        self.createdAt = createdAt
        self.profileImgURL = profileImgURL
        self.status = status
        self.title = title
        self.updatedAt = updatedAt
        self.userID = userID
        self.userName = userName
    }
}
