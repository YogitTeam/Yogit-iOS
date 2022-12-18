//
//  AlarmManager.swift
//  Yogit
//
//  Created by Junseo Park on 2022/12/13.
//

//import Foundation
//
//enum AlarmKey: String {
//    case type = "type"
//    case title = "title"
//    
//    func toKey() -> String {
//        return self.rawValue
//    }
//}
//
//final class AlarmManager {
//    static let shared = AlarmManager()
//    static let alarmIdentifier = "YogitAlarm"
//    
//    static func saveAlarms(alarms: [Alarm]) {
//        let data = alarms.map {
//            [
//                AlarmKey.type.toKey(): $0.type,
//                AlarmKey.title.toKey(): $0.title
//            ]
//        }
//        let userDefaults = UserDefaults.standard
//        userDefaults.set(data, forKey: alarmIdentifier)
//    }
//    
//    static func loadAlarms() {
//        let userDefaults = UserDefaults.standard
//        guard let data = userDefaults.object(forKey: alarmIdentifier) as? [[String: Any]] else { return }
//        let alarms: [Alarm] = data.compactMap {
//            guard let alarmType = $0[AlarmKey.type.toKey()] as? String else { return }
//            guard let alarmTitle = $0[AlarmKey.title.toKey()] as? String else { return }
//            return Alarm(type: alarmType, title: alarmTitle)
//        }
//        print(alarms)
//    }
//}
