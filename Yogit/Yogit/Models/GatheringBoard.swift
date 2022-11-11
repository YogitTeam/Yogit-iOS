//
//  GatheringBoard.swift
//  Yogit
//
//  Created by Junseo Park on 2022/11/11.
//

import Foundation

struct CreateBoardReq: Codable {
    var address: String?
    var categoryId: Int?
    var cityId: Int?
    var date: String?
    var hostId: Int?
    var images: [String]?
    var introduction: String?
    var kindOfPerson: String?
    var latitude: Double?
    var longitute: Double?
    var notice: String?
    var title: String?
    var totalMember: Int?
}
