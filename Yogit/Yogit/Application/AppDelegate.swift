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
        
        UNUserNotificationCenter.current().delegate = self // 아래 extension 참조
        
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound] // 알림, 뱃지, 사운드 옵션 사용하겠다
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { _, error in // 알림에 대한 허락을 받겠다
            if let error = error {
                print("ERROR|Request Notificattion Authorization : \(error)")
            }
        }
        application.registerForRemoteNotifications() // 디바이스 토큰 요청
        
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

}

extension AppDelegate: UNUserNotificationCenterDelegate  {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("알람옴")
        completionHandler([.list, .banner, .badge, .sound]) // 리스트, 배너, 뱃지, 사운드를 모두 사용하는 형태
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print(response.notification.request.content.userInfo)
        
//        NotificationCenter.default.post(name: NSNotification.Name(""), object: boardId)
//        if let aps = response.notification.request.content.userInfo["aps"] as? NSDictionary {
//            print(aps)
//        }
    }
}
