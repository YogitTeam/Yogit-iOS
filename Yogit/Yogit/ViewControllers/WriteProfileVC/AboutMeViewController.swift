//
//  AboutMeViewController.swift
//  Yogit
//
//  Created by Junseo Park on 2023/01/20.
//

import UIKit

protocol AboutMeProtocol: AnyObject {
    func aboutMeSend(aboutMe: String)
}

class AboutMeViewController: UIViewController {
    
    var mode: Mode = .create {
        didSet {
            if mode == .edit {
                nextButton.isHidden = true
            }
        }
    }
    
    var userProfile = UserProfile()
    
    weak var delegate: AboutMeProtocol?
    
    private let textMax = 300
    
    let aboutMeTextView = MyTextView()
    
    private let placeholder = "ABOUTME_PLACEHOLDER".localized()
    
    private lazy var nextButton: UIButton = {
        let button = UIButton()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold)
        let image = UIImage(systemName: "chevron.right", withConfiguration: imageConfig)
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.isHidden = false
        button.isEnabled = true
        button.backgroundColor = ServiceColor.primaryColor
        button.addTarget(self, action: #selector(self.nextButtonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var rightButton: UIBarButtonItem = {
        let buttonTitle: String
        if mode == .create {
            buttonTitle = "SKIP"
        } else {
            buttonTitle = "DONE"
        }
        let button = UIBarButtonItem(title: buttonTitle.localized(), style: .plain, target: self, action: #selector(rightButtonPressed(_:)))
        button.tintColor =  ServiceColor.primaryColor
//        button.isHidden = true
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "ABOUTME_TITLE".localized()
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 16, weight: UIFont.Weight.medium)
        label.numberOfLines = 0
        label.sizeToFit()
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureAboutMeTextView()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNav()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        aboutMeTextView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(200)
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
    
    private func configureNav() {
        self.navigationItem.title = "ABOUTME_NAVIGATIONITEM_TITLE".localized()
        self.navigationItem.backButtonTitle = "" // remove back button title
        self.navigationItem.rightBarButtonItem = rightButton
    }
    
    private func configureView() {
        [titleLabel,
         aboutMeTextView,
        nextButton].forEach { view.addSubview($0) }
        view.backgroundColor = .systemBackground
    }
    
    private func configureAboutMeTextView() {
        aboutMeTextView.myTextView.delegate = self
        aboutMeTextView.textCountLabel.text = "\(aboutMeTextView.myTextView.text.count) / \(textMax)"
        if aboutMeTextView.myTextView.text == nil || aboutMeTextView.myTextView.text == "" {
            aboutMeTextView.myTextView.text = placeholder
        } else {
            aboutMeTextView.myTextView.textColor = .label
        }
    }
    
    private func moveToIVC() {
        DispatchQueue.main.async(qos: .userInteractive) {
            let IVC = InterestsViewController()
            IVC.mode = self.mode
            IVC.userProfile = self.userProfile
            self.navigationController?.pushViewController(IVC, animated: true)
        }
    }
    
    private func aboutMeAlert() {
        let alert = UIAlertController(title: "", message: "ABOUTME_ALERT".localized(), preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "OK".localized(), style: .default)
        alert.addAction(okAction)
        DispatchQueue.main.async {
            self.present(alert, animated: false, completion: nil)
        }
    }
    
    @objc private func rightButtonPressed(_ sender: Any) {
        if mode == .create {
            moveToIVC()
        } else {
            if aboutMeTextView.myTextView.text != placeholder {
                delegate?.aboutMeSend(aboutMe: aboutMeTextView.myTextView.text)
            }
            DispatchQueue.main.async(qos: .userInteractive, execute: {
                self.navigationController?.popViewController(animated: true)
            })
        }
    }
    
    @objc private func nextButtonTapped(_ sender: UIButton) {
        
        if aboutMeTextView.myTextView.text == placeholder || aboutMeTextView.myTextView.text == nil || aboutMeTextView.myTextView.text == "" {
            aboutMeAlert()
        } else {
            userProfile.aboutMe = aboutMeTextView.myTextView.text
            moveToIVC()
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

extension AboutMeViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {

        // get the current text, or use an empty string if that failed
        let currentText = textView.text ?? ""

        // attempt to read the range they are trying to change, or exit if we can't
        guard let stringRange = Range(range, in: currentText) else { return false }

        // add their new text to the existing text
        let updatedText = currentText.replacingCharacters(in: stringRange, with: text)

        // make sure the result is under 16 characters
        return updatedText.count <= textMax
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == placeholder {
            textView.text = nil
            textView.textColor = .label
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = placeholder
            textView.textColor = .placeholderText
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        aboutMeTextView.textCountLabel.text = "\(textView.text.count) / \(textMax)"
        if aboutMeTextView.myTextView.text != placeholder {
            aboutMeTextView.textCountLabel.textColor = .label
        } else {
            aboutMeTextView.textCountLabel.textColor = .placeholderText
        }
    }
}
