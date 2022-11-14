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

        let setUpVC = SearchViewController()
        let rootVC = UINavigationController(rootViewController: setUpVC)
        rootVC.navigationBar.tintColor = UIColor.label
        rootVC.navigationBar.topItem?.backButtonTitle = ""
//        rootVC.navigationBar.topItem?.titleView?.tintColor = .green
        self.window = UIWindow(windowScene: scene)
        self.window?.rootViewController = rootVC
        self.window?.makeKeyAndVisible()
        
//        SignInManager .checkUserAuth { (AuthState) in
//            var rootViewState = RootViewState.loginView
//            switch AuthState {
//            case .undefined, .signedOut:
//                // no has authorization
//                break
//            case .signedIn:
//                // loginView에서 처음 token으로 서버 넘겨줄때, 필수 데이터 상태 받아옴 (init nil)
//
//                // keychain token 저장시, 앱삭제 후에도 바로 로그인 가능하기때문에
//                // 필수데이터 api 요청을 하여 값 있는지 확인해야한다.
//                // 아니면 필수 데이터 입력 되었는지도 keychain에 저장 (이걸로 간다)
//
//                // 필수 데이터 있으면 homeView, 없으면 loginViewController로 이동
//                RequirementInfoManager.checkIsFullRequirementInfo { (RequirementInfoState) in
//                    switch RequirementInfoState {
//                    case .full:
//                        rootViewState = .homeView   // home view
//                        break
//                    case .notFull:
//                        rootViewState = .setUpProfileView   // profile view
//                        break
//                    }
//                }
//                break
//            }
//
//            DispatchQueue.main.async {
//                let rootVC: UIViewController
//                switch rootViewState {
//                case .loginView:
//                    let loginVC = LoginViewController()
//                    rootVC = UINavigationController(rootViewController: loginVC)
//                    break
//                case .homeView: // 필수 데이터 있으면
//                    let homeVC = HomeViewController()
//                    let tabBarVC = UITabBarController()
//                    tabBarVC.viewControllers = [homeVC]
//                    rootVC = tabBarVC
//                    break
//                case .setUpProfileView:
//                    let setUpProfileVC = SetUpProfileTableViewController()
//                    rootVC = UINavigationController(rootViewController: setUpProfileVC)
//                    break
//                }
//                self.window = UIWindow(windowScene: scene)
//                self.window?.rootViewController = rootVC
//                self.window?.makeKeyAndVisible()
//            }
//        }
        
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


