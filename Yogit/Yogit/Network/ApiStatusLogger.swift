//
//  ApiStatusLogger.swift
//  Yogit
//
//  Created by Junseo Park on 2022/10/17.
//

import Foundation

import Foundation
import Alamofire

final class ApiStatusLogger : EventMonitor {
    
    let queue = DispatchQueue(label: "MyApiStatusLogger")
    
//    func requestDidResume(_ request: Request) {
//        print("MyApiStatusLogger - requestDidResume()")
////        debugPrint(request)
//    }
    
    func request<Value>(_ request: DataRequest, didParseResponse response: DataResponse<Value, AFError>) {
        guard let statusCode = request.response?.statusCode else {
            return
        }
        
        print("MyApiStatusLogger - request.didParseResponse() / statusCode : \(statusCode)")
        
//        debugPrint(response)
    }
}
