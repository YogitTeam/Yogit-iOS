//
//  ReportRouter.swift
//  Yogit
//
//  Created by Junseo Park on 2023/01/24.
//
import Foundation
import Alamofire

enum ReportRouter: URLRequestConvertible {
    case reportBoard(parameters: ReportBoardReq)
    case reportClipBoard(parameters: ReportClipBoardReq)
    case reportUser(parameters: ReportUserReq)

    var baseURL: URL {
        return URL(string: API.BASE_URL)! // 밑에 Auth 수정해야댐
    }

    var method: HTTPMethod {
        return .post
    }

    var endPoint: String {
        switch self {
        case .reportBoard:
            return "boardreports"
        case .reportClipBoard:
            return "clipboardreports"
        case .reportUser:
            return "userreports"
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        
        let url = baseURL.appendingPathComponent(endPoint)
    
        print("BoardRouter - asURLRequest() url : \(url)")
        
        var request = URLRequest(url: url)
        
        request.method = method
        
        switch self {
        case let .reportBoard(parameters):
            request = try JSONParameterEncoder().encode(parameters, into: request)
        case let .reportClipBoard(parameters):
            request = try JSONParameterEncoder().encode(parameters, into: request)
        case let .reportUser(parameters):
            request = try JSONParameterEncoder().encode(parameters, into: request)
        }
        return request
    }
}

