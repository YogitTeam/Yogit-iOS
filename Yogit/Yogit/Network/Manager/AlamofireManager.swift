//
//  MyAlamofireManager.swift
//  Yogit
//
//  Created by Junseo Park on 2022/09/28.
//

import Foundation
import Alamofire

final class AlamofireManager {
    // singleton 
    static let shared = AlamofireManager()
    
//    // interceptor: Call api >> intercept >> input common parameter / check auth / add header
//    let interceptors = Interceptor(interceptors: [BaseInterceptor()])
//
//    // setup logger: event monitor
//    let monitors = [Logger(), ApiStatusLogger()] as [EventMonitor]
    
   
    // setup sesstion
//    var session: Session
//    private init() {
//        session = Session(
//                    interceptor: interceptors,
//                    eventMonitors: monitors
//                )
//    }
    
    let session: Session = {
        let configuration = URLSessionConfiguration.af.default
        configuration.timeoutIntervalForRequest = 30
        let interceptors = Interceptor(interceptors: [BaseInterceptor()])
        let monitors = [Logger(), ApiStatusLogger()] as [EventMonitor]
      return Session(configuration: configuration, interceptor: interceptors, eventMonitors: monitors)
    }()
}
