//
//  ServiceTapBarViewController.swift
//  Yogit
//
//  Created by Junseo Park on 2022/11/20.
//

import UIKit
import UserNotifications
import Alamofire

// navi >> tabbar >> vc
class ServiceTapBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTapBarVC()
        configureInstanceVC()
        setPushNotification()
        print("DEBUG : \(String(describing: self.view.window?.rootViewController))")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print(self.view.window?.rootViewController)
    }

    private func configureTapBarVC() {
        self.view.backgroundColor = .systemBackground
        UITabBar.appearance().tintColor = UIColor(rgb: 0x3232FF, alpha: 1.0)

//        self.hidesBottomBarWhenPushed = true
//        self.tabBar.tintColor = UIColor(rgb: 0x3232FF, alpha: 1.0)
    }
    
    private func setPushNotification() {
        UNUserNotificationCenter.current().delegate = self
        registerForPushNotifications()
        guard let userItem = try? KeychainManager.getUserItem() else { return }
        userItem.account.id_token
        print("identityToken", userItem.id_token)
//        logOut()
    }
    
    private func configureInstanceVC() {
        let homeVC = SearchGatheringBoardController()
        let profileVC = SearchProfileViewController()
        let myClubVC = MyClubViewController()
        let notiVC = PushNoficationViewController()
        
//        homeVC.title = "Home"
//        profileVC.title = "Profile"
        
//        // 위에 타이틀 text를 항상 크게 보이게 설정
//        homeVC.navigationItem.largeTitleDisplayMode = .always
//        profileVC.navigationItem.largeTitleDisplayMode = .always
        homeVC.tabBarItem.image = UIImage.init(named: TabBarKind.home.rawValue)
        homeVC.tabBarItem.title = TabBarKind.home.rawValue
//        homeVC.tabBarController?.navigationController?.navigationItem.title = "Home"
//        homeVC.navigationController?.navigationBar.topItem?.title = "Home"
//        self.tabBarController?.navigationController?.navigationBar.topItem?.title = "zedd"
//        self.navigationController?.navigationBar.topItem?.title = "zedd"
        myClubVC.tabBarItem.image = UIImage.init(named: TabBarKind.myClub.rawValue)
        myClubVC.tabBarItem.title = TabBarKind.myClub.rawValue
        profileVC.tabBarItem.image = UIImage.init(named: TabBarKind.profile.rawValue)
        profileVC.tabBarItem.title = TabBarKind.profile.rawValue
        notiVC.tabBarItem.image = UIImage.init(named: TabBarKind.notification.rawValue)
        notiVC.tabBarItem.title = TabBarKind.notification.rawValue
        // navigationController의 root view 설정
//        let navigationHome = UINavigationController(rootViewController: homeVC)
//
//        navigationHome.navigationBar.tintColor = UIColor.label
//        navigationHome.navigationBar.topItem?.backButtonTitle = ""
//
//        let navigationProfile = UINavigationController(rootViewController: profileVC)
//
//        navigationProfile.navigationBar.tintColor = UIColor.label
//        navigationProfile.navigationBar.topItem?.backButtonTitle = ""
//        navigationHome.navigationBar.prefersLargeTitles = true
//        navigationProfile.navigationBar.prefersLargeTitles = true
        
//        let homveNavVC = UINavigationController(rootViewController: homeVC)
//        let myClubNavVC = UINavigationController(rootViewController: myClubVC)
//        let profileNavVC = UINavigationController(rootViewController: profileVC)
//        let notiNavVC = UINavigationController(rootViewController: notiVC)
        
        setViewControllers([homeVC, myClubVC, profileVC, notiVC], animated: true)
        
//        setViewControllers([homveNavVC, myClubNavVC, profileNavVC, notiNavVC], animated: true)
//        self.tabBarController?.tabBar.isHidden = false
    }
    
    private func sendDeviceToken(deviceToken: String) {
        guard let userItem = try? KeychainManager.getUserItem() else { return }
//        let userDefaults = UserDefaults.standard
//        guard let deviceTokenString = userDefaults.object(forKey: "DeviceToken") as? String else { return }
//        do {
//            userItem.deviceToken = deviceToken
//            try KeychainManager.updateUserItem(userItem: userItem)
//        } catch {
//            print("KeychainManager.update \(error.localizedDescription)")
//        }
//        print(userItem)
//        guard let deviceToken = userItem.deviceToken else { return }
        let sendDeviceToken = SendDeviceToken(deviceToken: deviceToken, refreshToken: userItem.refresh_token, userId: userItem.userId)
        AF.request(API.BASE_URL + "users/device-token",
                   method: .post,
                   parameters: sendDeviceToken,
                   encoder: URLEncodedFormParameterEncoder(destination: .httpBody)) // default set body and Content-Type HTTP header field of an encoded request is set to application/json
        .validate(statusCode: 200..<500)
        .response { response in // reponseData
            switch response.result {
            case .success:
                debugPrint(response)
//                userDefaults.removeObject(forKey: "DeviceToken")
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ServiceTapBarViewController: UIApplicationDelegate {
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let deviceTokenString = deviceToken.map { String(format: "%02x", $0) }.joined()
        sendDeviceToken(deviceToken: deviceTokenString)
//        let userDefaults = UserDefaults.standard
//        userDefaults.set(deviceTokenString, forKey: "DeviceToken")
        print("Device token", deviceTokenString)
    }
    
    
//     userNotificationCenter(_ center: UNUserNotificationCenter, didReceive와 동일 작업 메소드
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print("application-didReceiveRemoteNotification")
        // 앱 종료후에도 노티를 탭하여 실행할때
    }

}

extension ServiceTapBarViewController: UNUserNotificationCenterDelegate  {
    
    func registerForPushNotifications() {
        print("registerForPushNotifications")
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { [weak self] granted, error in
            // 3 - 완료 핸들러는 인증이 성공했는지 여부를 나타내는 Bool을 수신합니다. 인증 결과를 표시합니다.
            if let error = error {
                print("ERROR|Request Notificattion Authorization : \(error)")
            }
            print("Permission granted: \(granted)")
            
            guard granted else { return }
            self?.getNotificationSettings()
        }
    }
    
    func getNotificationSettings() {
        print("getNotificationSettings")
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            print("Notification settings: \(settings)")
            guard settings.authorizationStatus == .authorized else { return }
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
//                UIApplication.shared.noti
            }
        }
    }
    
    // 앱 열린 상태일때
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
        completionHandler([.list, .banner, .badge, .sound]) // 리스트, 배너, 뱃지, 사운드를 모두 사용하는 형태
    }
    
    // 앱 원격 상태일때
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("DidReceive userNotificationCenter")
        debugPrint(response.notification.request.content.userInfo)
//        let title: String = response.notification.request.content.title
//        let body: String = response.notification.request.content.body
//        guard let id = response.notification.request.content.userInfo["boardId"] as? Int64 else { return }
//        guard let type = response.notification.request.content.userInfo["pushType"] as? String else { return }
//        let alarmData = Alarm(type: type, title: title, body: body, id: id)
//        receivePushNotificationData(alarm: alarmData)
        
        DispatchQueue.main.async {
            self.navigationController?.popToRootViewController(animated: true)
            self.selectedIndex = 3
        }
        completionHandler()
    }
    
    func receivePushNotificationData(alarm: Alarm) {
        print("receivePushNotificationData")
        guard var alarms = AlarmManager.loadAlarms(type: alarm.type) else { return }
        alarms.append(alarm)
        AlarmManager.saveAlarms(alarms: alarms)
        NotificationCenter.default.post(name: NSNotification.Name("AlarmRefresh"), object: alarm.type)
//        self.tabBarController?.selectedIndex = 3
//        DispatchQueue.main.async {
//            self.navigationController?.popToRootViewController(animated: true)
//            self.selectedIndex = 3
//        }
    }
}

extension Notification.Name {
    static let alarmRefresh = Notification.Name("AlarmRefresh")
}
