//
//  Board.swift
//  Yogit
//
//  Created by Junseo Park on 2022/11/23.
//

import Foundation

struct GetAllBoardsReq: Codable {
    let cursor: Int
    let userId: Int
}

