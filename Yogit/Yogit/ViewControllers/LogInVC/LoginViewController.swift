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
//        let button = ASAuthorizationAppleIDButton(authorizationButtonType: .signIn, authorizationButtonStyle: UITraitCollection.current.userInterfaceStyle == .dark ? .white : .black)
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
        initProgressHUD()
        addNotiCenter()
        setCountry()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeNotiCenter()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
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
    
    private func configureView() {
        view.addSubview(iconImageView)
        view.addSubview(setCountryTitleLabel)
        view.addSubview(signInWithAppleButton)
        view.backgroundColor = .systemBackground
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
    
    private func setCountry() {
        let code = ServiceCountry.kr
        let rawCode = code.rawValue
        let identifier = NSLocale.localeIdentifier(fromComponents: [NSLocale.Key.countryCode.rawValue: rawCode])
        let localeIdentifier = Locale.preferredLanguages.first ?? "" // en-KR
        let countryName = NSLocale(localeIdentifier: localeIdentifier).displayName(forKey: NSLocale.Key.identifier, value: identifier) ?? "" // localize
        let countryInfo = Country(countryCode: rawCode, countryName: countryName, countryEmoji: rawCode.emojiFlag)
        setCountryTitleLabel.text = "\(countryInfo.countryEmoji) \(countryInfo.countryName)"
        SessionManager.saveCountryCode(code: code)
    }
    
    @objc private func revokeTokenRefreshNotification(_ notification: Notification) {
        print("LoginVC - revokeTokenRefreshNotification")
        guard let identifier = UserDefaults.standard.object(forKey: SessionManager.currentServiceTypeIdentifier) as? String else { return }
        guard let userItem = try? KeychainManager.getUserItem(serviceType: identifier) else { return }
        ProgressHUD.show(interaction: false)
        let deleteApple = DeleteAppleAccountReq(identityToken: userItem.id_token, refreshToken: userItem.refresh_token, userId: userItem.userId)
        AlamofireManager.shared.session
            .request(SessionRouter.deleteApple(parameters: deleteApple))
            .validate(statusCode: 200..<501)
            .responseDecodable(of: APIResponse<String>.self) { response in
                switch response.result {
                case .success:
                    if let value = response.value, value.httpCode == 200 || value.httpCode == 201 {
                        do {
                            try KeychainManager.deleteUserItem(userItem: userItem)
                            DispatchQueue.main.async {
                                ProgressHUD.dismiss()
                            }
                        } catch {
                            print("KeychainManager.deleteUserItem \(error.localizedDescription)")
                        }
                    }
                case let .failure(error):
                    print("Delete account decoding error", error)
                    DispatchQueue.main.async { // 변경
                        ProgressHUD.dismiss()
                    }
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
        print("Run authorizationController")
        
        ProgressHUD.show(interaction: false)

        // 로그 아웃시 처리 (이미 키체인에 저장되어있고 서비스 타입은 삭제되어있는 경우)
        if let userItem = try? KeychainManager.getUserItem(serviceType: SessionManager.Service.APPLE_SIGNIN) { // SignInManager.service.
            // 로그인 api 요청후, 키체인 userstatus 업데이트 후 루트뷰 service화면으로 변경
            let logInApple = LogInAppleReq(refreshToken: userItem.refresh_token, servicesResponse: userItem.account)
            AlamofireManager.shared.session
                .request(SessionRouter.logInApple(parameters: logInApple))
                .validate(statusCode: 200..<501)
                .responseDecodable(of: APIResponse<UserItem>.self) { response in
                    switch response.result {
                    case .success:
                        if let value = response.value, value.httpCode == 200 || value.httpCode == 201, let data = value.data {
                            do {
                                // userStatus 정보 업데이트 (LOGIN)
                                // status만 업데이트
                                userItem.userStatus = data.userStatus
                                try KeychainManager.updateUserItem(userItem: userItem)
                                
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
                            } catch {
                                print("KeychainManager.updateUserItem \(error.localizedDescription)")
                            }
                        }
                    case let .failure(error):
                        print(error)
                        DispatchQueue.main.async {
                            ProgressHUD.dismiss()
                        }
                    }
                }
        } else {
            switch authorization.credential {
            case let appleIDCredential as ASAuthorizationAppleIDCredential:
                print("appleIDCredential")
                
                let identifier = appleIDCredential.user // apple id
                
                // Real user indicator
                let realUserStatus = appleIDCredential.realUserStatus// not nil
                print("realUserStatus", realUserStatus)
                
                guard let identityTokenData = appleIDCredential.identityToken,
                      let identityToken = String(data: identityTokenData, encoding: .utf8),
                      let authorizationCodeData = appleIDCredential.authorizationCode,
                      let authorizationCode = String(data: authorizationCodeData, encoding: .utf8)
                else { return }
                
                let userData: User
                if let user = try? KeychainManager.getUser(userType: SessionManager.Service.User.APPLE) {
                    userData = user
                    print("기존 User", userData.name, userData.email)
                } else {
                    // 처음 애플 서버 인증시에만 나옴
                    guard let givenName = appleIDCredential.fullName?.givenName,
                          let familyName = appleIDCredential.fullName?.familyName,
                          let userEmail = appleIDCredential.email
                    else { return }
                    
                    let name = Name(firstName: givenName, lastName: familyName)
                    
                    userData = User(name: name, email: userEmail)
                    
                    do {
                        // 처음 애플 서버 인증시에만 한번 제공 (email, name)
                        try KeychainManager.saveUser(user: userData, userType: SessionManager.Service.User.APPLE)
                    } catch {
                        print("KeychainManager.saveUser \(error.localizedDescription)")
                    }
                    
                    print("새로운 User name, email", userData.name, userData.email)
                }
                
                let state = "SIGNIN" // state 사용안함, UserItem의 userStatus로 상태관리
               
                let account = Account(state: state, code: authorizationCode, id_token: identityToken, user: userData, identifier: identifier, hasRequirementInfo: false) // state 사용안함, UserItem의 userStatus로 상태관리
                
                // 회원가입
                AlamofireManager.shared.session
                    .request(SessionRouter.signUpApple(parameters: account))
                    .validate(statusCode: 200..<501)
                    .responseDecodable(of: APIResponse<UserItem>.self) { response in
                        switch response.result {
                        case .success:
                            if let value = response.value, value.httpCode == 200 || value.httpCode == 201 {
                                guard let data = value.data else { return }
                                do {
                                    // 신규 가입
                                    // hasRequirementInfo false로 반환되는지 확인
                                    do {
                                        try KeychainManager.deleteUser(userType: SessionManager.Service.User.APPLE)
                                    } catch {
                                        print("KeychainManager deleteUser error \(error.localizedDescription)")
                                    }
                                    
                                    try KeychainManager.saveUserItem(userItem: data)
                                    
                                    DispatchQueue.main.async(qos: .userInteractive, execute: { [self] in
                                        let SPVC = SetProfileViewController()
                                        navigationController?.pushViewController(SPVC, animated: true)
                                        ProgressHUD.dismiss()
                                    })
                                    
                                } catch {
                                    print("KeychainManager saveUserItem error \(error.localizedDescription)")
                                }
                            }
                        case let .failure(error):
                            print(error)
                            DispatchQueue.main.async { // 변경
                                ProgressHUD.dismiss()
                            }
                        }
                    }
            case let passwordCredential as ASPasswordCredential:
                print("passwordCredential")
                // Sign in using an existing iCloud Keychain credential.
                let userName = passwordCredential.user
                let password = passwordCredential.password
                
                print("User name \(userName)")
                print("Password \(password)")
            default:
                break
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
