//
//  TextFieldViewController.swift
//  Yogit
//
//  Created by Junseo Park on 2022/11/07.
//

import UIKit

class TextFieldViewController: UIViewController, UITextFieldDelegate {

    let profileTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.regular)
        textField.isEnabled = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.systemRed.cgColor
        return textField
    }()
    
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        print("end")
//    }
    
//    func textFieldDidChangeSelection(_ textField: UITextField) {
//        print("afdsfadsf")
//    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(profileTextField)
        view.backgroundColor = .systemBackground
        profileTextField.delegate = self
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        profileTextField.snp.makeConstraints { make in
            make.height.equalTo(44)
            make.width.equalToSuperview()
            make.center.equalToSuperview()
        }
    }
    


}
