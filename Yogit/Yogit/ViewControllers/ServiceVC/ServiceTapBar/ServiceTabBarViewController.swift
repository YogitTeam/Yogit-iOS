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
        configureTapBarVC()
        configureInstanceVC()
        configureLayout()
        configureNotification()
    }
    
    private func configureView() {
        view.backgroundColor = .systemBackground
        view.addSubview(line)
    }
    
    private func configureLayout() {
        line.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(0.5)
            $0.bottom.equalTo(self.tabBar.snp.top)
        }
    }
    
    private func configureNotification() {
//        if UserDefaults.standard.object(forKey: Preferences.PUSH_NOTIFICATION) == nil { // 로그아웃, 계정삭제시만 디바이스 토큰 서버로 보냄
//            registerForPushNotifications()
//        }
        NotificationCenter.default.addObserver(self, selector: #selector(didBoardDetailNotification(_:)), name: .baordDetailRefresh, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didlMoveToVCNotification(_:)), name: .moveToNotiTabVC, object: nil)
    }
    
    private func removeNotification() {
        NotificationCenter.default.removeObserver(self, name: .baordDetailRefresh, object: nil)
        NotificationCenter.default.removeObserver(self, name: .moveToNotiTabVC, object: nil)
    }
    
    deinit {
        removeNotification()
    }
    
    @objc private func didBoardDetailNotification(_ notification: Notification) {
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
        self.tabBar.tintColor = ServiceColor.primaryColor
        self.tabBar.backgroundColor = .systemBackground
        self.tabBar.unselectedItemTintColor = .systemGray3
//        UITabBar.appearance().tintColor = UIColor(rgb: 0x3232FF, alpha: 1.0)
//        UITabBar.appearance().backgroundColor = .systemBackground
//        self.hidesBottomBarWhenPushed = true
//        self.tabBar.tintColor = UIColor(rgb: 0x3232FF, alpha: 1.0)
    }
    
    private func configureInstanceVC() {
        DispatchQueue.main.async {
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
            
            self.setViewControllers([homeVC, myClubVC, profileVC, notiVC], animated: true)
        }
    }
}

extension ServiceTabBarViewController { // UNUserNotificationCenterDelegate
    
    func registerForPushNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { [weak self] granted, error in
            // 3 - 완료 핸들러는 인증이 성공했는지 여부를 나타내는 Bool을 수신합니다. 인증 결과를 표시합니다.
            if let error = error {
                print("ERROR|Request Notificattion Authorization : \(error)")
            }
            guard granted else { return }
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
}

