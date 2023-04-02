//
//  ServiceTapBarViewController.swift
//  Yogit
//
//  Created by Junseo Park on 2022/11/20.
//

import UIKit
import UserNotifications
import Alamofire
import ProgressHUD

// UserDefaults.standard.object(forKey: SessionManager.currentServiceTypeIdentifier) 으로 키체인에서 가져옴
// UserDefaults.standard.removeObject(forKey: ClipBoardAlarmIdentifier) // 클립보드 알람 삭제
// UserDefaults.standard.removeObject(forKey: ApplyAlarmIdentifier) // 애플 알람 삭제

// navi >> tabbar >> vc
class ServiceTapBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTapBarVC()
        configureInstanceVC()
        setPushNotification()
        print("보드 노티 등록")
        NotificationCenter.default.addObserver(self, selector: #selector(didBoardDetailNotification(_:)), name: .baordDetailRefresh, object: nil)
    }
    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        print("뷰디스어피어 ServiceTapBarView")
//        NotificationCenter.default.removeObserver(self, name: .baordDetailRefresh, object: nil)
//    }
    
    @objc private func didBoardDetailNotification(_ notification: Notification) {
        print("보드 알림 발생")
        guard let boardDetail = notification.object as? BoardDetail else { return }
        DispatchQueue.main.async(qos: .userInteractive) {
            let GDBVC = GatheringDetailBoardViewController()
            GDBVC.boardWithMode.mode = .refresh
            GDBVC.bindBoardDetail(data: boardDetail)
            self.navigationController?.pushViewController(GDBVC, animated: true)
        }
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        print(self.view.window?.rootViewController)
//    }

    private func configureTapBarVC() {
        self.view.backgroundColor = .systemBackground
       
//        UITabBar.appearance().tintColor = UIColor(rgb: 0x3232FF, alpha: 1.0)
//        UITabBar.appearance().backgroundColor = .systemBackground
//        self.hidesBottomBarWhenPushed = true
//        self.tabBar.tintColor = UIColor(rgb: 0x3232FF, alpha: 1.0)
    }
    
    private func setPushNotification() {
        UNUserNotificationCenter.current().delegate = self
        if UserDefaults.standard.object(forKey: Preferences.PUSH_NOTIFICATION) == nil { // 로그아웃, 계정삭제시만 디바이스 토큰 서버로 보냄
            registerForPushNotifications()
        } 
    }
    
    
    private func configureInstanceVC() {
        let homeVC = MainViewController()// SearchGatheringBoardController()
        let profileVC = GetProfileViewController()
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
    
//    private func sendDeviceToken(deviceToken: String) {
//        print("sendDeviceToken")
//        guard let userItem = try? KeychainManager.getUserItem() else { return }
//        let sendDeviceTokenReq = SendDeviceTokenReq(deviceToken: deviceToken, refreshToken: userItem.refresh_token, userId: userItem.userId)
//        AF.request(API.BASE_URL + "users/device-token",
//                   method: .post,
//                   parameters: sendDeviceTokenReq,
//                   encoder: URLEncodedFormParameterEncoder(destination: .httpBody))
//        .validate(statusCode: 200..<500)
//        .responseDecodable(of: APIResponse<SendDeviceTokenRes>.self) { response in
//            switch response.result {
//            case .success:
//                guard let value = response.value else { return }
//                if value.httpCode == 200 {
//                    guard let data = value.data else { return }
//                    let deviceToken = data.deviceToken
//                    UserDefaults.standard.set(deviceToken, forKey: Preferences.PUSH_NOTIFICATION)
//                    print("UserDefaults Preferences.PUSH_NOTIFICATION",UserDefaults.standard.object(forKey: Preferences.PUSH_NOTIFICATION))
//                }
//            case let .failure(error):
//                print("SetProfileVC - upload response result Not return", error)
//            }
//        }
//    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

//extension ServiceTapBarViewController: UIApplicationDelegate {
//    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
//        
//        let deviceTokenString = deviceToken.map { String(format: "%02x", $0) }.joined()
//        print("Device token", deviceTokenString)
//        // 디바이스 토큰 없거나, 다르면 api 요청
//        sendDeviceToken(deviceToken: deviceTokenString)
////        let userDefaults = UserDefaults.standard
////        userDefaults.set(deviceTokenString, forKey: "DeviceToken")
//    }
//    
//    
////     userNotificationCenter(_ center: UNUserNotificationCenter, didReceive와 동일 작업 메소드
//    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
//        print("application-didReceiveRemoteNotification")
//        // 앱 종료후에도 노티를 탭하여 실행할때
//    }
//
//}

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
                print("Before registerForRemoteNotifications")
                UIApplication.shared.registerForRemoteNotifications()
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
        let content = notification.request.content
        let title: String = content.title
        let body: String = content.body
        
//        let data = Data(base64Encoded: encodeString)
//
//        if let decode = String(data: data!, encoding: .utf8) {
//            print(decode)
//        }
        
//        let localeIdentifier = Locale.preferredLanguages.first

//        if let locArgs = content.userInfo["loc-args"] as? [Any] {
//            let data = Data(base64Encoded: locArgs as? )
//            let stringArray = locArgs.map { String(data: data!, encoding: .utf8) }
//            print("stringArray", stringArray)
////            let data = Data(base64Encoded: locArgs[0])
////            if let decodeString = String(data: data!, encoding: .utf8) {
////                print("decodeString", decodeString)
////            }
//        }
        
        var args: [String] = []
        if let aps = content.userInfo["aps"] as? [String: Any],
            let alert = aps["alert"] as? [String: Any],
//            let locKey = alert["loc-key"] as? String,
            let locArgs = alert["loc-args"] as? [String] {
            // Do something with the loc-args array
            for arg in locArgs {
                args.append(arg)
            }
        }
        
        print("타이틀", title)
        print("body", body)
        print("args", args)
        
//        guard let locArgs = content.userInfo["loc-args"] as? [String] else {
////            print("실패 locArgs", locArgs)
//            return }
//        guard let locArgs = content.userInfo["loc-args"] as? [UnicodeScalar] else {
//            print("실패 locArgs", locAr)
//            return }
//        print("성공 locArgs", locArgs)
        
        guard let id = content.userInfo["boardId"] as? Int64 else { return }
        guard let type = content.userInfo["pushType"] as? String else { return }
        let alarmData = Alarm(type: type, title: title, body: body, args: args, id: id)
        print("alarmData", alarmData)
        receivePushNotificationData(alarm: alarmData)
        
        // foreground 앱 알리는 형태
        if type != AlarmManager.AlarmType.clipBoard.toKey() { // 신청, 취소 알림은 포어그라운드 알림
            completionHandler([.list, .banner, .badge, .sound]) // 리스트, 배너, 뱃지, 사운드를 모두 사용하는 형태
        }
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
    }
    
    func receivePushNotificationData(alarm: Alarm) {
        print("receivePushNotificationData")
        guard var alarms = AlarmManager.loadAlarms(type: alarm.type) else { return }
        alarms.append(alarm)
        AlarmManager.saveAlarms(alarms: alarms)
        NotificationCenter.default.post(name: .alarmRefresh, object: alarm.type)
//        self.tabBarController?.selectedIndex = 3
//        DispatchQueue.main.async {
//            self.navigationController?.popToRootViewController(animated: true)
//            self.selectedIndex = 3
//        }
    }
}
