//
//  ApiStatusLogger.swift
//  Yogit
//
//  Created by Junseo Park on 2022/10/17.
//

import Foundation
import Alamofire
import Network

final class ApiStatusLogger: EventMonitor {
    
    let queue = DispatchQueue(label: "ApiStatussMonitor")
    //    let queue = DispatchQueue.global(qos: .background)
    let monitor = NWPathMonitor()
    
    init() {
        monitor.start(queue: queue)
    }
    
    func request(_ request: Request, didCreateURLRequest urlRequest: URLRequest) {
        if monitor.currentPath.status == .unsatisfied {
            request.cancel()
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "No Internet Connection", message: "Please connect to the internet and try again.", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(okAction)
                
                if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                    windowScene.windows.first?.rootViewController?.present(alert, animated: true, completion: nil)
                }
            }
        }
        //        monitor.cancel()
    }
}
