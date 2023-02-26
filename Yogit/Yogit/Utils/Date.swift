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
        if let localeIdentifier = Locale.preferredLanguages.first {
            dateFormatter.locale = Locale(identifier: localeIdentifier)
        }
//        dateFormatter.dateFormat = "E, MMM d, h:mm a"
        dateFormatter.dateStyle = .full
        dateFormatter.timeStyle = .short
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        return dateFormatter.string(from: self)
    }
    
    func dateToStringUser2() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY, MMM d, h:mm a"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        return dateFormatter.string(from: self)
    }
    
    func dateToStringAPI() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        return dateFormatter.string(from: self)
    }
}
