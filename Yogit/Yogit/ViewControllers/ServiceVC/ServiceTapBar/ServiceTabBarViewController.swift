//
//  ServiceTapBarViewController.swift
//  Yogit
//
//  Created by Junseo Park on 2022/11/20.
//

import UIKit
//import UserNotifications
import Alamofire
import ProgressHUD
import SnapKit

// navi >> tabbar >> vc
class ServiceTabBarViewController: UITabBarController {

    private let line: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray3
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
//        configureTapBarVC()
        configureInstanceVC()
        configureNotification()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        line.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(0.5)
            $0.bottom.equalTo(self.tabBar.snp.top)
        }
    }
    
    private func configureView() {
        view.backgroundColor = .systemBackground
        view.addSubview(line)
    }
    
    private func configureNotification() {
        if UserDefaults.standard.object(forKey: Preferences.PUSH_NOTIFICATION) == nil { // 로그아웃, 계정삭제시만 디바이스 토큰 서버로 보냄
            registerForPushNotifications()
        }
        NotificationCenter.default.addObserver(self, selector: #selector(didBoardDetailNotification(_:)), name: .baordDetailRefresh, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didlMoveToVCNotification(_:)), name: .moveToNotiTabVC, object: nil)
    }
    
    @objc private func didBoardDetailNotification(_ notification: Notification) {
        print("보드 알림 발생")
        guard let boardDetail = notification.object as? BoardDetail else { return }
        DispatchQueue.main.async(qos: .userInteractive) {
            let GDBVC = GatheringDetailBoardViewController()
            GDBVC.bindBoardDetail(data: boardDetail)
            GDBVC.boardWithMode.mode = .refresh
            self.navigationController?.pushViewController(GDBVC, animated: true)
        }
    }

    @objc private func didlMoveToVCNotification(_ notification: Notification) {
        DispatchQueue.main.async {
            self.navigationController?.popToRootViewController(animated: true)
            self.selectedIndex = 3
        }
    }
    
    private func configureTapBarVC() {
       
//        UITabBar.appearance().tintColor = UIColor(rgb: 0x3232FF, alpha: 1.0)
//        UITabBar.appearance().backgroundColor = .systemBackground
//        self.hidesBottomBarWhenPushed = true
//        self.tabBar.tintColor = UIColor(rgb: 0x3232FF, alpha: 1.0)
    }
    
    private func configureInstanceVC() {
        let homeVC = MainViewController()// SearchGatheringBoardController()
        let profileVC = GetProfileViewController()
        let myClubVC = MyClubViewController()
        let notiVC = PushNotificationViewController()
        
        homeVC.tabBarItem.image = UIImage.init(named: TabBarKind.home.rawValue)?.withTintColor(.systemGray5)
        homeVC.tabBarItem.title = TabBarKind.home.rawValue.localized()
        myClubVC.tabBarItem.image = UIImage.init(named: TabBarKind.myClub.rawValue)?.withTintColor(.systemGray5)
        myClubVC.tabBarItem.title = TabBarKind.myClub.rawValue.localized()
        profileVC.tabBarItem.image = UIImage.init(named: TabBarKind.profile.rawValue)?.withTintColor(.systemGray5)
        profileVC.tabBarItem.title = TabBarKind.profile.rawValue.localized()
        notiVC.tabBarItem.image = UIImage.init(named: TabBarKind.notification.rawValue)?.withTintColor(.systemGray5)
        notiVC.tabBarItem.title = TabBarKind.notification.rawValue.localized()
        
        setViewControllers([homeVC, myClubVC, profileVC, notiVC], animated: true)
    }
}

extension ServiceTabBarViewController { // UNUserNotificationCenterDelegate
    
    func registerForPushNotifications() {
        print("푸쉬 알림 등록")
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { [weak self] granted, error in
            // 3 - 완료 핸들러는 인증이 성공했는지 여부를 나타내는 Bool을 수신합니다. 인증 결과를 표시합니다.
            if let error = error {
                print("ERROR|Request Notificattion Authorization : \(error)")
            }
            guard granted else {
                print("권한 없음")
                return }
            self?.getNotificationSettings()
        }
    }
    
    func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            print("Notification settings: \(settings)")
            guard settings.authorizationStatus == .authorized else { return }
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
    
//     // 앱 열린 상태일때
//    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
//        // 원격으로 들어오면, 열린 상태 함수 실행안됨
//        print("WillPresent userNotificationCenter")
//
//        debugPrint(notification.request.content.userInfo)
//
//        let content = notification.request.content
//        let title: String = content.title // 현재 title-loc-key로 키값 설정됨
//        let body: String = content.body // 현재 loc-key로 키값 걸정됨
//
//        var args: [String] = []
//        if let aps = content.userInfo["aps"] as? [String: Any],
//            let alert = aps["alert"] as? [String: Any],
//            let locArgs = alert["loc-args"] as? [String] {
//            for arg in locArgs {
//                args.append(arg)
//            }
//            print("WillPresent args, locArgs", args, locArgs)
//        }
//
//
//        guard let id = content.userInfo["boardId"] as? Int64 else { return }
//        guard let type = content.userInfo["pushType"] as? String else { return }
//        let alarmData = Alarm(type: type, title: title, body: body, args: args, id: id)
//
//        receivePushNotificationData(alarm: alarmData)
//
//        // foreground 앱 알리는 형태
//        if type != AlarmManager.AlarmType.clipBoard.toKey() { // 신청, 취소 알림은 포어그라운드 알림
//            completionHandler([.list, .banner, .badge, .sound]) // 리스트, 배너, 뱃지, 사운드를 모두 사용하는 형태
//        }
//    }
//    
//    // 앱 원격 상태일때
//    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
//        
//        print("DidReceive userNotificationCenter")
//        
//        debugPrint(response.notification.request.content.userInfo)
//        
//        let content = response.notification.request.content
//        let title: String = content.title
//        let body: String = content.body
//
//        var args: [String] = []
//        if let aps = content.userInfo["aps"] as? [String: Any],
//            let alert = aps["alert"] as? [String: Any],
//            let locArgs = alert["loc-args"] as? [String] {
//            for arg in locArgs {
//                args.append(arg)
//            }
//            print("DidReceive  args, locArgs", args, locArgs)
//        }
//
//        guard let id = content.userInfo["boardId"] as? Int64 else { return }
//        guard let type = content.userInfo["pushType"] as? String else { return }
//        let alarmData = Alarm(type: type, title: title, body: body, args: args, id: id)
//
//        receivePushNotificationData(alarm: alarmData)
//        
//        DispatchQueue.main.async {
//            self.navigationController?.popToRootViewController(animated: true)
//            self.selectedIndex = 3
//        }
//        
//        completionHandler()
//    }
//    
//    func receivePushNotificationData(alarm: Alarm) {
//        
//        print("receivePushNotificationData")
//        
//        guard var alarms = AlarmManager.loadAlarms(type: alarm.type) else { return }
//        print("기존 알림 리스트", alarms)
//        print("새로운 알림", alarm)
//        if alarms.last != alarm {
//            print("알림 더함")
//            alarms.append(alarm)
//            AlarmManager.saveAlarms(alarms: alarms)
//            NotificationCenter.default.post(name: .alarmRefresh, object: alarm.type)
//        }
//    }
}

