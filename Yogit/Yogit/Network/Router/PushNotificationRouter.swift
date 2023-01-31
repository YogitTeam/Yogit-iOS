//
//  DeviceTokenRouter.swift
//  Yogit
//
//  Created by Junseo Park on 2023/01/26.
//

import Foundation
import Alamofire

enum PushNotificationRouter: URLRequestConvertible {
    
    case sendDeviceToken(parameters: SendDeviceTokenReq)

    var baseURL: URL {
        return URL(string: API.BASE_URL + "users/")! // 밑에 Auth 수정해야댐
    }

    var method: HTTPMethod {
        switch self {
        case .sendDeviceToken:
            return .post
        }
    }

    var endPoint: String {
        switch self {
        case .sendDeviceToken:
            return "device-token"
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        
        let url = baseURL.appendingPathComponent(endPoint)
    
        print("PushNotificationRouter - asURLRequest() url : \(url)")
        
        var request = URLRequest(url: url)
        
        request.method = method
        
        switch self {
        case let .sendDeviceToken(parameters):
            request = try URLEncodedFormParameterEncoder(destination: .httpBody).encode(parameters, into: request)
        }

        return request
    }
}

