//
//  TermsOfServiceViewController.swift
//  Yogit
//
//  Created by Junseo Park on 2023/03/31.
//

import UIKit
import SnapKit
import ProgressHUD

class TermsOfServiceViewController: UIViewController {
    
    var userProfile = UserProfile()
    
    private var isPassSelectdButton: Bool {
        if termOfUseButton.isSelected && personalInfoButton.isSelected {
            return true
        } else {
            return false
        }
    }
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "TERMS_OF_SERVICE_TITLE".localized()
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 22, weight: UIFont.Weight.semibold)
        label.numberOfLines = 0
        label.sizeToFit()
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private let subTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "TERMS_OF_SERVICE_SUBTITLE".localized()
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 17, weight: UIFont.Weight.regular)
        label.numberOfLines = 0
        label.sizeToFit()
        label.textColor = .systemGray
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private let totalButtonLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.regular)
        label.text = "TERMS_OF_SERVICE_CONSENT_TOTAL".localized()
        label.numberOfLines = 0
        label.sizeToFit()
        return label
    }()
    
    private lazy var totalButton: UIButton = {
        let button = UIButton()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .regular)
        let imageNormal = UIImage(systemName: "checkmark.circle", withConfiguration: imageConfig)?.withTintColor(.placeholderText, renderingMode: .alwaysOriginal)
        let imageSelect = UIImage(systemName: "checkmark.circle.fill", withConfiguration: imageConfig)?.withTintColor(ServiceColor.primaryColor, renderingMode: .alwaysOriginal)
        button.setImage(imageNormal, for: .normal)
        button.setImage(imageSelect, for: .selected)
        button.isHidden = false
        button.isEnabled = true
        button.setTitleColor(.label, for: .normal)
        button.addTarget(self, action: #selector(self.totalButtonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var termOfUseButtonLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.isUserInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(labelTapped(_:)))
        label.addGestureRecognizer(tapGestureRecognizer)
        label.numberOfLines = 0
        label.sizeToFit()
        return label
    }()
    
    private lazy var termOfUseButton: UIButton = {
        let button = UIButton()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .regular)
        let imageNormal = UIImage(systemName: "checkmark.circle", withConfiguration: imageConfig)?.withTintColor(.placeholderText, renderingMode: .alwaysOriginal)
        let imageSelect = UIImage(systemName: "checkmark.circle.fill", withConfiguration: imageConfig)?.withTintColor(ServiceColor.primaryColor, renderingMode: .alwaysOriginal)
        button.setImage(imageNormal, for: .normal)
        button.setImage(imageSelect, for: .selected)
        button.isHidden = false
        button.isEnabled = true
        button.setTitleColor(.label, for: .normal)
        button.addTarget(self, action: #selector(self.termOfUseButtonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var personalInfoButtonLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.isUserInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(labelTapped(_:)))
        label.addGestureRecognizer(tapGestureRecognizer)
        label.numberOfLines = 0
        label.sizeToFit()
        return label
    }()
    
    
    private lazy var personalInfoButton: UIButton = {
        let button = UIButton()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .regular)
        let imageNormal = UIImage(systemName: "checkmark.circle", withConfiguration: imageConfig)?.withTintColor(.placeholderText, renderingMode: .alwaysOriginal)
        let imageSelect = UIImage(systemName: "checkmark.circle.fill", withConfiguration: imageConfig)?.withTintColor(ServiceColor.primaryColor, renderingMode: .alwaysOriginal)
        button.setImage(imageNormal, for: .normal)
        button.setImage(imageSelect, for: .selected)
        button.setTitleColor(.label, for: .normal)
        button.isHidden = false
        button.isEnabled = true
        button.addTarget(self, action: #selector(self.personalInfoTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var rightButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "DONE".localized(), style: .plain, target: self, action: #selector(rightButtonPressed(_:)))
        button.tintColor = ServiceColor.primaryColor
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureLabel(label: termOfUseButtonLabel, text: "TERMS_OF_SERVICE_CONSENT_TERMOFSERVICE".localized(), hyperText: "Term of Service".localized())
        configureLabel(label: personalInfoButtonLabel, text: "TERMS_OF_SERVICE_CONSENT_PRIVACY_POLICY".localized(), hyperText: "Privacy Policy".localized())
        initProgressHUD()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNav()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        titleLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        subTitleLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.top.equalTo(titleLabel.snp.bottom).offset(6)
        }
        totalButton.snp.makeConstraints {
            $0.top.equalTo(subTitleLabel.snp.bottom).offset(10)
            $0.leading.equalToSuperview().inset(10)
            $0.width.height.equalTo(44)
        }
        totalButtonLabel.snp.makeConstraints {
            $0.top.equalTo(totalButton.snp.top).offset(10)
            $0.leading.equalTo(totalButton.snp.trailing)
            $0.trailing.equalToSuperview().inset(20)
        }
        termOfUseButton.snp.makeConstraints {
            $0.top.equalTo(totalButtonLabel.snp.bottom).offset(10)
            $0.leading.equalToSuperview().inset(10)
            $0.width.height.equalTo(44)
        }
        termOfUseButtonLabel.snp.makeConstraints {
            $0.top.equalTo(termOfUseButton.snp.top).offset(10)
            $0.leading.equalTo(termOfUseButton.snp.trailing)
            $0.trailing.equalToSuperview().inset(20)
        }
        personalInfoButton.snp.makeConstraints {
            $0.top.equalTo(termOfUseButtonLabel.snp.bottom).offset(10)
            $0.leading.equalToSuperview().inset(10)
            $0.width.height.equalTo(44)
        }
        personalInfoButtonLabel.snp.makeConstraints {
            $0.top.equalTo(personalInfoButton.snp.top).offset(10)
            $0.leading.equalTo(personalInfoButton.snp.trailing)
            $0.trailing.equalToSuperview().inset(20)
        }
    }
    
    private func configureNav() {
        navigationItem.title = ""
        navigationItem.backButtonTitle = "" // remove back button title
        navigationItem.rightBarButtonItem = rightButton
    }
    
    private func configureView() {
        [titleLabel,
         subTitleLabel,
        totalButton,
        totalButtonLabel,
        termOfUseButton,
        termOfUseButtonLabel,
        personalInfoButton,
        personalInfoButtonLabel].forEach { view.addSubview($0) }
        view.backgroundColor = .systemBackground
    }
    
    private func initProgressHUD() {
        ProgressHUD.colorAnimation = ServiceColor.primaryColor
        ProgressHUD.animationType = .circleStrokeSpin
    }
    
    private func configureLabel(label: UILabel, text: String, hyperText: String) {
       
        let generalText = String(
        format: "\(text) %@",
        hyperText
        ) // , 텍스트 추가 가능

        let italicFont = UIFont.italicSystemFont(ofSize: 17)
        let systemFont = UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.regular)

        let labelColor = UIColor.label
        let systemGray = UIColor.systemGray

        // NSAttributedString.Key, Value 속성 정의
        let generalAttributes: [NSAttributedString.Key: Any] = [
        .foregroundColor: labelColor,
        .font: systemFont
        ]
        let linkAttributes: [NSAttributedString.Key: Any] = [
        .underlineStyle: NSUnderlineStyle.single.rawValue,
        .foregroundColor: systemGray,
        .font: italicFont
        ]

        let mutableString = NSMutableAttributedString()

        // generalAttributes(기본 스타일) 적용
        mutableString.append(
        NSAttributedString(string: generalText, attributes: generalAttributes)
        )

        // 각 문자열의 range에 linkAttributes 적용
        mutableString.setAttributes(
        linkAttributes,
        range: (generalText as NSString).range(of: hyperText)
        )
        
        label.attributedText = mutableString
    }
    
    private func registerProfile() {
        guard let identifier = UserDefaults.standard.object(forKey: SessionManager.currentServiceTypeIdentifier) as? String, let userItem = try? KeychainManager.getUserItem(serviceType: identifier) else { return }
        
        ProgressHUD.show(interaction: false)
        
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
                        if value.httpCode == 200 || value.httpCode == 201 {
                            userItem.account.hasRequirementInfo = true // 유저 hasRequirementInfo 저장 (필수데이터 정보)
                            userItem.userName = data.name // 유저 이름, 상태 저장
                            try KeychainManager.updateUserItem(userItem: userItem)
                            DispatchQueue.main.async { [self] in
                                let rootVC = UINavigationController(rootViewController: ServiceTabBarViewController())
                                navigationController?.popToRootViewController(animated: false)
                                view.window?.rootViewController = rootVC
                                view.window?.makeKeyAndVisible()
                                ProgressHUD.dismiss()
                            }
                        }
                    } catch {
                        print("Error - KeychainManager.update \(error.localizedDescription)")
                    }
                case let .failure(error):
                    print("SetProfileVC - upload response result Not return", error)
                    DispatchQueue.main.async {
                        ProgressHUD.dismiss()
                    }
                }
            }
        }
    }
    
    private func isMissingData() {
        let alert = UIAlertController(title: "", message: "TERMS_OF_SERVICE_MISSING_DATA".localized(), preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "OK".localized(), style: .default)
        alert.addAction(okAction)
        DispatchQueue.main.async {
            self.present(alert, animated: false, completion: nil)
        }
    }
    
    @objc private func labelTapped(_ sender: UITapGestureRecognizer) {
        // Label에서 UITapGestureRecognizer로 선택된 부분의 CGPoint를 구함
        guard let label = sender.view as? UILabel else { return }
        let point = sender.location(in: label)
        
        // Label 내에서 문자열 google이 차지하는 CGRect값을 구해, 그 안에 point가 포함되는지를 판단
        if let googleRect = label.boundingRectForCharacterRange(subText: "Term of Service".localized()), googleRect.contains(point) {
            present(url: "https://yogit.notion.site/Terms-of-Service-d24fb011f98345729c53d27fd4ad8da1")
        }
        if let githubRect = label.boundingRectForCharacterRange(subText: "Privacy Policy".localized()),
                            githubRect.contains(point) {
            present(url: "https://yogit.notion.site/Privacy-Policy-635806ced6884d90985ba3cb13a39e64")
        }
    }

    func present(url string: String) {
        guard let url = URL(string: string) else { return }
        UIApplication.shared.open(url)
    }
    
    @objc private func rightButtonPressed(_ sender: Any) {
        if isPassSelectdButton {
            registerProfile()
        } else {
            isMissingData()
        }
    }
    
    @objc private func totalButtonTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        termOfUseButton.isSelected = sender.isSelected
        personalInfoButton.isSelected = sender.isSelected
    }

    @objc private func termOfUseButtonTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if !sender.isSelected { totalButton.isSelected = sender.isSelected }
    }
    
    @objc private func personalInfoTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if !sender.isSelected { totalButton.isSelected = sender.isSelected }
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

