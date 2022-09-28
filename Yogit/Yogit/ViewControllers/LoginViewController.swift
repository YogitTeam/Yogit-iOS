//
//  AuthenticationViewController.swift
//  Yogit
//
//  Created by Junseo Park on 2022/09/17.
//

import UIKit
import SnapKit
import AuthenticationServices

protocol LoginViewControllerDelegate {
    func didAuth()
}

class LoginViewController: UIViewController {
    
    var delegate: LoginViewControllerDelegate?

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
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        print("authorizationController")
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            
            // Create an account in your system.
            // User ID
            let userIdentifier = appleIDCredential.user
            
            saveUserIdentifier(userIdentifier: userIdentifier)
            
//            guard let identityToken = appleIDCredential.identityToken else { return }
//
//            guard let authorizationCode = appleIDCredential.authorizationCode else { return }
            
            // Verification data
            if let identityToken = appleIDCredential.identityToken {
                let string = String(data: identityToken, encoding: .utf8)
                print("Identity Token \(String(describing: string))")
                
//                let tokenElement: [ String : Data ] = [TokenSource.apple.rawValue : identityToken]
//                saveToken(token: tokenElement)
            }
            
            if let authorizationCode = appleIDCredential.authorizationCode {
                let string = String(data: authorizationCode, encoding: .utf8)
                print("Auth Code \(String(describing: string))")
            }
            
            // Account information
            let fullName = appleIDCredential.fullName
            let email = appleIDCredential.email
            
            // Real user indicator
            let realUserStatus = appleIDCredential.realUserStatus
            print(realUserStatus.rawValue)
            

            // For the purpose of this demo app, store the `userIdentifier` in the keychain.
//            save userdefualt make function
//            saveUserIdentifier(userIdentifier: userIdentifier)
            
            print("User Identifier \(userIdentifier)")
            print("Full Name \(fullName)")
            print("Email \(email)")
            print("RealUserStatus \(realUserStatus.rawValue)")
            
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
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
        print("Authentication fail")
    }
    
    func saveUserIdentifier(userIdentifier: String) {
        UserDefaults.standard.set(userIdentifier, forKey: SignInManager.userIdentifierKey)
    }
    
    func saveToken(token: [String : Data]) {
        UserDefaults.standard.set(token, forKey: SignInManager.accessTokenKey)
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
