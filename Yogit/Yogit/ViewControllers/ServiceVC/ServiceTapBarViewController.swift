//
//  ServiceTapBarViewController.swift
//  Yogit
//
//  Created by Junseo Park on 2022/11/20.
//

import UIKit

class ServiceTapBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTapBarVC()
        configureInstanceVC()
    }

    private func configureTapBarVC() {
        self.view.backgroundColor = .systemBackground
        self.tabBar.tintColor = UIColor(rgb: 0x3232FF, alpha: 1.0)
    }
    
    private func configureInstanceVC() {
        let homeVC = SearchGatheringBoardController()
        let profileVC = SearchProfileViewController()
        
//        homeVC.title = "Home"
//        profileVC.title = "Profile"
        
//        // 위에 타이틀 text를 항상 크게 보이게 설정
//        homeVC.navigationItem.largeTitleDisplayMode = .always
//        profileVC.navigationItem.largeTitleDisplayMode = .always
        
        homeVC.tabBarItem.image = UIImage.init(named: "Home")
        profileVC.tabBarItem.image = UIImage.init(named: "Profile")
        
        // navigationController의 root view 설정
        let navigationHome = UINavigationController(rootViewController: homeVC)
        
        navigationHome.navigationBar.tintColor = UIColor.label
        navigationHome.navigationBar.topItem?.backButtonTitle = ""
        
        let navigationProfile = UINavigationController(rootViewController: profileVC)
        
//        navigationHome.navigationBar.prefersLargeTitles = true
//        navigationProfile.navigationBar.prefersLargeTitles = true
        
        setViewControllers([navigationHome, navigationProfile], animated: false)
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