extension UILabel {
    /// 라벨 내 특정 문자열의 CGRect 반환
    /// - Parameter subText: CGRect값을 알고 싶은 특정 문자열
    func boundingRectForCharacterRange(subText: String) -> CGRect? {
        guard let attributedText = attributedText else { return nil }
        guard let text = self.text else { return nil }

        // 전체 텍스트(text)에서 subText만큼의 range를 구합니다.
        guard let subRange = text.range(of: subText) else { return nil }
        let range = NSRange(subRange, in: text)

        // attributedText를 기반으로 한 NSTextStorage를 선언하고 NSLayoutManager를 추가합니다.
        let layoutManager = NSLayoutManager()
        let textStorage = NSTextStorage(attributedString: attributedText)
        textStorage.addLayoutManager(layoutManager)

        // instrinsicContentSize를 기반으로 NSTextContainer를 선언하고
        let textContainer = NSTextContainer(size: intrinsicContentSize)
        // 정확한 CGRect를 구해야하므로 padding 값은 0을 줍니다.
        textContainer.lineFragmentPadding = 0.0
        // layoutManager에 추가합니다.
        layoutManager.addTextContainer(textContainer)

        var glyphRange = NSRange()
        // 주어진 범위(rage)에 대한 실질적인 glyphRange를 구합니다.
        layoutManager.characterRange(
            forGlyphRange: range,
            actualGlyphRange: &glyphRange
        )

        // textContainer 내의 지정된 glyphRange에 대한 CGRect 값을 반환합니다.
        return layoutManager.boundingRect(
            forGlyphRange: glyphRange,
            in: textContainer
        )
    }
}
