//
//  NeworkMoniter.swift
//  Yogit
//
//  Created by Junseo Park on 2023/02/04.
//

import Foundation
import Network
import UIKit

final class NetworkMonitor {
    private let queue = DispatchQueue.global(qos: .background)
    private let monitor: NWPathMonitor
    
    init() {
        monitor = NWPathMonitor()
        dump(monitor)
        print("------------")
    }
    
    func startMonitoring(statusUpdateHandler: @escaping (NWPath.Status) -> Void) {
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                // Network is available
            } else {
                // Network is not available
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "No Internet Connection", message: "Please connect to the internet and try again.", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alert.addAction(okAction)

                    // Present the alert on all view controllers
                    UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true, completion: nil)
                }
            }
        }
        monitor.start(queue: queue)
    }
    
    func stopMonitoring() {
        monitor.cancel()
    }
}
