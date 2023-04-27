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

        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        let deviceTokenString = deviceToken.map { String(format: "%02x", $0) }.joined()
        print("Device token", deviceTokenString)
        // 디바이스 토큰 없으면 api 요청
        sendDeviceToken(deviceToken: deviceTokenString)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register: \(error)")
    }
    
//    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
//        print("application-didReceiveRemoteNotification")
//
//
//        guard let aps = userInfo["aps"] as? [String: Any] else {
//            print("fetch 알람 데이터 받기 실패")
//            return completionHandler(.failed) }
//        print("aps 데이터", aps)
//        var args: [String] = []
//
//        if let id = userInfo["boardId"] as? Int64,
//            let type = userInfo["pushType"] as? String,
//            let alert = aps["alert"] as? [String: Any],
//            let titleLocKey = alert["title-loc-key"] as? String,
//            let locKey = alert["loc-key"] as? String,
//            let locArgs = alert["loc-args"] as? [String] {
//            for arg in locArgs {
//                args.append(arg)
//            }
//
//            let alarmData = Alarm(type: type, title: titleLocKey, body: locKey, args: args, id: id)
//
//            print("fetch 알람 데이터", alarmData)
//
//            receivePushNotificationData(alarm: alarmData)
//
//            completionHandler(.newData)
//        } else {
//            print("fetch 알람 데이터 다운캐스팅 실패")
//            completionHandler(.noData)
//        }
//
//
//        // 앱 종료후에도 노티를 탭하여 실행할때
//    }
    
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
                    }
                case let .failure(error):
                    print(error)
                }
            }
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

}

extension AppDelegate: UNUserNotificationCenterDelegate {
    // 앱 열린 상태일때
   func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
       // 원격으로 들어오면, 열린 상태 함수 실행안됨
       print("WillPresent userNotificationCenter")

       debugPrint(notification.request.content.userInfo)

       let content = notification.request.content
       let title: String = content.title // 현재 title-loc-key로 키값 설정됨
       let body: String = content.body // 현재 loc-key로 키값 걸정됨

       var args: [String] = []
       
       if let aps = content.userInfo["aps"] as? [String: Any],
           let alert = aps["alert"] as? [String: Any],
           let locArgs = alert["loc-args"] as? [String] {
           for arg in locArgs {
               args.append(arg)
           }
       }
       
       guard let boardId = content.userInfo["boardId"] as? Int64 else { return }
       guard let type = content.userInfo["pushType"] as? String else { return }
       guard let time = content.userInfo["time"] as? String else { return }
       guard let isOpened = content.userInfo["isOpened"] as? Bool else { return }
       
       let noti = PushNotification(id: 0, type: type, title: title, body: body, argArray: args, boardId: boardId, time: time, isOpened: isOpened)
       
       PushNotificationManager.saveNotification(noti: noti)
       
//       // foreground 앱 알리는 형태
//       if type != PushNotificationManager.NotiType.clipBoard.toKey() { // 신청, 취소 알림은 포어그라운드 알림
//           completionHandler([.list, .banner, .badge, .sound]) // 리스트, 배너, 뱃지, 사운드를 모두 사용하는 형태
//       }
       
   }

    
   // 앱 원격 상태일때
   func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {

       print("DidReceive userNotificationCenter")

       debugPrint(response.notification.request.content.userInfo)

       let content = response.notification.request.content
       let title: String = content.title
       let body: String = content.body

       var args: [String] = []
       
       if let aps = content.userInfo["aps"] as? [String: Any],
           let alert = aps["alert"] as? [String: Any],
           let locArgs = alert["loc-args"] as? [String] {
           for arg in locArgs {
               args.append(arg)
           }
           print("DidReceive  args, locArgs", args, locArgs)
       }
       
       guard let boardId = content.userInfo["boardId"] as? Int64 else { return }
       guard let type = content.userInfo["pushType"] as? String else { return }
       guard let time = content.userInfo["time"] as? String else { return }
       guard let isOpened = content.userInfo["isOpened"] as? Bool else { return }
       
       let noti = PushNotification(id: 0, type: type, title: title, body: body, argArray: args, boardId: boardId, time: time, isOpened: isOpened)
       
       PushNotificationManager.saveNotification(noti: noti)
       
       NotificationCenter.default.post(name: .moveToNotiTabVC, object: nil) // 탭바 컨트롤러 탭바 인덱스 변경 노티

       completionHandler()
   }
}

