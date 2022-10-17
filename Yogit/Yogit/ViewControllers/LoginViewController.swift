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

//protocol LoginViewControllerDelegate {
//    func didAuth()
//}


class LoginViewController: UIViewController {
    
//    var delegate: LoginViewControllerDelegate?

    private lazy var signInWithAppleButton: ASAuthorizationAppleIDButton = {
        let button = ASAuthorizationAppleIDButton()
        button.addTarget(self, action: #selector(handleAuthorizationAppleIDButtonPress), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    }
    
    
    private func configureViewComponent() {
        view.backgroundColor = .systemBackground
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

extension LoginViewController: ASAuthorizationControllerDelegate {
    
    // 컨트롤러 뷰 애플 권한 확인 완료 후
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        print("Run authorizationController")
        // signinmanager 작동
        
        // 처음 token으로 서버 넘겨줄때, 필수 데이터 상태 받아옴 (init nil)
        
        // 키체인에서 애플 토큰 있으면 profile view 전환 (best)
        // 아니면 로직 그대로 >>
        
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            
            // Create an account in your system.
            // User ID
            let userIdentifier = appleIDCredential.user // not nill
            
            // Account information
            // name, email >> nil > get from keychain
//            let userFullName = appleIDCredential.fullName // can nill
            
            let givenName = appleIDCredential.fullName?.givenName ?? ""
            let middleName = appleIDCredential.fullName?.middleName ?? ""
            let familyName = appleIDCredential.fullName?.familyName ?? ""
            let fullName = givenName + middleName + familyName
            let userName: String? = fullName == "" ? nil : fullName
            
            let userEmail = appleIDCredential.email // can nil

            
            // Real user indicator
            let realUserStatus = appleIDCredential.realUserStatus// not nil
            
            guard let identityTokenData = appleIDCredential.identityToken else { return } // can nil
            
            let identityToken = String(data: identityTokenData, encoding: .utf8)!
            
            guard let authorizationCodeData = appleIDCredential.authorizationCode else { return }   // can nil
            
            let authorizationCode = String(data: authorizationCodeData, encoding: .utf8)!
            
            
            let signInWithAppleInfo = SignInWithAppleInfo(userName: userName, userEmail: userEmail, userIdentifier: userIdentifier, identityToken: identityToken, authorizationCode: authorizationCode, realUserStatus: realUserStatus.rawValue)
            
//            guard let baseUrl = URL(string: API.baseUrl) else { return }
//            let query: [String: String] = [
//                "api_key": "DEMO_KEY",
//                "date": "2011-07-13"
//            ]
//            guard let url = baseUrl.withQueries(query) else { return }
            
//            MyAlamofireManager
//                    .shared
//                    .session
//                    .request(AuthRouter.auth(term: signInWithAppleInfo))
//                    .validate(statusCode: 200..<500)
//                    .response { response in
//                        if let data = response.data {
//                            do{
//                                debugPrint(response)
//                                let decodedData = try JSONDecoder().decode(AppleToken.self, from: data)
//                                // save keychain & move view function
//                            } catch {
//                                print(error)
//                            }
//                        }
//                    }
//
////            guard let baseUrl = URL(string: API.BASE_URL) else { return }
//
//            // paramters into http body
//            AF.request(API.BASE_URL + "",
//                       method: .post,
//                       parameters: signInWithAppleInfo,
//                       encoder: URLEncodedFormParameterEncoder(destination:.httpBody))
//            .validate(statusCode: 200..<500)
//            .response { response in // reponseData
//                switch response.result {
//                case .success:
//                    debugPrint(response)
//                    if let data = response.data {
//                        do{
//                            debugPrint(response)
//                            let decodedData = try JSONDecoder().decode(AppleToken.self, from: data)
//                            // save keychain & move view function
//                        } catch {
//                            print(error)
//                        }
//                    }
//                case .failure(let error):
//                    debugPrint(response)
//                    print(error)
//                }
//            }
//
//
//            saveUserIdentifier(userIdentifier: userIdentifier)
            // Verification data
//            if let identityToken = appleIDCredential.identityToken {
//                let string = String(data: identityToken, encoding: .utf8)
//                print("Identity Token \(String(describing: string))")
//
////                let tokenElement: [ String : Data ] = [TokenSource.apple.rawValue : identityToken]
////                saveToken(token: tokenElement)
//            }
//
//            if let authorizationCode = appleIDCredential.authorizationCode {
//                let string = String(data: authorizationCode, encoding: .utf8)
//                print("Auth Code \(String(describing: string))")
//            }
            
            

            // For the purpose of this demo app, store the `userIdentifier` in the keychain.
//            save userdefualt make function
//            saveUserIdentifier(userIdentifier: userIdentifier)
            print("IdentityToken \(identityToken)")
            print("AuthorizationCode \(authorizationCode)")
            print("User Identifier \(userIdentifier)")
            print("Full Name \(userName)")
            print("Email \(userEmail)")
            print("RealUserStatus \(realUserStatus.rawValue)")
            
            let account = Account(userName: userName, userEmail: userEmail, userIdentifier: userIdentifier, userId: 1)
            let userItem = UserItem(accunt: account, service: Service.APPLE_SIGNIN , token: identityToken) // refresh token으로 변경
            
            
        case let passwordCredential as ASPasswordCredential:

            // Sign in using an existing iCloud Keychain credential.
            let userName = passwordCredential.user
            let password = passwordCredential.password

            // For the purpose of this demo app, show the password credential as an alert.
//            DispatchQueue.main.async {
//                self.showPasswordCredentialAlert(username: username, password: password)
//            }

            print("User name \(userName)")
            print("Password \(password)")
        
        default:
            break
        }
        print("Free authorizationController")
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
        print("Authentication fail")
    }
    
    func saveUserIdentifier(userIdentifier: String) {
        UserDefaults.standard.set(userIdentifier, forKey: SignInManager.userIdentifierKey)
    }
    
    func saveToken(userItem: UserItem) { // paramter 수정 필요
        // save token in keychain
        
        do {
            try KeychainManager.saveUserItem(userItem: userItem)
        }
        catch {
            print(error)
        }
        
//        UserDefaults.standard.set(token, forKey: SignInManager.tokenElementKey)
        RequirementInfoManager.checkIsFullRequirementInfo { (RequirementInfoState) in
            switch RequirementInfoState {
            case .full:
                break
            case .notFull:
                self.navigationController?.pushViewController(SetUpProfileTableViewController(), animated: true)
                break
            }
        }
    } 
}

extension LoginViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}
