//
//  ServiceTapBarViewController.swift
//  Yogit
//
//  Created by Junseo Park on 2022/11/20.
//

import UIKit
import Alamofire

class ServiceTapBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTapBarVC()
        configureInstanceVC()
        sendDeviceToken()
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
        
        homeVC.tabBarItem.image = UIImage.init(named: "Home")
        myClubVC.tabBarItem.image = UIImage.init(named: "MyClub")
        profileVC.tabBarItem.image = UIImage.init(named: "Profile")
        notiVC.tabBarItem.image = UIImage.init(named: "Noti")
        
        
        
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
//
        
        
//        navigationHome.navigationBar.prefersLargeTitles = true
//        navigationProfile.navigationBar.prefersLargeTitles = true
        
        setViewControllers([homeVC, myClubVC, profileVC, notiVC], animated: true)
    }
    
    private func sendDeviceToken() {
        guard let userItem = try? KeychainManager.getUserItem() else { return }
        let userDefaults = UserDefaults.standard
        guard let deviceTokenString = userDefaults.object(forKey: "DeviceToken") as? String else { return }
        do {
            userItem.deviceToken = deviceTokenString
            try KeychainManager.updateUserItem(userItem: userItem)
        } catch {
            print("KeychainManager.update \(error.localizedDescription)")
        }
        print(userItem)
        guard let deviceToken = userItem.deviceToken else { return }
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
                userDefaults.removeObject(forKey: "DeviceToken")
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
