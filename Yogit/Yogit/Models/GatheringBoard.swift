//
//  GatheringBoard.swift
//  Yogit
//
//  Created by Junseo Park on 2022/11/11.
//

import Foundation
import UIKit

// formdata로 통신전 
struct CreateBoardReq {
    var cityId: Int?
    var hostId: Int?
    var title: String?
    var address: String?
    var addressDetail: String?
    var longitute: Double?
    var latitude: Double?
    var date: String?
    var notice: String?
    var city: String?
    var introduction: String?
    var kindOfPerson: String?
    var totalMember: Int?
    var categoryId: Int?
    var images: [UIImage]?
    
    init(address: String? = nil, categoryId: Int? = nil, cityId: Int? = nil, date: String? = nil, hostId: Int? = nil, images: [UIImage]? = nil, introduction: String? = nil, kindOfPerson: String? = nil, latitude: Double? = nil, longitute: Double? = nil, notice: String? = nil, title: String? = nil, totalMember: Int? = nil) {
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
