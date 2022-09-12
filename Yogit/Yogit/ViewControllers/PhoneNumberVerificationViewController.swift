//
//  PhoneVerificationViewController.swift
//  Yogit
//
//  Created by Junseo Park on 2022/09/06.
//

import UIKit
import SnapKit
import Alamofire

class PhoneNumberVerificationViewController: UIViewController {
    
    private lazy var phoneNumberLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16.0)
        label.textAlignment = .center
        label.text = UserDefaults.standard.object(forKey: "phoneNumber") as? String
        label.layer.borderWidth = 1
        label.layer.borderColor = UIColor.black.cgColor
        return label
    }()
    
    private lazy var verificationCodeTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Verification Code"
        textField.font = UIFont.systemFont(ofSize: 16.0)
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.orange.cgColor
        textField.keyboardType = UIKeyboardType.numberPad
        textField.returnKeyType = UIReturnKeyType.done
        return textField
    }()
    
    private lazy var SendVerificationCodeButton: UIButton = {
        let button = UIButton()
        button.setTitle("OK", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16.0)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 12
        
        button.addTarget(self, action: #selector(sendVerificationCodeButtonTapped(_:)), for: .touchUpInside)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(phoneNumberLabel)
        view.addSubview(verificationCodeTextField)
        view.addSubview(SendVerificationCodeButton)
        configureViewComponent()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        phoneNumberLabel.snp.makeConstraints { make in
            make.left.right.equalTo(view).inset(20)
            make.top.equalTo(view).inset(100)
            make.height.equalTo(30)
        }
        verificationCodeTextField.snp.makeConstraints { make in
            make.left.right.equalTo(view).inset(20)
            make.top.equalTo(phoneNumberLabel.snp.bottom).offset(20)
            make.height.equalTo(50)
        }
        SendVerificationCodeButton.snp.makeConstraints { make in
            make.left.right.equalTo(view).inset(20)
            make.top.equalTo(verificationCodeTextField.snp.bottom).offset(30)
            make.height.equalTo(50)
        }
    }
    
    // MARK: Configure View Component
    private func configureViewComponent() {
        view.backgroundColor = .systemBackground
    }
    
    @objc func sendVerificationCodeButtonTapped(_ sender: UIButton) {
        // Post (phoneNumber)
        // Move to view which input verification code
        // time limit 3 min
        guard let url = URL(string: "") else { return }
        guard let phoneNumber = phoneNumberLabel.text else { return }
        guard let verificationCode = verificationCodeTextField.text else { return }

        var request = URLRequest(url: url)

        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Authorization")
        request.timeoutInterval = 10


        // sendbutton must be active when country digit is correct
        let parameter = ["phoneNumber":"\(phoneNumber)", "verificationCode":"\(verificationCode)"] as Dictionary

        do {
            try request.httpBody = JSONSerialization.data(withJSONObject: parameter, options: [])
        } catch {
            print("http Body Error")
            print(error.localizedDescription)
        }

        AF.request(request)
        .validate(statusCode: 200..<500)
        .responseData { response in
            switch response.result {
            case .success(let data):
                debugPrint(response)
                guard let userId = String(data: data, encoding: String.Encoding.utf8) as String? else { return }
                let userDefaults = UserDefaults.standard
                userDefaults.set(userId, forKey: "userId")
                print("👤User ID = \(userId)")
                self.navigationController?.pushViewController(ProfileViewController(), animated: true)
            case .failure(let error):
                print(error)
            }
        }
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

