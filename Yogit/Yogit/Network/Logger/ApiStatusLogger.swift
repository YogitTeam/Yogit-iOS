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

    let monitor = NWPathMonitor()
    
    init() {
        monitor.start(queue: queue)
    }
    
    func request(_ request: Request, didCreateURLRequest urlRequest: URLRequest) {
        if monitor.currentPath.status == .unsatisfied {
            request.cancel()
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "NETWORKING_NOT_CONNECTION_TITLE".localized(), message: "NETWORKING_NOT_CONNECTION_MESSAGE".localized(), preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK".localized(), style: .default, handler: nil)
                alert.addAction(okAction)
                
                if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                    windowScene.windows.first?.rootViewController?.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    deinit {
        monitor.cancel()
    }
}
