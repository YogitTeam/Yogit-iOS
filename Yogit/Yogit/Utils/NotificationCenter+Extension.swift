//
//  NotificationCenter+Extension.swift
//  Yogit
//
//  Created by Junseo Park on 2023/03/16.
//

import Foundation

extension Notification.Name {
    static let notiRefresh = Notification.Name("NotificationRefresh")
    static let baordDetailRefresh = Notification.Name("BoardDetailRefresh")
    static let revokeTokenRefresh = Notification.Name("RevokeTokenRefresh")
    static let moveToNotiTabVC = Notification.Name("MoveToNotiTabVC")
    static let moveToHome = Notification.Name("MoveToHome")
}
