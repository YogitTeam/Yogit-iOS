//
//  GatheringBoardManager.swift
//  Yogit
//
//  Created by Junseo Park on 2023/05/01.
//

import Foundation
import RealmSwift

// Join 안함 차단한 유저 모임에 차단 못하게 하기 위해, 따라서 삭제 필요없음 >> 업데이트 되면 차단되서 조회 안됨
class BlockedUser: Object {
    @Persisted(primaryKey: true) var id: Int64
    
    convenience init(id: Int64) {
        self.init()
        self.id = id
    }
}

final class GatheringBoardManager {
    
    static let shared = GatheringBoardManager()
    
    static func saveBlockedUser(blockedUser: BlockedUser) {
        RealmManager.shared.write(blockedUser)
    }
    
    static func isHostBlocked(userId: Int64) -> Bool {
        let userList = RealmManager.shared.read(BlockedUser.self)
        for user in userList {
            if user.id == userId {
                return true
            }
        }
        return false
    }
}



