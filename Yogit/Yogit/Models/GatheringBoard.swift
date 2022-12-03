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
    var images: [UIImage]?
    
    init(hostId: Int64? = nil, title: String? = nil, address: String? = nil, addressDetail: String? = nil, longitute: Double? = nil, latitude: Double? = nil, date: String? = nil, notice: String? = nil, cityName: String? = nil, introduction: String? = nil, kindOfPerson: String? = nil, totalMember: Int? = nil, categoryId: Int? = nil, images: [UIImage]? = nil) {
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
        self.images = images
    }
}
