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
    
    // interceptor: Call api >> intercept >> input common parameter / check auth / add header
     let interceptors = Interceptor(interceptors: [
        BaseInterceptor()
     ])
    
    // setup logger: event monitor
    let monitors = [Logger(), ApiStatusLogger()] as [EventMonitor]
    
    // setup sesstion
    var session: Session
    private init() {
        session = Session(interceptor: interceptors)
    }
    
}
