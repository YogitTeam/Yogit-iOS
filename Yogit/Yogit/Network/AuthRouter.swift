//
//  MyAuthRouter.swift
//  Yogit
//
//  Created by Junseo Park on 2022/09/29.
//

import Foundation
import Alamofire


enum AuthRouter: URLRequestConvertible {
    
    case auth(term: String)
    case user(term: String) // another
 
    var baseURL: URL {
        return URL(string: API.BASE_URL + "Auth/")! // 밑에 Auth 수정해야댐
    }

    var method: HTTPMethod {
        
//        return .get
        
        switch self {
        case .auth:
            return .post
        case .user:
            return .get
        }
//        switch self {
//        case .searchPhotos:
//            return .get
//        case .searchUsers:
//            return .post
//        }
    }

    var endPoint: String {
        switch self {
        case .auth:
            return "Auth/"
        case .user:
            return "User/" // need modify
        }
    }
    
//

    func asURLRequest() throws -> URLRequest {
        
        let url = baseURL.appendingPathComponent(endPoint)
        
        print("AuthRouter - asURLRequest() url : \(url)")
        
        var request = URLRequest(url: url)
        
        request.method = method
        
        switch self {
        case let .auth(parameters):
//            request = try URLEncodedFormParameterEncoder().encode(parameters, into: request)
            request = try URLEncodedFormParameterEncoder(destination: .httpBody).encode(parameters, into: request)
        case let .user(parameters):
            request = try JSONParameterEncoder().encode(parameters, into: request)
        }
        
//        request = try URLEncodedFormParameterEncoder().encode(parameters, into: request)
        
        return request
    }
}
