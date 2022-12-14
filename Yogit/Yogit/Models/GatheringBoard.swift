//
//  GatheringBoard.swift
//  Yogit
//
//  Created by Junseo Park on 2022/11/11.
//

import Foundation
import UIKit

enum Mode {
    case post
    case edit
}

// 게시글 이미지 로직
// 등록: images만 요청
// 수정: images 파일 따로, imageIds 따로 요청 (새로 추가된 imagesIds는 -1로)

struct BoardWithMode {
    var mode: Mode?
    var boardReq: CreateBoardReq?
    var boardId: Int64?
    var imageIds: [Int64]?
    var images: [UIImage]?
    
    init(mode: Mode? = nil, boardReq: CreateBoardReq, boardId: Int64?, imageIds: [Int64]?, images: [UIImage]?) {
        self.mode = mode
        self.boardReq = boardReq
        self.boardId = boardId
        self.imageIds = imageIds
        self.images = images
    }
}

//struct CreateBoard: Equatable { // images 제외
//    var hostId: Int64?
//    var title: String?
//    var address: String?
//    var addressDetail: String?
//    var longitute: Double?
//    var latitude: Double?
//    var date: String?
//    var notice: String?
//    var cityName: String?
//    var introduction: String?
//    var kindOfPerson: String?
//    var totalMember: Int?
//    var categoryId: Int?
//    var refreshToken: String?
//    
//    init(hostId: Int64? = nil, title: String? = nil, address: String? = nil, addressDetail: String? = nil, longitute: Double? = nil, latitude: Double? = nil, date: String? = nil, notice: String? = nil, cityName: String? = nil, introduction: String? = nil, kindOfPerson: String? = nil, totalMember: Int? = nil, categoryId: Int? = nil, refreshToken: String? = nil) {
//        self.hostId = hostId
//        self.title = title
//        self.address = address
//        self.addressDetail = addressDetail
//        self.longitute = longitute
//        self.latitude = latitude
//        self.date = date
//        self.notice = notice
//        self.cityName = cityName
//        self.introduction = introduction
//        self.kindOfPerson = kindOfPerson
//        self.totalMember = totalMember
//        self.categoryId = categoryId
//        self.refreshToken = refreshToken
//    }
//}
//
//
//class BoardDetailForEdit {
//    var boardId: Int64?
//    var hostId: Int64?
//    var title: String?
//    var address: String?
//    var addressDetail: String?
//    var longitute: Double?
//    var latitude: Double?
//    var date: String?
//    var notice: String?
//    var cityName: String?
//    var introduction: String?
//    var kindOfPerson: String?
//    var totalMember: Int?
//    var categoryId: Int?
//    var images: [UIImage]?
//    var refreshToken: String?
//
//    init(boardId: Int64? = nil, hostId: Int64? = nil, title: String? = nil, address: String? = nil, addressDetail: String? = nil, longitute: Double? = nil, latitude: Double? = nil, date: String? = nil, notice: String? = nil, cityName: String? = nil, introduction: String? = nil, kindOfPerson: String? = nil, totalMember: Int? = nil, categoryId: Int? = nil, images: [UIImage]? = nil, refreshToken: String? = nil) {
//        self.boardId = boardId
//        self.hostId = hostId
//        self.title = title
//        self.address = address
//        self.addressDetail = addressDetail
//        self.longitute = longitute
//        self.latitude = latitude
//        self.date = date
//        self.notice = notice
//        self.cityName = cityName
//        self.introduction = introduction
//        self.kindOfPerson = kindOfPerson
//        self.totalMember = totalMember
//        self.categoryId = categoryId
//        self.images = images
//        self.refreshToken = refreshToken
//    }
//}
