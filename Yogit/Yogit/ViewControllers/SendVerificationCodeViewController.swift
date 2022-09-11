//
//  SendVerificationCodeViewController.swift
//  Yogit
//
//  Created by Junseo Park on 2022/09/06.
//

import UIKit
import SnapKit
import Alamofire

class SendVerificationCodeViewController: UIViewController {
    
    // MARK: Properties
    
    lazy var nationalFlagImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Rectangle1")
        imageView.contentMode = .scaleAspectFit
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.green.cgColor
        return imageView
    }()
    
    lazy var countryCodeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16.0)
        label.text = "+82" // country code
        label.textAlignment = .center
        
        // Label frame size to fit as text of label
        label.sizeToFit()
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        
        label.layer.borderWidth = 1
        label.layer.borderColor = UIColor.black.cgColor
        return label
    }()
    
    lazy var phoneNumberTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Phone Number"
        textField.font = UIFont.systemFont(ofSize: 16.0)
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.orange.cgColor
        textField.keyboardType = UIKeyboardType.numberPad
        textField.returnKeyType = UIReturnKeyType.done
        return textField
    }()
    
    lazy var countryContentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.layer.borderColor = UIColor.systemRed.cgColor
        stackView.layer.borderWidth = 1
        stackView.axis = .horizontal
        
//        stackView.alignment = .fill
//        stackView.distribution = .fill
        
        stackView.spacing = 6

        stackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.countryContentStackViewTapped(_:))))
        
        [self.nationalFlagImageView,
         self.countryCodeLabel].forEach { stackView.addArrangedSubview($0) }
        return stackView
    }()
    
    lazy var phoneNumberContentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        
//        stackView.alignment = .fill
//        stackView.distribution = .fill
        
        stackView.spacing = 10
        stackView.layer.borderColor = UIColor.systemGray.cgColor
        stackView.layer.borderWidth = 1
        stackView.layer.cornerRadius = 12

        stackView.spacing = 10.0

        stackView.layoutMargins.left = 10
        stackView.layoutMargins.right = 10
        stackView.isLayoutMarginsRelativeArrangement = true
//        stackView.layoutMargins = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)

        [self.countryContentStackView,
         self.phoneNumberTextField].forEach { stackView.addArrangedSubview($0) }
        return stackView
    }()
    
    lazy var sendVerificationCodeButton: UIButton = {
        let button = UIButton()
        button.setTitle("Continue", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16.0)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 12
        
        button.addTarget(self, action: #selector(sendVerificationCodeButtonTapped(_:)), for: .touchUpInside)
        
        return button
    }()
    
    lazy var touchPrintLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16.0)
        label.text = "Not touch" // country code
        label.textAlignment = .center
        label.layer.borderWidth = 1
        label.layer.borderColor = UIColor.black.cgColor
        return label
    }()

    // MARK: Life Cycle functions
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(phoneNumberContentStackView)
        view.addSubview(sendVerificationCodeButton)
        view.addSubview(touchPrintLabel)
        configureViewComponent()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        phoneNumberContentStackView.snp.makeConstraints { make in
            make.left.right.equalTo(view).inset(20)
            make.top.equalTo(touchPrintLabel.snp.bottom).offset(100)
            make.height.equalTo(50)
        }
        
        sendVerificationCodeButton.snp.makeConstraints { make in
            make.left.right.equalTo(view).inset(20)
            make.top.equalTo(phoneNumberContentStackView.snp.bottom).offset(10)
            make.height.equalTo(50)
        }
        
        touchPrintLabel.snp.makeConstraints { make in
            make.left.right.equalTo(view).inset(20)
            make.top.equalTo(view).inset(100)
            make.height.equalTo(30)
        }
    }
    
    // MARK: Configure View Component
    private func configureViewComponent() {
        view.backgroundColor = .systemBackground
        phoneNumberContentStackView.backgroundColor = .systemBackground
    }
    
    @objc func countryContentStackViewTapped(_ sender: UITapGestureRecognizer? = nil) {
        touchPrintLabel.text = "Touch countryContentStackView"
        // First Not handle
        // Move to view which choose the national flag and country code
        // Move animate under >> up
    }
    
//    @objc func countryContentStackViewTapped(_ sender: UIStackView) {
//        touchPrintLabel.text = "Touch countryContentStackView"
//        // First Not handle
//        // Move to view which choose the national flag and country code
//        // Move animate under >> up
//    }
    
    @objc func sendVerificationCodeButtonTapped(_ sender: UIButton) {
        touchPrintLabel.text = sender.titleLabel?.text
        navigationController?.pushViewController(PhoneNumberVerificationViewController(), animated: true)
        // Post (phoneNumber)
        // Move to view which input verification code
        // time limit 3 min
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
