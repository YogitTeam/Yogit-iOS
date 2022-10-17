//
//  Logger.swift
//  Yogit
//
//  Created by Junseo Park on 2022/10/17.
//

import Foundation
import Alamofire

final class Logger : EventMonitor {
    
    let queue = DispatchQueue(label: "MyLogger")
    
    func requestDidResume(_ request: Request) {
        print("MyLogger - requestDidResume()")
        debugPrint(request)
    }
    
    func request<Value>(_ request: DataRequest, didParseResponse response: DataResponse<Value, AFError>) {
        print("MyLogger - request.didParseResponse()")
        debugPrint(response)
    }
    
    
}

