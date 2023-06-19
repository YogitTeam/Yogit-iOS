//
//  SceneDelegate.swift
//  Yogit
//
//  Created by Junseo Park on 2022/09/06.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        //        guard let _ = (scene as? UIWindowScene) else { return }
        guard let scene = (scene as? UIWindowScene) else { return }
//        let currentVC = GatheringBoardContentViewController()
//        let rootVC = UINavigationController(rootViewController: currentVC)
//        self.window = UIWindow(windowScene: scene)
//        self.window?.rootViewController = rootVC
//        self.window?.makeKeyAndVisible()
        
        UserSessionManager.checkUserAuth { (AuthState) in
            var rootViewState: RootViewState // 루트뷰 상태
            switch AuthState {
                case .undefine, .signOut, .deleteAccout, .signInSNS: rootViewState = .loginView
                case .signInService: rootViewState = .homeView
            }
            DispatchQueue.main.async {
                let currentVC: UIViewController
                switch rootViewState {
                    case .loginView: // 로그인 화면
                        let loginVC = LoginViewController()
                        currentVC = loginVC
                    case .homeView: // 홈 화면
                        let homeVC = ServiceTabBarViewController()
                        currentVC = homeVC
                }
                let rootVC = UINavigationController(rootViewController: currentVC)
                self.window = UIWindow(windowScene: scene)
                self.window?.rootViewController = rootVC
                self.window?.makeKeyAndVisible()
            }
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
        guard let scene = (scene as? UIWindowScene) else { return }
        
        UserSessionManager.checkUserAuth { (AuthState) in
            if AuthState == .deleteAccout { // 앱 foreground active 상태일때, 노티 날려서 회원 탈퇴 처리
                DispatchQueue.main.async { [self] in
                    let rootVC = UINavigationController(rootViewController: LoginViewController())
                    window = UIWindow(windowScene: scene)
                    window?.rootViewController = rootVC
                    window?.makeKeyAndVisible()
                    NotificationCenter.default.post(name: .revokeTokenRefresh, object: nil)
                }
            }
        }
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }

}
