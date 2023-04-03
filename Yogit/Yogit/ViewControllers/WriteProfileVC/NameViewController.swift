//
//  NameViewController.swift
//  Yogit
//
//  Created by Junseo Park on 2023/01/21.
//

import UIKit
import SnapKit

protocol NameProtocol: AnyObject {
    func nameSend(name: String)
}

class NameViewController: UIViewController {
    
    weak var delegate: NameProtocol?
    
    var userName: String?
  
    private let textMin = 2
    private let textMax = 18
    
    private lazy var rightButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "DONE".localized(), style: .plain, target: self, action: #selector(rightButtonPressed(_:)))
        button.tintColor =  UIColor(rgb: 0x3232FF, alpha: 1.0)
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "NAME_TITLE".localized()
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 20, weight: UIFont.Weight.semibold)
        label.numberOfLines = 0
        label.sizeToFit()
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private let subTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "NAME_SUBTITLE".localized()
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 15, weight: UIFont.Weight.regular)
        label.numberOfLines = 0
        label.textColor = .systemGray
        label.sizeToFit()
        return label
    }()
    
    private lazy var nameTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.regular)
        textField.isEnabled = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "NAME_PLACEHOLDER".localized()
        textField.text = userName
        textField.layer.borderColor = UIColor.placeholderText.cgColor
        textField.layer.borderWidth = 1.2
        textField.layer.cornerRadius = 10
        textField.delegate = self
        textField.addLeftPadding(width: 10)
        return textField
    }()
    
    private lazy var textCountLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 14, weight: UIFont.Weight.regular)
        label.textColor = .placeholderText
        label.text = "\(nameTextField.text?.count ?? 0) / \(textMax)"
        label.sizeToFit()
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNav()
        configureView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        nameTextField.snp.makeConstraints {
            $0.top.equalTo(subTitleLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(50)
        }
        textCountLabel.snp.makeConstraints {
            $0.top.equalTo(nameTextField.snp.bottom).offset(4)
            $0.trailing.equalToSuperview().inset(20)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    private func configureNav() {
        navigationItem.title = "NAME_NAVIGATIONITEM_TITLE".localized()
        navigationItem.rightBarButtonItem = rightButton
    }
    
    private func configureView() {
        view.backgroundColor = .systemBackground
        [titleLabel,
         subTitleLabel,
         nameTextField,
         textCountLabel].forEach { view.addSubview($0) }
    }
    
    @objc private func rightButtonPressed(_ sender: Any) {
        if userName?.count ?? 0 >= textMin && userName?.count ?? 0 <= textMax {
            guard let userName = userName else { return }
            delegate?.nameSend(name: userName)
            self.navigationController?.popViewController(animated: true)
        } else {
            let alert = UIAlertController(title: "", message: "NAME_ALERT".localized(), preferredStyle: UIAlertController.Style.alert)
            let okAction = UIAlertAction(title: "OK".localized(), style: .default)
            alert.addAction(okAction)
            present(alert, animated: false, completion: nil)
        }
    }
}

extension NameViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        userName = textField.text
        if userName?.count ?? 0 >= textMin {
            textCountLabel.textColor = UIColor(rgb: 0x3232FF, alpha: 1.0)
        } else {
            textCountLabel.textColor = .systemRed
        }
        textCountLabel.text = "\(textField.text?.count ?? 0) / \(textMax)"
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        return updatedText.count <= textMax
    }
}
