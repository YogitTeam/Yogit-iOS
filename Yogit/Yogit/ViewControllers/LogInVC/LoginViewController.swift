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
    }
    
    
    private func configureViewComponent() {
        view.backgroundColor = .systemBackground
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
        // face id 거치고 뷰 전환 필요함
        // token 있는지 없는지 확인 후에
        // 로그아웃시 세션 및 화면 처리 요구
        // 키체인 status로 구분
        
        
        // 애플 계정 상태 이미 확인 후에
        // 로그아웃 >> 로그인 api쏜다음 userStatus 값 변경후, SignInManager로 애플 권한 있는지만 확인후 서비스 화면 이동(로그아웃은 서비스화면에서만 가능함으로, hasRequirementInfo 확인할 필요 없다.)
        // 계정삭제 및 애플 사용 중단 (이미 SignInManager에서 키체인 유저 정보 삭제 및 애플 권한 revoke처리 되어있음, 애플 권한 갱신 필요)
        // 회원 가입 ()
        // 애플 사용자 중단
        
        
        // 로그 아웃시 처리 (이미 키체인에 저장되어있는경우)
        if let userItem = try? KeychainManager.getUserItem() { // SignInManager.service.
            // 로그인 api 요청후, 키체인 userstatus 업데이트 후 루트뷰 service화면으로 변경
            let logInApple = LogInAppleReq(refreshToken: userItem.refresh_token, servicesResponse: userItem.account)
            AlamofireManager.shared.session
                .request(SessionRouter.logInApple(parameters: logInApple))
                .validate(statusCode: 200..<501)
                .responseDecodable(of: APIResponse<UserItem>.self) { response in
                    switch response.result {
                    case .success:
                        guard let value = response.value else { return }
                        if value.httpCode == 200 {
                            guard let data = value.data else { return }
                            do {
                                // userStatus 정보 업데이트 (LOGIN)
                                // status만 업데이트
                                try KeychainManager.updateUserItem(userItem: data)
                                let rootVC = UINavigationController(rootViewController: ServiceTapBarViewController())
                                DispatchQueue.main.async { [self] in
                                    view.window?.rootViewController = rootVC
                                    view.window?.makeKeyAndVisible()
                                }
                            } catch {
                                print("KeychainManager.saveUserItem \(error.localizedDescription)")
                            }
                        }
                    case let .failure(error):
                        print(error)
                    }
                }
        }
        
        
        
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            print("appleIDCredential")
            
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
            
            // 회원가입
            AlamofireManager.shared.session
                .request(SessionRouter.signUpApple(parameters: account))
                .validate(statusCode: 200..<501)
                .responseDecodable(of: APIResponse<UserItem>.self) { response in
                    switch response.result {
                    case .success:
                        guard let value = response.value else { return }
                        if value.httpCode == 200 {
                            guard let data = value.data else { return }
                            do {
                                // 신규 가입
                                // hasRequirementInfo false로 반환되는지 확인
                                try KeychainManager.saveUserItem(userItem: data)
                                DispatchQueue.main.async(qos: .userInteractive, execute: { [self] in
                                    let SPVC = SetProfileViewController()
                                    self.navigationController?.pushViewController(SPVC, animated: true)
                                })
                            } catch {
                                print("KeychainManager.saveUserItem \(error.localizedDescription)")
                            }
                        }
                    case let .failure(error):
                        print(error)
                    }
                }
            
            
//            // completion handelr, global queue
//            AF.request(API.BASE_URL + "sign-up/apple",
//                       method: .post,
//                       parameters: account,
//                       encoder: JSONParameterEncoder.default) // default set body and Content-Type HTTP header field of an encoded request is set to application/json
//            .validate(statusCode: 200..<500)
//            .responseData { response in // reponseData
//                switch response.result {
//                case .success:
//                    DispatchQueue.global().async {
//                        guard let data = response.value else { return }
//                        debugPrint(response)
//                        do{
//                            let decodedData = try JSONDecoder().decode(APIResponse<UserItem>.self, from: data)
//                            guard let userItem = decodedData.data else {
//                                print("decodedData.data nil")
//                                return
//                            }
//                            do {
//                                // 신규 가입
//                                try KeychainManager.saveUserItem(userItem: userItem)
//                                DispatchQueue.main.async {
//                                    let SPVC = SetProfileViewController()
//                                    self.navigationController?.pushViewController(SPVC, animated: true)
//                                }
//                            } catch {
//                                print("KeychainManager.saveUserItem \(error.localizedDescription)")
//                            }
//                        }
//                        catch{
//                            print("res try error \(error.localizedDescription)")
//                        }
//                    }
//                case .failure(let error):
//                    print(error)
//                }
//            }
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
