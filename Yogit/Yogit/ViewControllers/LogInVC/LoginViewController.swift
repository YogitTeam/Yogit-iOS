//
//  AuthenticationViewController.swift
//  Yogit
//
//  Created by Junseo Park on 2022/09/17.
//

import UIKit
import SnapKit
import AuthenticationServices
import Alamofire
import ProgressHUD


class LoginViewController: UIViewController {
    
    private lazy var signInWithAppleButton: ASAuthorizationAppleIDButton = {
        let button = ASAuthorizationAppleIDButton(authorizationButtonType: .signIn, authorizationButtonStyle: .whiteOutline)
        button.addTarget(self, action: #selector(handleAuthorizationAppleIDButtonPress), for: .touchUpInside)
        return button
    }()
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Yogit")?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = ServiceColor.primaryColor
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = false
        imageView.sizeToFit()
        return imageView
    }()
    
    private let setCountryTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.medium)
        label.numberOfLines = 1
        label.sizeToFit()
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureLayout()
        configureNav()
        initProgressHUD()
        addNotiCenter()
        setServiceCountry()
    }
    
    private func configureView() {
        view.addSubview(iconImageView)
        view.addSubview(setCountryTitleLabel)
        view.addSubview(signInWithAppleButton)
        view.backgroundColor = .systemBackground
    }
    
    private func configureLayout() {
        signInWithAppleButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(100)
            make.height.equalTo(50)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().inset(40)
        }
        iconImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(200)
        }
        setCountryTitleLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    private func configureNav() {
        navigationController?.navigationBar.topItem?.backButtonTitle = ""
        navigationController?.navigationBar.tintColor = UIColor.label
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.backgroundColor = .systemBackground
        navigationController?.navigationBar.standardAppearance = navigationBarAppearance
    }
    
    private func initProgressHUD() {
        ProgressHUD.colorAnimation = ServiceColor.primaryColor
        ProgressHUD.animationType = .circleStrokeSpin
    }
    
    private func addNotiCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(revokeTokenRefreshNotification(_:)), name: .revokeTokenRefresh, object: nil)
    }
    
    private func removeNotiCenter() {
        NotificationCenter.default.removeObserver(self, name: .revokeTokenRefresh, object: nil)
    }
    
    deinit {
        removeNotiCenter()
    }
    
    private func setServiceCountry() {
        let code = ServiceCountry.kr
        let rawCode = code.rawValue
        let identifier = NSLocale.localeIdentifier(fromComponents: [NSLocale.Key.countryCode.rawValue: rawCode])
        let localeIdentifier = Locale.preferredLanguages.first ?? "" // en-KR
        let countryName = NSLocale(localeIdentifier: localeIdentifier).displayName(forKey: NSLocale.Key.identifier, value: identifier) ?? "" // localize
        let countryInfo = Country(countryCode: rawCode, countryName: countryName, countryEmoji: rawCode.emojiFlag)
        setCountryTitleLabel.text = "\(countryInfo.countryEmoji) \(countryInfo.countryName)"
        LocationManager.shared.saveCountryCode(code: code)
    }
    
    @objc private func revokeTokenRefreshNotification(_ notification: Notification) {
        guard let identifier = UserDefaults.standard.object(forKey: UserSessionManager .currentServiceTypeIdentifier) as? String else { return }
        guard let userItem = try? KeychainManager.getUserItem(serviceType: identifier) else { return }
        ProgressHUD.show(interaction: false)
       
        let deleteApple = DeleteAppleAccountReq(identityToken: userItem.id_token, refreshToken: userItem.refresh_token, userId: userItem.userId)
        ProgressHUD.show(interaction: false)
        UserSessionManager.shared.deleteAccount(deleteAccountReq: deleteApple, userItem: userItem) { (response) in
            switch response {
            case .success:
                // 애플 회원탈퇴 후, 애플 계정 ID 사용 중단까지 실제 시간 추가 소요 (2~3초) >> 탈퇴 이후 바로 회원가입시 문제 안생김
                DispatchQueue.main.async {
                    ProgressHUD.dismiss()
                }
            default: // 네트워크 요청 실패시, 사용자 앱 강제 종료 유도 >> 다음번 앱 진입시 다시 재요청됨
                break
            }
        }
    }
    
    
    @objc func handleAuthorizationAppleIDButtonPress() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
}

