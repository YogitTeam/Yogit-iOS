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
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            
            let identifier = appleIDCredential.user // not nill
            guard let givenName = appleIDCredential.fullName?.givenName else { return } // 처음 애플 서버 인증시에만 나옴
            guard let familyName = appleIDCredential.fullName?.familyName else { return }
            guard let userEmail = appleIDCredential.email else { return } // 처음 애플 서버 인증시에만 나옴
            
            // Real user indicator
            let realUserStatus = appleIDCredential.realUserStatus// not nil
            
            guard let identityTokenData = appleIDCredential.identityToken, let identityToken = String(data: identityTokenData, encoding: .utf8) else { return } // can nil
            
//            let identityToken = String(data: identityTokenData, encoding: .utf8)!
            
            guard let authorizationCodeData = appleIDCredential.authorizationCode, let authorizationCode = String(data: authorizationCodeData, encoding: .utf8) else { return }   // can nil
            
//            let authorizationCode = String(data: authorizationCodeData, encoding: .utf8)!
            let state = appleIDCredential.state ?? "first SignUp"
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
                                if try KeychainManager.saveUserItem(userItem: userItem) {
                                    DispatchQueue.main.async {
                                        let SPVC = SetUpProfileViewController()
                                        self.navigationController?.pushViewController(SPVC, animated: true)
                                    }
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

            // Sign in using an existing iCloud Keychain credential.
            let userName = passwordCredential.user
            let password = passwordCredential.password


            print("User name \(userName)")
            print("Password \(password)")
        
        default:
            break
        }
    
    }
    
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
