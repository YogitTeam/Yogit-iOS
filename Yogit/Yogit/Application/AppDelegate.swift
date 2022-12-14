//
//  AppDelegate.swift
//  Yogit
//
//  Created by Junseo Park on 2022/09/06.
//

import UIKit
import IQKeyboardManagerSwift
import UserNotifications
//import GooglePlaces

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
//        google place api
//        GMSPlacesClient.provideAPIKey("AIzaSyDf90QEzoh79P2IntFDs7gcWz7QwtjvJcE")
        
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = false
        
        UNUserNotificationCenter.current().delegate = self
        
        registerForPushNotifications()

        return true
    }
    
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let deviceTokenString = deviceToken.map { String(format: "%02x", $0) }.joined()
        let userDefaults = UserDefaults.standard
        userDefaults.set(deviceTokenString, forKey: "DeviceToken")
        print("Device token", deviceTokenString)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register: \(error)")
    }

}

extension AppDelegate: UNUserNotificationCenterDelegate  {
    
    func registerForPushNotifications() {
        print("registerForPushNotifications")
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            // 3 - ?????? ???????????? ????????? ??????????????? ????????? ???????????? Bool??? ???????????????. ?????? ????????? ???????????????.
            if let error = error {
                print("ERROR|Request Notificattion Authorization : \(error)")
            }
            print("Permission granted: \(granted)")
            
            guard granted else { return }
            self.getNotificationSettings()
        }
    }
    
    func getNotificationSettings() {
        print("getNotificationSettings")
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            print("Notification settings: \(settings)")
            guard settings.authorizationStatus == .authorized else { return }
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
    
    // ??? ?????? ????????????
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("WillPresent userNotificationCenter")
        debugPrint(notification.request.content.userInfo)
//        NotificationCenter.default.post(name: NSNotification.Name(""), object: boardId)
//        print(response.notification.request.content.title)
//        print(response.notification.request.content.body)
        let title: String = notification.request.content.title
        let body: String = notification.request.content.body
        guard let id = notification.request.content.userInfo["boardId"] as? Int64 else { return }
        guard let type = notification.request.content.userInfo["pushType"] as? String else { return }
        let alarmData = Alarm(type: type, title: title, body: body, id: id)
        receivePushNotificationData(alarm: alarmData)
        completionHandler([.list, .banner, .badge, .sound]) // ?????????, ??????, ??????, ???????????? ?????? ???????????? ??????
    }
    
    // ??? ?????? ????????????
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("DidReceive userNotificationCenter")
        debugPrint(response.notification.request.content.userInfo)
//        NotificationCenter.default.post(name: NSNotification.Name(""), object: boardId)
//        print(response.notification.request.content.title)
//        print(response.notification.request.content.body)
        let title: String = response.notification.request.content.title
        let body: String = response.notification.request.content.body
        guard let id = response.notification.request.content.userInfo["boardId"] as? Int64 else { return }
        guard let type = response.notification.request.content.userInfo["pushType"] as? String else { return }
        let alarmData = Alarm(type: type, title: title, body: body, id: id)
        receivePushNotificationData(alarm: alarmData)
        completionHandler()
    }
    
    func receivePushNotificationData(alarm: Alarm) {
        print("receivePushNotificationData")
        guard var alarms = AlarmManager.loadAlarms(type: alarm.type) else { return }
        alarms.append(alarm)
        AlarmManager.saveAlarms(alarms: alarms)
        NotificationCenter.default.post(name: NSNotification.Name("AlarmRefresh"), object: alarm.type)
    }
}

extension Notification.Name {
    static let alarmRefresh = Notification.Name("AlarmRefresh")
}
