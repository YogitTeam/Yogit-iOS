//
//   BaseInterceptor.swift
//  Yogit
//
//  Created by Junseo Park on 2022/09/28.
//

import Foundation
import Alamofire

class BaseInterceptor: RequestInterceptor {
    // 
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        print("BaseInterceptor adapt() called")
        var request = urlRequest
        
        // Add header
//        request.addValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
//        request.addValue("application/json; charset=UTF-8", forHTTPHeaderField: "Accept")
        
        completion(.success(request))
    }
    
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        
        print("BaseInterceptor - retry() called")
        guard let statusCode = request.response?.statusCode else {
            completion(.doNotRetry)
            return
        }
        
        
        print("statusCode", statusCode)
        
//        let data = ["statusCode" : statusCode]
        
        switch statusCode {
        case 401:
            print("Unauthorized", statusCode)
        case 429:
            print("Too Many Requests", statusCode)
        case 503:
            print("Service Unavailable", statusCode)
        default: break
        }
        
//        if request.retryCount < 3 {
//            completion(.retry)
//        }
            
            
        // 401: Unauthorized, retry (accessToken을 refresh 하여 재요창)
        // 402 Payment Required
        // 13: TimeOut,
        // 429 Too Many Requests
        // 503 Service Unavailable
//            NotificationCenter.default.post(name: NSNotification.Name(rawValue: NOTIFICATION.API.AUTH_FAIL), object: nil, userInfo: data)
            
        completion(.doNotRetry)
        }
}
