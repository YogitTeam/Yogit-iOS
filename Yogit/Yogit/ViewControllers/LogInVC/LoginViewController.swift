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

class LoginViewController: UIViewController {

    private lazy var signInWithAppleButton: ASAuthorizationAppleIDButton = {
        let button = ASAuthorizationAppleIDButton(authorizationButtonType: .signIn, authorizationButtonStyle: .black)
        button.addTarget(self, action: #selector(handleAuthorizationAppleIDButtonPress), for: .touchUpInside)
        return button
    }()
    
    private lazy var deleteButton: UIButton = {
        let button = UIButton()
        button.setTitle("delete", for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 8
        button.isEnabled = false
        button.backgroundColor = .placeholderText
        button.addTarget(self, action: #selector(self.delteButtonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Yogit")?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = UIColor(rgb: 0x3232FF, alpha: 1.0)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = false
        imageView.sizeToFit()
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(iconImageView)
        view.addSubview(signInWithAppleButton)
        view.addSubview(deleteButton)
        configureViewComponent()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        signInWithAppleButton.snp.makeConstraints { make in
            make.left.right.equalTo(view).inset(20)
            make.bottom.equalTo(view.snp.bottom).inset(100)
            make.height.equalTo(50)
        }
        iconImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(300)
        }
        deleteButton.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalTo(50)
        }
    }
    
    
    private func configureViewComponent() {
        view.backgroundColor = .systemBackground
    }
    
    @objc func delteButtonTapped(_ sender: UITapGestureRecognizer) {
        do {
            try KeychainManager.deleteUserItem()
        } catch {
            print(error)
        }
    }
    
    @objc func handleAuthorizationAppleIDButtonPress() {
        
        
        // face id 거치고 뷰 전환 필요함
        // token 있는지 없는지 확인 후에
        
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    // Code move to the view requirement data
    //


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

// 로그인
// 로그아웃 >> 서버(로그아웃 상태 처리) >> 애플 서버()
// 계정삭제 >> 서버 토큰 삭제 & 애플 서버 알림

// 설정 창 >> 애플 사용 중단 >> 서버 endpoint로 전달-로그 아웃 처리
// 애플 사용 중단 이후 (로그아웃) >> 프론트 애플 자격 증명 요청 >> .revoke >> 로그인 페이지 >> 키체인 계정 정보 확인
//


// 프론트 >> 애플 로그인 버튼 클릭 >> 서버로 로그인 요청 >> 응답 (계정 정보 저장)
// 프론트 >> 로그 아웃 버튼 클릭 >> 서바로 로그 아웃 상태 처리 요청 & 애플  >> 응답 (키체인 상태 저장)
// 프론트 >> 계정 삭제 버튼 클릭 >> 서바로 계정 삭제 버튼 클릭 >> 응답 (키체인 계정 정보 삭제)


// 아직 안함: profile 입력후 응답갑 반환시 hasRequirementdata 값 서버에서 반환
extension LoginViewController: ASAuthorizationControllerDelegate {
    
    // 컨트롤러 뷰 애플 자격증먕 확인 완료 후 실행
    // 로그아웃 (키체인 state logout이면 홈화면 넘어감)
    // 설정창에서 애플 아이디 사용 중지시 (계정 삭제)
    // 애플 아이디 사용 중지하면 즉각적으로 알아야함 (화면 바로 들어가면 정보 용청을 하닌깐)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        print("Run authorizationController")
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            print("appleIDCredential")
            
            // 로그아웃시 세션 및 화면 처리
            SignInManager.checkUserAuth { (AuthState) in
                var rootViewState = RootViewState.loginView
                switch AuthState {
                case .undefine, .signOut: return
                case .signInFull: rootViewState = .homeView
                case .signInNotFull: rootViewState = .setProfileView
                }
                DispatchQueue.main.async {
                    switch rootViewState {
                    case .loginView:
                        break
                    case .homeView: // 필수 데이터 있으면
                        // 루트뷰 전환 요규
                        let homeVC = ServiceTapBarViewController()
                        let rootVC = UINavigationController(rootViewController: homeVC)
                        self.view.window?.rootViewController = rootVC
                        self.view.window?.makeKeyAndVisible()
                    case .setProfileView:
                        // 푸쉬로 이동
                        let setProfileVC = SetProfileViewController()
                        self.navigationController?.pushViewController(setProfileVC, animated: true)
                    }
                }
            }
            
            let identifier = appleIDCredential.user // apple id
            
            // Real user indicator
            let realUserStatus = appleIDCredential.realUserStatus// not nil
           
            // 처음 애플 서버 인증시에만 나옴
            guard let givenName = appleIDCredential.fullName?.givenName,
                  let familyName = appleIDCredential.fullName?.familyName,
                  let userEmail = appleIDCredential.email
            else { return }
            
            guard let identityTokenData = appleIDCredential.identityToken,
                  let identityToken = String(data: identityTokenData, encoding: .utf8),
                  let authorizationCodeData = appleIDCredential.authorizationCode,
                  let authorizationCode = String(data: authorizationCodeData, encoding: .utf8)
            else { return } // can nil

            let state = "SIGNIN"
            print("state \(state)")
            print("IdentityToken \(identityToken)")
            print("AuthorizationCode \(authorizationCode)")
            print("User Identifier \(identifier)")
            print("Full Name \(familyName), \(givenName)")
            print("Email \(userEmail)")
            print("RealUserStatus \(realUserStatus.rawValue)")

            
            let name = Name(firstName: givenName, lastName: familyName)
            let user = User(name: name, email: userEmail)
            let account = Account(state: state, code: authorizationCode, id_token: identityToken, user: user, identifier: identifier, hasRequirementInfo: false)
            
            
            // completion handelr, global queue
            AF.request(API.BASE_URL + "sign-up/apple",
                       method: .post,
                       parameters: account,
                       encoder: JSONParameterEncoder.default) // default set body and Content-Type HTTP header field of an encoded request is set to application/json
            .validate(statusCode: 200..<500)
            .responseData { response in // reponseData
                switch response.result {
                case .success:
                    DispatchQueue.global().async {
                        guard let data = response.value else { return }
                        debugPrint(response)
                        do{
                            let decodedData = try JSONDecoder().decode(APIResponse<UserItem>.self, from: data)
                            guard let userItem = decodedData.data else {
                                print("decodedData.data nil")
                                return
                            }
                            do {
                                // 신규 가입
                                try KeychainManager.saveUserItem(userItem: userItem)
                                DispatchQueue.main.async {
                                    let SPVC = SetProfileViewController()
                                    self.navigationController?.pushViewController(SPVC, animated: true)
                                }
                            } catch {
                                print("KeychainManager.saveUserItem \(error.localizedDescription)")
                            }
                        }
                        catch{
                            print("res try error \(error.localizedDescription)")
                        }
                    }
                case .failure(let error):
                    print(error)
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
