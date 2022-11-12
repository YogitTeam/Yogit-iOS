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
    var cityId: Int? = nil
    var date: String? = nil
    var hostId: Int? = nil
    var images: [String]? = []
    var introduction: String? = nil
    var kindOfPerson: String? = nil
    var latitude: Double? = nil
    var longitute: Double? = nil
    var notice: String? = nil
    var title: String? = nil
    var totalMember: Int? = nil
    
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
