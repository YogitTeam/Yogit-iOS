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
       

        UITabBar.appearance().tintColor = ServiceColor.primaryColor
        UITabBar.appearance().backgroundColor = .systemBackground
        
//        // 시맨틱 콘텐츠 속성을 설정하여 UIView앱 내에 표시되는 모든 콘텐츠가 사용자의 기본 설정 언어 설정에 따라 올바른 방향으로 배치
//        UIView.appearance().semanticContentAttribute = UIApplication.shared.userInterfaceLayoutDirection == .rightToLeft ? .forceRightToLeft : .forceLeftToRight
//
////
//        UNUserNotificationCenter.current().delegate = self
//        
//        registerForPushNotifications()

        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        let deviceTokenString = deviceToken.map { String(format: "%02x", $0) }.joined()
        print("Device token", deviceTokenString)
        // 디바이스 토큰 없으면 api 요청
        sendDeviceToken(deviceToken: deviceTokenString)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print("application-didReceiveRemoteNotification")
        // 앱 종료후에도 노티를 탭하여 실행할때
    }
    
    private func sendDeviceToken(deviceToken: String) {
        guard let identifier = UserDefaults.standard.object(forKey: SessionManager.currentServiceTypeIdentifier) as? String else { return }
        guard let userItem = try? KeychainManager.getUserItem(serviceType: identifier) else { return }
        let sendDeviceTokenReq = SendDeviceTokenReq(deviceToken: deviceToken, refreshToken: userItem.refresh_token, userId: userItem.userId)
        AlamofireManager.shared.session
            .request(PushNotificationRouter.sendDeviceToken(parameters: sendDeviceTokenReq))
            .validate(statusCode: 200..<501)
            .responseDecodable(of: APIResponse<SendDeviceTokenRes>.self) { response in
                switch response.result {
                case .success:
                    if let value = response.value, value.httpCode == 200 || value.httpCode == 201, let data = value.data {
                        let deviceToken = data.deviceToken
                        UserDefaults.standard.set(deviceToken, forKey: Preferences.PUSH_NOTIFICATION)
                        print("UserDefaults Preferences.PUSH_NOTIFICATION",UserDefaults.standard.object(forKey: Preferences.PUSH_NOTIFICATION))
                    }
                case let .failure(error):
                    print(error)
                }
            }
    }
    
//    private func saveUserLanguage() {
//        guard let languageIdentifier = Locale.preferredLanguages.first else { return } // ko-KR
//        UserDefaults.standard.set(languageIdentifier, forKey: LocalizedLanguage.LANGUAGE)
//    }
    
//    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
//        print("application-didReceiveRemoteNotification")
//        // 앱 종료후에도 노티를 탭하여 실행할때
//    }
    
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
//    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
//        // 앱 종료후에도 노티를 탭하여 실행할때
//    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
//    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
//        let deviceTokenString = deviceToken.map { String(format: "%02x", $0) }.joined()
//        let userDefaults = UserDefaults.standard
//        userDefaults.set(deviceTokenString, forKey: "DeviceToken")
//        print("Device token", deviceTokenString)
//    }
    
//    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
//        print("Failed to register: \(error)")
//    }

}

//extension AppDelegate: UNUserNotificationCenterDelegate  {
//    
//    func registerForPushNotifications() {
//        print("registerForPushNotifications")
//        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
//            // 3 - 완료 핸들러는 인증이 성공했는지 여부를 나타내는 Bool을 수신합니다. 인증 결과를 표시합니다.
//            if let error = error {
//                print("ERROR|Request Notificattion Authorization : \(error)")
//            }
//            print("Permission granted: \(granted)")
//            
//            guard granted else { return }
//            self.getNotificationSettings()
//        }
//    }
//    
//    func getNotificationSettings() {
//        print("getNotificationSettings")
//        UNUserNotificationCenter.current().getNotificationSettings { settings in
//            print("Notification settings: \(settings)")
//            guard settings.authorizationStatus == .authorized else { return }
//            DispatchQueue.main.async {
//                UIApplication.shared.registerForRemoteNotifications()
//            }
//        }
//    }
//    
//    // 앱 열린 상태일때
//    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
//        print("WillPresent userNotificationCenter")
//        debugPrint(notification.request.content.userInfo)
////        NotificationCenter.default.post(name: NSNotification.Name(""), object: boardId)
////        print(response.notification.request.content.title)
////        print(response.notification.request.content.body)
//        let title: String = notification.request.content.title
//        let body: String = notification.request.content.body
//        guard let id = notification.request.content.userInfo["boardId"] as? Int64 else { return }
//        guard let type = notification.request.content.userInfo["pushType"] as? String else { return }
//        let alarmData = Alarm(type: type, title: title, body: body, id: id)
//        receivePushNotificationData(alarm: alarmData)
//        completionHandler([.list, .banner, .badge, .sound]) // 리스트, 배너, 뱃지, 사운드를 모두 사용하는 형태
//    }
//    
//    // 앱 원격 상태일때
//    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
//        print("DidReceive userNotificationCenter")
//        debugPrint(response.notification.request.content.userInfo)
////        NotificationCenter.default.post(name: NSNotification.Name(""), object: boardId)
////        print(response.notification.request.content.title)
////        print(response.notification.request.content.body)
//        let title: String = response.notification.request.content.title
//        let body: String = response.notification.request.content.body
//        guard let id = response.notification.request.content.userInfo["boardId"] as? Int64 else { return }
//        guard let type = response.notification.request.content.userInfo["pushType"] as? String else { return }
//        let alarmData = Alarm(type: type, title: title, body: body, id: id)
//        receivePushNotificationData(alarm: alarmData)
//        completionHandler()
//    }
//    
//    func receivePushNotificationData(alarm: Alarm) {
//        print("receivePushNotificationData")
//        guard var alarms = AlarmManager.loadAlarms(type: alarm.type) else { return }
//        alarms.append(alarm)
//        AlarmManager.saveAlarms(alarms: alarms)
//        NotificationCenter.default.post(name: NSNotification.Name("AlarmRefresh"), object: alarm.type)
//    }
//}
//
//extension Notification.Name {
//    static let alarmRefresh = Notification.Name("AlarmRefresh")
//}
