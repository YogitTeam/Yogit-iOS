//
//  BoardMemberRouter.swift
//  Yogit
//
//  Created by Junseo Park on 2023/01/31.
//

import Foundation
import Alamofire

enum BoardUserRouter: URLRequestConvertible {
    case joinGatheringBoard(parameters: BoardUserReq)
    case withdrawalGatheringBoard(parameters: BoardUserReq)
    case approveGatheringBoard(parameters: BoardUserReq)

    var baseURL: URL {
        return URL(string: API.BASE_URL + "boardusers")! // 밑에 Auth 수정해야댐
    }

    var method: HTTPMethod {
        switch self {
        case .joinGatheringBoard:
            return .post
        case .withdrawalGatheringBoard, .approveGatheringBoard:
            return .patch
        }
    }

    var endPoint: String {
        switch self {
        case .joinGatheringBoard, .withdrawalGatheringBoard:
            return ""
        case .approveGatheringBoard:
            return "/applystatus"
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        
        let url = baseURL.appendingPathComponent(endPoint)
    
        print("BoardRouter - asURLRequest() url : \(url)")
        
        var request = URLRequest(url: url)
        
        request.method = method
        
        switch self {
        case let .joinGatheringBoard(parameters):
            request = try JSONParameterEncoder().encode(parameters, into: request)
        case let .withdrawalGatheringBoard(parameters):
            request = try JSONParameterEncoder().encode(parameters, into: request)
        case let .approveGatheringBoard(parameters):
            request = try JSONParameterEncoder().encode(parameters, into: request)
        }
        return request
    }
}
