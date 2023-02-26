//
//  APIBlock.swift
//  Yogit
//
//  Created by Junseo Park on 2023/02/11.
//

import Foundation

struct UserBlockReq: Encodable {
    let blockedUserID, blockingUserID: Int64
    let refreshToken: String

    enum CodingKeys: String, CodingKey {
        case blockedUserID = "blockedUserId"
        case blockingUserID = "blockingUserId"
        case refreshToken
    }
    
    init(blockedUserID: Int64, blockingUserID: Int64, refreshToken: String) {
        self.blockedUserID = blockedUserID
        self.blockingUserID = blockingUserID
        self.refreshToken = refreshToken
    }
}

struct UserBlockRes: Decodable {
    let blockID, blockedUserID, blockingUserID: Int64

    enum CodingKeys: String, CodingKey {
        case blockID = "blockId"
        case blockedUserID = "blockedUserId"
        case blockingUserID = "blockingUserId"
    }
    
    init(blockID: Int64, blockedUserID: Int64, blockingUserID: Int64) {
        self.blockID = blockID
        self.blockedUserID = blockedUserID
        self.blockingUserID = blockingUserID
    }
}
