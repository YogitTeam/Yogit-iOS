//
//  BlockRouter.swift
//  Yogit
//
//  Created by Junseo Park on 2023/02/11.
//

import Foundation
import Alamofire

enum BlockRouter: URLRequestConvertible {
    case blockUser(parameters: UserBlockReq)

    var baseURL: URL {
        return URL(string: API.BASE_URL)! 
    }

    var method: HTTPMethod {
        switch self {
        case .blockUser:
            return .post
        }
    }

    var endPoint: String {
        switch self {
        case .blockUser:
            return "blocks"
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        
        let url = baseURL.appendingPathComponent(endPoint)
    
        print("BlockRouter - asURLRequest() url : \(url)")
        
        var request = URLRequest(url: url)
        
        request.method = method
        
        switch self {
        case let .blockUser(parameters):
            request = try JSONParameterEncoder().encode(parameters, into: request)
        }
        return request
    }
}
