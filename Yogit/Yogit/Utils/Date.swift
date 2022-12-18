//
//  Date.swift
//  Yogit
//
//  Created by Junseo Park on 2022/11/29.
//

import Foundation

extension Date {
    func dateToStringUser() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E, MMM d, h:mm a"
        return dateFormatter.string(from: self)
    }
    
    func dateToStringAPI() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
        return dateFormatter.string(from: self)
    }
}
