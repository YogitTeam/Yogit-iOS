//
//  AboutMeViewController.swift
//  Yogit
//
//  Created by Junseo Park on 2023/01/20.
//

import UIKit

protocol AboutMeProtocol {
    func aboutMeSend(aboutMe: String)
}

class AboutMeViewController: UIViewController {
    
    var mode: Mode = .create {
        didSet {
            if mode == .edit {
                rightButton.isHidden = false
                nextButton.isHidden = true
            }
        }
    }
    
    var userProfile = UserProfile()
    
    var delegate: AboutMeProtocol?
    
    private let textMax = 300
    
    let aboutMeTextView = MyTextView()
    
    private let placeholder = "I am, I like, I do..."
    
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
        label.text = "👋 Let global friends know\nwho you are"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 22, weight: UIFont.Weight.semibold)
        label.numberOfLines = 0
        label.sizeToFit()
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        [titleLabel,
         aboutMeTextView,
        nextButton].forEach { view.addSubview($0) }
        aboutMeTextView.myTextView.delegate = self
        configureViewComponent()
        configureTextView()
        // Do any additional setup after loading the view.
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
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(0)
            $0.width.height.equalTo(60)
        }
        nextButton.layer.cornerRadius = nextButton.frame.size.width/2
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    private func configureViewComponent() {
        self.navigationItem.title = "About Me"
        self.view.backgroundColor = .systemBackground
        self.navigationItem.rightBarButtonItem = rightButton
    }
    
    private func configureTextView() {
        aboutMeTextView.textCountLabel.text = "\(aboutMeTextView.myTextView.text.count) / \(textMax)"
        if aboutMeTextView.myTextView.text == nil || aboutMeTextView.myTextView.text == "" {
            aboutMeTextView.myTextView.text = placeholder
        } else {
            aboutMeTextView.myTextView.textColor = .label
        }
    }
    
    @objc private func rightButtonPressed(_ sender: Any) {
        if aboutMeTextView.myTextView.text != placeholder {
            delegate?.aboutMeSend(aboutMe: aboutMeTextView.myTextView.text ?? "")
        }
        DispatchQueue.main.async(qos: .userInteractive, execute: {
            self.navigationController?.popViewController(animated: true)
        })
    }
    
    // API Call
    @objc func nextButtonTapped(_ sender: UIButton) {

        
        userProfile.aboutMe = aboutMeTextView.myTextView.text
        
        print("nextButtonTapped userPrfile data", userProfile)
        
        guard let userItem = try? KeychainManager.getUserItem() else { return }
        userProfile.userId = userItem.userId
        userProfile.refreshToken = userItem.refresh_token
        
        // 추가 정보 포함된 SearchUserProfile로 요청 때린다.
        // userProfile에  SearchUserProfile 모든 데이터 포함
        let urlRequestConvertible = ProfileRouter.uploadEssentialProfile(parameters: userProfile)
        if let parameters = urlRequestConvertible.toDictionary {
            AlamofireManager.shared.session.upload(multipartFormData: { multipartFormData in
                for (key, value) in parameters {
                    if let arrayValue = value as? [Any] {
                        for arrValue in arrayValue {
                            multipartFormData.append(Data("\(arrValue)".utf8), withName: key)
                        }
                    } else {
                        multipartFormData.append(Data("\(value)".utf8), withName: key)
                    }
                }
            }, with: urlRequestConvertible)
            .validate(statusCode: 200..<501)
            .responseDecodable(of: APIResponse<FetchUserProfile>.self) { response in
                switch response.result {
                case .success:
                    do {
                        guard let value = response.value else { return }
                        guard let data = value.data else { return }
                        if value.httpCode == 200 {
                            userItem.account.hasRequirementInfo = true // 유저 hasRequirementInfo 저장 (필수데이터 정보)
                            userItem.userName = data.name // 유저 이름, 상태 저장
                            try KeychainManager.updateUserItem(userItem: userItem)
                            let rootVC = UINavigationController(rootViewController: ServiceTapBarViewController())
                            DispatchQueue.main.async { [self] in
                                view.window?.rootViewController = rootVC
                                view.window?.makeKeyAndVisible()
                            }
                        }
                    } catch {
                        print("Error - KeychainManager.update \(error.localizedDescription)")
                    }
                case let .failure(error):
                    print("SetProfileVC - upload response result Not return", error)
                }
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

extension AboutMeViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        print(" shouldChangeTextIn",textView.tag)

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
        print("textViewDidBeginEditing",textView.tag)
        if textView.text == placeholder {
            textView.text = nil
            textView.textColor = .label
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        print("textViewDidEndEditing",textView.tag)
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = placeholder
            textView.textColor = .placeholderText
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        // textfield count
        // 개수 표시
//        let indexPath = IndexPath(row: 0, section: textView.tag)
//        guard let cell = textDetailTableView.cellForRow(at: indexPath) as?  MyTextViewTableViewCell else { return }
        
        print("textViewDidChange", textView.text.count)
        aboutMeTextView.textCountLabel.text = "\(textView.text.count) / \(textMax)"
        if aboutMeTextView.myTextView.text != placeholder {
            aboutMeTextView.textCountLabel.textColor = .label
        } else {
            aboutMeTextView.textCountLabel.textColor = .placeholderText
        }
    }
}
