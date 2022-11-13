//
//  GatheringBoard.swift
//  Yogit
//
//  Created by Junseo Park on 2022/11/11.
//

import Foundation

struct CreateBoardReq: Codable {
    var address: String? = nil
    var categoryId: Int? = nil
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
    
    init(address: String? = nil, categoryId: Int? = nil, cityId: Int? = nil, date: String? = nil, hostId: Int? = nil, images: [String]? = nil, introduction: String? = nil, kindOfPerson: String? = nil, latitude: Double? = nil, longitute: Double? = nil, notice: String? = nil, title: String? = nil, totalMember: Int? = nil) {
        self.address = address
        self.categoryId = categoryId
        self.cityId = cityId
        self.date = date
        self.hostId = hostId
        self.images = images
        self.introduction = introduction
        self.kindOfPerson = kindOfPerson
        self.latitude = latitude
        self.longitute = longitute
        self.notice = notice
        self.title = title
        self.totalMember = totalMember
    }
}
