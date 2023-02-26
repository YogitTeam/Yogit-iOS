//
//  APIConstants.swift
//  Yogit
//
//  Created by Junseo Park on 2022/11/23.
//

import Foundation

class APIResponse<T: Decodable> : Decodable {
    let data: T?
    let httpCode: Int?
    let httpStatus, localDateTime, message, errorCode: String?
    let success: Bool?
    
    init(data: Codable?, httpCode: Int?, httpStatus: String?, localDateTime: String?, message: String?, errorCode: String?, success: Bool?) {
        self.data = data as? T
        self.httpCode = httpCode
        self.httpStatus = httpStatus
        self.localDateTime = localDateTime
        self.message = message
        self.errorCode = errorCode
        self.success = success
    }
}



