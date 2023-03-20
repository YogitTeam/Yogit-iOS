//
//  JobViewController.swift
//  Yogit
//
//  Created by Junseo Park on 2023/01/20.
//

import UIKit
import SnapKit

protocol JobProtocol {
    func jobSend(job: String)
}

class JobViewController: UIViewController {
    
    // crate 일때, bottom 버튼 존재
    var mode: Mode = .create  {
        didSet {
            if mode == .edit {
                rightButton.isHidden = false
                nextButton.isHidden = true
            }
        }
    }
    
    var delegate: JobProtocol?
    
    var userProfile = UserProfile()
    
    private let textMax = 30
    
    private lazy var nextButton: UIButton = {
        let button = UIButton()
//        button.setTitle("Done", for: .normal)
        button.setImage(UIImage(named: "push")?.withTintColor(.white, renderingMode: .alwaysOriginal), for: .normal)
        button.tintColor = .white
        button.isHidden = false
        button.isEnabled = true
        button.backgroundColor = UIColor(rgb: 0x3232FF, alpha: 1.0)
//        button.setTitleColor(UIColor(rgb: 0x3232FF, alpha: 1.0), for: .normal)
//        button.titleLabel?.font = .systemFont(ofSize: 18, weight: UIFont.Weight.semibold)
        button.addTarget(self, action: #selector(self.nextButtonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var rightButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(rightButtonPressed(_:)))
        button.tintColor =  UIColor(rgb: 0x3232FF, alpha: 1.0)
        button.isHidden = true
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Let global friends know what I do 📌"
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 22, weight: UIFont.Weight.semibold)
        label.numberOfLines = 0
        label.sizeToFit()
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    let jobTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.medium)
        textField.isEnabled = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "What do you do?"
        textField.layer.borderColor = UIColor.placeholderText.cgColor
        textField.layer.borderWidth = 1.2
        textField.layer.cornerRadius = 10
        textField.addLeftPadding(width: 10)
        return textField
    }()
    
    private lazy var textCountLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 14, weight: UIFont.Weight.regular)
        label.textColor = .placeholderText
        label.text = "\(jobTextField.text?.count ?? 0) / \(textMax)"
        label.sizeToFit()
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        [titleLabel,
         jobTextField,
         textCountLabel,
        nextButton].forEach { view.addSubview($0) }
        configureViewComponent()
        jobTextField.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        jobTextField.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(50)
        }
        textCountLabel.snp.makeConstraints {
            $0.top.equalTo(jobTextField.snp.bottom).offset(4)
            $0.trailing.equalToSuperview().inset(20)
        }
        nextButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(20)
            $0.width.height.equalTo(60)
        }
        nextButton.layer.cornerRadius = nextButton.frame.size.width/2
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    private func configureViewComponent() {
        self.navigationItem.title = "What I do"
        self.view.backgroundColor = .systemBackground
        self.navigationItem.rightBarButtonItem = rightButton
    }
    
    @objc private func rightButtonPressed(_ sender: Any) {
        delegate?.jobSend(job: jobTextField.text ?? "")
        DispatchQueue.main.async(qos: .userInteractive, execute: {
            self.navigationController?.popViewController(animated: true)
        })
    }
    
    @objc func nextButtonTapped(_ sender: UIButton) {
        userProfile.job = jobTextField.text
        DispatchQueue.main.async(qos: .userInteractive, execute: {
            let AMVC = AboutMeViewController()
            AMVC.mode = self.mode
            AMVC.userProfile = self.userProfile
            self.navigationController?.pushViewController(AMVC, animated: true)
        })
    }
}

extension JobViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        textCountLabel.text = "\(textField.text?.count ?? 0) / \(textMax)"
        if (jobTextField.text?.count ?? 0) <= 0 {
            textCountLabel.textColor = .placeholderText
        } else {
            textCountLabel.textColor = .label
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        return updatedText.count <= textMax
    }
}
