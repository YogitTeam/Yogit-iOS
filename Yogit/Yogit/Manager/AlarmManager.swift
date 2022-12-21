//
//  AlarmManager.swift
//  Yogit
//
//  Created by Junseo Park on 2022/12/13.
//

import Foundation

final class AlarmManager {
    enum AlarmKey: String {
        case type = "type"
        case title = "title"
        case body = "body"
        case id = "id"
        
        func toKey() -> String {
            return self.rawValue
        }
    }
    
    enum AlarmType: String {
        case apply = "JOINAPPLY"
        case clipBoard = "CLIPBOARD"
        
        func toKey() -> String {
            return self.rawValue
        }
    }
    
    static let shared = AlarmManager()
    static let ApplyAlarmIdentifier = "ApplyAlarm"
    static let ClipBoardAlarmIdentifier = "ClipBoardAlarm"
    
    static func saveAlarms(alarms: [Alarm]) {
        let data = alarms.map {
            [
                AlarmKey.type.toKey(): $0.type,
                AlarmKey.title.toKey(): $0.title,
                AlarmKey.body.toKey():$0.body,
                AlarmKey.id.toKey(): $0.id
            ]
        }
        let userDefaults = UserDefaults.standard
        if alarms[0].type == AlarmType.apply.toKey() { userDefaults.set(data, forKey: ApplyAlarmIdentifier) }
        else { userDefaults.set(data, forKey: ClipBoardAlarmIdentifier) }
        print("AfterSaveAlarms", data)
    }
    
//    static func saveAlarms(alarm: Alarm) {
//        let data = [
//            AlarmKey.type.toKey(): alarm.type,
//            AlarmKey.title.toKey(): alarm.title,
//            AlarmKey.body.toKey(): alarm.body,
//            AlarmKey.id.toKey(): alarm.id
//        ] as [String : Any]
//        let userDefaults = UserDefaults.standard.array(forKey: alarmIdentifier) as? [String : Any]
////        userDefaults.set(data, forKey: alarmIdentifier)
//    }
    
    static func loadAlarms(type: String) -> [Alarm]? {
        let userDefaults = UserDefaults.standard
        var id = String()
        if type == AlarmType.apply.toKey() {
            id = ApplyAlarmIdentifier
        } else {
            id = ClipBoardAlarmIdentifier
        }
        let data = userDefaults.object(forKey: id) as? [[String: Any]] ?? [[String: Any]]()
        let alarms: [Alarm] = data.compactMap {
            Alarm(type: $0[AlarmKey.type.toKey()] as! String, title: $0[AlarmKey.title.toKey()] as! String, body: $0[AlarmKey.body.toKey()] as! String, id: $0[AlarmKey.id.toKey()] as! Int64)
//            guard let alarmType = $0[AlarmKey.type.toKey()] as? String else { return }
//            guard let alarmTitle = $0[AlarmKey.title.toKey()] as? String else { return }
//            guard let alarmId = $0[AlarmKey.id.toKey()] as? Int64 else { return }
//            Alarm(type: alarmType, title: alarmTitle, id: alarmId)
        }
        print("loadAlarms", alarms)
        return alarms
    }
}
