//
//  PushNotificationManager.swift
//  Yogit
//
//  Created by Junseo Park on 2023/04/17.
//

import Foundation
import UIKit
import RealmSwift

class PushNotification: Object {
    @Persisted(primaryKey: true) var id: Int
    @Persisted var type: String
    @Persisted var title: String
    @Persisted var body: String
    @Persisted var args: List<String>
    @Persisted var boardId: Int64
    @Persisted var time: String
    @Persisted var isOpened: Bool
    
    var argArray: [String] {
        get {
            return args.map{$0}
        }
        set {
            args.removeAll()
            args.append(objectsIn: newValue)
        }
    }
    
    convenience init(id: Int, type: String, title: String, body: String, argArray: Array<String>, boardId: Int64, time: String, isOpened: Bool) {
        self.init()
        self.id = id
        self.type = type
        self.title = title
        self.body = body
        self.argArray = argArray
        self.boardId = boardId
        self.time = time
        self.isOpened = isOpened
    }
}

final class PushNotificationManager {
    enum NotiKey: String {
        case type = "type"
        case title = "title"
        case body = "body"
        case args = "args"
        case boardId = "boardId"
        case time = "time"
        
        func toKey() -> String {
            return self.rawValue
        }
    }
    
    enum NotiType: String {
        case apply = "JOINAPPLY" // JOINAPPLY
        case withdrawl = "DELAPPLY" // DELAPPLY
        case clipBoard = "CREATE_CLIPBOARD" // CREATE_CLIPBOARD
        
        func toKey() -> String {
            return self.rawValue
        }
    }
    
    static let shared = PushNotificationManager()
    
    static func saveNotification(noti: PushNotification) {
        let notiList = loadNotifications()
        noti.id = (notiList.last?.id ?? 0) + 1
        RealmManager.shared.write(noti)
        NotificationCenter.default.post(name: .notiRefresh, object: noti.type)
    }
    
    static func loadNotificationsByType(type: String) -> [PushNotification] {
        var notiList = RealmManager.shared.sort(PushNotification.self, by: "time", ascending: false) // 날짜 순 리버스
        if type == NotiType.clipBoard.toKey() {
            notiList = notiList.filter("type == %@", type)
        } else {
            notiList = notiList.filter("type != %@", NotiType.clipBoard.toKey()) // apply, withdrawl 한 쌍으로 유저에게 보여줌
        }
        var list: [PushNotification] = []
        notiList.forEach { list.append($0) }
        return list
    }
    
    static func loadNotifications() -> [PushNotification] {
        let notiList = RealmManager.shared.read(PushNotification.self)
        var list: [PushNotification] = []
        notiList.forEach { list.append($0) }
        return list
    }
    
    static func updateIsOpened(id: Int, completion: @escaping (PushNotification) -> Void) {
        let element = RealmManager.shared.read(PushNotification.self)[id-1] // 인덱스 0부터 셈
        RealmManager.shared.update(element) { element in
            element.isOpened = true
            completion(element)
        }
    }
    
    static func deleteAllNotifications() {
        RealmManager.shared.deleteAll(PushNotification.self)
    }
}


