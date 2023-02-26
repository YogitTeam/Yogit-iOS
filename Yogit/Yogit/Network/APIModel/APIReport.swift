//
//  APIReport.swift
//  Yogit
//
//  Created by Junseo Park on 2023/02/11.
//

import Foundation

struct ReportBoardReq: Encodable {
    let content: String
    let refreshToken: String
    let reportType: Int
    let reportedBoardId: Int64
    let reportedUserId: Int64
    let reportingUserId: Int64
    
    init(content: String, refreshToken: String, reportType: Int, reportedBoardId: Int64, reportedUserId: Int64, reportingUserId: Int64) {
        self.content = content
        self.refreshToken = refreshToken
        self.reportType = reportType
        self.reportedBoardId = reportedBoardId
        self.reportedUserId = reportedUserId
        self.reportingUserId = reportingUserId
    }
}

struct ReportUserReq: Encodable {
    let content, refreshToken: String
    let reportType: Int
    let reportedUserId, reportingUserId: Int64
    
    init(content: String, refreshToken: String, reportType: Int, reportedUserId: Int64, reportingUserId: Int64) {
        self.content = content
        self.refreshToken = refreshToken
        self.reportType = reportType
        self.reportedUserId = reportedUserId
        self.reportingUserId = reportingUserId
    }
}

struct ReportClipBoardReq: Encodable {
    let content, refreshToken: String
    let reportType: Int
    let reportedClipBoardId, reportedUserId, reportingUserId: Int64

    
    init(content: String, refreshToken: String, reportType: Int, reportedClipBoardId: Int64, reportedUserId: Int64, reportingUserId: Int64) {
        self.content = content
        self.refreshToken = refreshToken
        self.reportType = reportType
        self.reportedClipBoardId = reportedClipBoardId
        self.reportedUserId = reportedUserId
        self.reportingUserId = reportingUserId
    }
}

struct ReportBoardRes: Decodable {
    let boardReportId: Int64

    enum CodingKeys: String, CodingKey {
        case boardReportId = "boardReportId"
    }
    
    init(boardReportId: Int64) {
        self.boardReportId = boardReportId
    }
}

struct ReportClipBoardRes: Decodable {
    let clipBoardReportId: Int64

    enum CodingKeys: String, CodingKey {
        case clipBoardReportId = "clipBoardReportId"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.clipBoardReportId = try container.decode(Int64.self, forKey: .clipBoardReportId)
    }
}

struct ReportUserRes: Decodable {
    let userReportId: Int64

    enum CodingKeys: String, CodingKey {
        case userReportId = "userReportId"
    }
    
    init(userReportId: Int64) {
        self.userReportId = userReportId
    }
}

