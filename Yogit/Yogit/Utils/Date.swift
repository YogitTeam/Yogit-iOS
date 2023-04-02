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
        dateFormatter.dateStyle = .full
        dateFormatter.timeStyle = .short
        dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "EEEEdMMMyyyyhhmma", options: 0, locale: dateFormatter.locale)
        dateFormatter.timeZone = .current
        return dateFormatter.string(from: self)
    }
    
    func dateAndMonthFormatter() -> String {
        let dateFormatter = DateFormatter()
        if let localeIdentifier = Locale.preferredLanguages.first {
            dateFormatter.locale = Locale(identifier: localeIdentifier)
        }
        dateFormatter.dateStyle = .full
        dateFormatter.timeStyle = .short
        dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "EdMMMhhmma", options: 0, locale: dateFormatter.locale)
        dateFormatter.timeZone = .current//TimeZone(identifier: "UTC")
        return dateFormatter.string(from: self)
    }
    
    func dateToStringAPI() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        return dateFormatter.string(from: self)
    }
    
    func dateToStringUTC() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        return dateFormatter.string(from: self)
    }
}
