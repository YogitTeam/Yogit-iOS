//
//  ReportRouter.swift
//  Yogit
//
//  Created by Junseo Park on 2023/01/24.
//
import Foundation
import Alamofire

enum ReportRouter: URLRequestConvertible {
    case reportBoard(parameters: BoardReport)

    var baseURL: URL {
        return URL(string: API.BASE_URL)! // 밑에 Auth 수정해야댐
    }

    var method: HTTPMethod {
        switch self {
        case .reportBoard:
            return .post
        }
    }

    var endPoint: String {
        switch self {
        case .reportBoard:
            return "boardreports"
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
        }
        return request
    }
}