extension LoginViewController: ASAuthorizationControllerDelegate {
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        ProgressHUD.show(interaction: false)

        // 로그 아웃시 처리 (이미 키체인에 저장되어있고 서비스 타입은 삭제되어있는 경우)
        if let userItem = try? KeychainManager.getUserItem(serviceType: UserSessionManager .Service.APPLE_SIGNIN.rawValue) { // SignInManager.service.
            // 로그인 api 요청후, 키체인 userstatus 업데이트 후 루트뷰 service화면으로 변경
            let logInApple = LogInAppleReq(refreshToken: userItem.refresh_token, servicesResponse: userItem.account)
            UserSessionManager .shared.logIn(logInReq: logInApple, userItem: userItem) { (response) in
                switch response {
                case .success:
                    DispatchQueue.main.async(qos: .userInteractive){ [self] in
                        if userItem.account.hasRequirementInfo {
                            let rootVC = UINavigationController(rootViewController: ServiceTabBarViewController())
                            view.window?.rootViewController = rootVC
                            view.window?.makeKeyAndVisible()
                        } else {
                            let SPVC = SetProfileViewController()
                            navigationController?.pushViewController(SPVC, animated: true)
                        }
                        ProgressHUD.dismiss()
                    }
                case .badResponse:
                    DispatchQueue.main.async {
                        ProgressHUD.dismiss()
                    }
                case .failureResponse:
                    DispatchQueue.main.async {
                        ProgressHUD.showFailed("NETWORKING_FAIL".localized())
                    }
                }
            }
        } else {
            if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
                let identifier = appleIDCredential.user // apple id
                
                // Real user indicator
//                let realUserStatus = appleIDCredential.realUserStatus// not nil
                
                guard let identityTokenData = appleIDCredential.identityToken,
                      let identityToken = String(data: identityTokenData, encoding: .utf8),
                      let authorizationCodeData = appleIDCredential.authorizationCode,
                      let authorizationCode = String(data: authorizationCodeData, encoding: .utf8)
                else { return }
                
                let userData: User
                if let user = try? KeychainManager.shared.getUser(userType: UserSessionManager .Service.UserInit.APPLE) {
                    userData = user
                } else {
                    // 초기 애플 서버 인증시에만 나옴
                    guard let givenName = appleIDCredential.fullName?.givenName,
                          let familyName = appleIDCredential.fullName?.familyName,
                          let userEmail = appleIDCredential.email
                    else { return }
                    
                    let name = Name(firstName: givenName, lastName: familyName)
                    
                    userData = User(name: name, email: userEmail)
                    
                    do {
                        // 초기 애플 서버 인증시에만 한번 제공 (email, name)
                        try KeychainManager.shared.saveUser(user: userData, userType: UserSessionManager .Service.UserInit.APPLE)
                    } catch {
                        print("KeychainManager.saveUser \(error.localizedDescription)")
                    }
                }
                
                let state = "SIGNIN" // state 사용안함, UserItem의 userStatus로 상태관리
               
                let account = Account(state: state, code: authorizationCode, id_token: identityToken, user: userData, identifier: identifier, hasRequirementInfo: false) // state 사용안함, UserItem의 userStatus로 상태관리
                
                // 회원가입
                UserSessionManager.shared.signUp(signUpReq: account) { (response) in
                    switch response {
                    case .success:
                        do {
                            // 이전에 초기 애플 서버 인증시에만 한번 제공한 (이메일, 이름) 삭제
                            try KeychainManager.shared.deleteUser(userType: UserSessionManager .Service.UserInit.APPLE)
                        } catch {
                            print("KeychainManager deleteUser error \(error.localizedDescription)")
                        }
                        DispatchQueue.main.async {
                            let SPVC = SetProfileViewController()
                            self.navigationController?.pushViewController(SPVC, animated: true)
                            ProgressHUD.dismiss()
                        }
                    case .badResponse:
                        DispatchQueue.main.async {
                            ProgressHUD.dismiss()
                        }
                    case .failureResponse:
                        DispatchQueue.main.async {
                            ProgressHUD.showFailed("NETWORKING_FAIL".localized())
                        }
                    }
                }
            }
        }
    }
    
    // 애플 자격 증명 확인 실패
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
        print("Authentication fail")
    }
}

extension LoginViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}

