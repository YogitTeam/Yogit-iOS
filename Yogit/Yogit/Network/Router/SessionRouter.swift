//
//  SignInRouter.swift
//  Yogit
//
//  Created by Junseo Park on 2023/01/26.
//

import Foundation
import Alamofire

enum SessionRouter: URLRequestConvertible {
    case signUpApple(parameters: Account)
    case logInApple(parameters: LogInAppleReq)
    case logOut(parameters: LogOutAppleReq)
    case deleteApple(parameters: DeleteAppleAccountReq)
    
    var baseURL: URL {
        return URL(string: API.BASE_URL)! 
    }

    var method: HTTPMethod {
        switch self {
        case .signUpApple, .logInApple, .logOut, .deleteApple:
            return .post
        }
    }

    var endPoint: String {
        switch self {
        case .signUpApple:
            return "sign-up/apple"
        case .logInApple:
            return "log-in/apple"
        case .logOut:
            return "users/log-out"
        case .deleteApple:
            return "delete/apple"
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        
        let url = baseURL.appendingPathComponent(endPoint)
    
        print("SessionRouter - asURLRequest() url : \(url)")
        
        var request = URLRequest(url: url)
        
        request.method = method
        
        switch self {
        case let .signUpApple(parameters):
            request = try JSONParameterEncoder().encode(parameters, into: request)
        case let .logInApple(parameters):
            request = try JSONParameterEncoder().encode(parameters, into: request)
        case let .logOut(parameters):
            request = try URLEncodedFormParameterEncoder(destination: .httpBody).encode(parameters, into: request)
        case let .deleteApple(parameters):
            request = try JSONParameterEncoder().encode(parameters, into: request)
        }
        return request
    }
}

