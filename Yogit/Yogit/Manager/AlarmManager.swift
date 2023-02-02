//
//  AlarmManager.swift
//  Yogit
//
//  Created by Junseo Park on 2022/12/13.
//

import Foundation

// Activity Notification >> 신청 알림, 수락 알림
// 신청 알림에는 신청자 userId, boardId 요구
// 신청, 수락 api 리스트 요구 >> acitity notification 탭하면 리스트 불러온다.
// 호스트 멤버 수락 >> 멤버 신청 후 >> acitity notificatio 조회 >> 신청 알림 탭 >> 데이터 읽음(보드제목, 유저 이미지, 이름) >> 유저 프로필 조회 >> 수락 버튼 >> 수락 api 요청
// 같은 모임 신청 총 3번으로 제한
// 참가자 신청 후 취소 >> 호스트가 수락 >> 신청자 취소하였다고 응답 와야함 (해당 사용자가 취소하였습니다.)
// 호스트 신청 수락후 취소 >> 취소 처리 >> 호스트한테 취소 알림


// 참가 신청 >> 대기 (참가 신청후 버튼 disable and 참가 신청 중) 상태 0,1,2
// 참가 취소는, 호스트 수락 완료후 가능
// 참가 신청 최대 1번 가능
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
