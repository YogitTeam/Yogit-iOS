//
//  SearchProfileViewController.swift
//  Yogit
//
//  Created by Junseo Park on 2022/11/20.
//

import UIKit
import SnapKit
import ProgressHUD
import TTGTags

class GetProfileViewController: UIViewController {
    // profile
    // profile image >> pagecontrol
    
    var getUserId: Int64? {
        didSet {
            leftButton.isHidden = false
            rightButton.isHidden = false
        }
    }
    
    private var setUserProfile = UserProfile()
    
    private var profileImages = [String]()
    
    private var languagesInfo: String = ""
    
    private lazy var leftButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(named: "delete")?.withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(leftButtonPressed(_:)))
        button.tintColor = .label
        button.isHidden = true
        return button
    }()
    
    
    private lazy var rightButton: UIBarButtonItem = {
        let button =  UIBarButtonItem(image: UIImage(systemName: "ellipsis")?.withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(rightButtonPressed(_:)))
        button.tintColor = .label
        button.isHidden = true
        return button
    }()
    
    private let footerView1: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = true
        view.backgroundColor = .systemGray6
        return view
    }()
    
    private lazy var blockNotiView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = true
        view.backgroundColor = .systemRed
        view.addSubview(blockLabel)
        view.isHidden = true
        return view
    }()
    
    private let blockLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 14, weight: UIFont.Weight.medium)
        label.sizeToFit()
        label.numberOfLines = 1
        label.text = "The user is a blocked"
        return label
    }()
    
    private lazy var profileContentScrollView: UIScrollView = {
       let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.isScrollEnabled = true
        scrollView.addSubview(profileContentView)
        return scrollView
    }()
    
    private lazy var profileContentView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        [profileContentStackView, blockNotiView].forEach { view.addSubview($0) }
        return view
    }()
    
    private lazy var profileImageStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .center
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.backgroundColor = .systemBackground
        [profileImageView, profileNameCountryStackView].forEach { stackView.addArrangedSubview($0) }
        return stackView
    }()
    
    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .placeholderText
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.profileImageViewTapped(_:))))
        return imageView
    }()
    
    private lazy var profileNameCountryStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .leading
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.backgroundColor = .systemBackground
        [profileNameLabel, profileCountyStackView].forEach { stackView.addArrangedSubview($0) }
        return stackView
    }()
    
    private let profileNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 18, weight: UIFont.Weight.medium)
        label.sizeToFit()
//        label.text = "Select photos"
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var profileContentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.alignment = .leading
//        stackView.layer.borderWidth = 1
//        stackView.layer.borderColor = UIColor.red.cgColor
        [profileImageStackView,
         footerView1,
         profileLanguagesStackView].forEach { stackView.addArrangedSubview($0) }
        return stackView
    }()
    
    private lazy var profileCountyStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 6
        stackView.alignment = .center
        stackView.backgroundColor = .systemBackground
        [profileFlagLabel,
         profileCountyLabel].forEach { stackView.addArrangedSubview($0) }
        return stackView
    }()
    
    private let profileFlagLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 20)
//        label.textColor = .systemGray
        label.numberOfLines = 1
        label.sizeToFit()
        return label
    }()
    
    private let profileCountyLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 16, weight: UIFont.Weight.regular)
        label.textColor = .systemGray
        label.numberOfLines = 1
        label.sizeToFit()
        return label
    }()
    
    private lazy var profileLanguagesStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 6
        stackView.alignment = .leading
        stackView.backgroundColor = .systemBackground
        [profileLanguagesTitleLabel,
         profileLanguagesLabel].forEach { stackView.addArrangedSubview($0) }
        return stackView
    }()
    
    private let profileLanguagesTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.text = "Languages"
        label.font = .systemFont(ofSize: 20, weight: UIFont.Weight.medium)
//        label.textColor = .systemGray
        label.numberOfLines = 1
        label.sizeToFit()
        return label
    }()
    
    private let profileLanguagesLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.textColor = .systemGray
        label.font = .systemFont(ofSize: 16, weight: UIFont.Weight.regular)
        label.numberOfLines = 0
        label.sizeToFit()
        return label
    }()
    
    private lazy var profileJobStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 6
        stackView.alignment = .leading
        stackView.backgroundColor = .systemBackground
        [profileJobTitleLabel,
         profileJobLabel].forEach { stackView.addArrangedSubview($0) }
        return stackView
    }()
    
    private let profileJobTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 20, weight: UIFont.Weight.medium)
//        label.textColor = .systemGray
        label.numberOfLines = 1
        label.sizeToFit()
        return label
    }()
    
    private let profileJobLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 16, weight: UIFont.Weight.regular)
        label.textColor = .systemGray
        label.numberOfLines = 1
        label.sizeToFit()
        return label
    }()
    
    private lazy var profileAboutMeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 6
        stackView.alignment = .leading
        stackView.backgroundColor = .systemBackground
        [profileAboutMeTitleLabel,
         profileAboutMeLabel].forEach { stackView.addArrangedSubview($0) }
        return stackView
    }()
    
    private let profileAboutMeTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 20, weight: UIFont.Weight.medium)
//        label.textColor = .systemGray
        label.numberOfLines = 0
        label.sizeToFit()
        return label
    }()
    
    private let profileAboutMeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 16, weight: UIFont.Weight.regular)
        label.textColor = .systemGray
        label.numberOfLines = 0
        label.sizeToFit()
        return label
    }()
    
    private lazy var profileInterestsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 6
        stackView.alignment = .leading
        stackView.backgroundColor = .systemBackground
        [profileInterestsTitleLabel,
         profileInterestsTagView].forEach { stackView.addArrangedSubview($0) }
        return stackView
    }()

    
    private let profileInterestsTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 20, weight: UIFont.Weight.medium)
//        label.textColor = .systemGray
        label.numberOfLines = 0
        label.sizeToFit()
        return label
    }()
    
    private let profileInterestsTagView = TTGTextTagCollectionView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(profileContentScrollView)
        configureViewComponent()
        configureNavItem()
        initProgressHUD()
        getUserProfile()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        profileContentScrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        profileContentView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.centerX.bottom.top.equalToSuperview()
//            $0.top.equalTo(boardContentScrollView.bounds.minY)
        }
        profileImageView.snp.makeConstraints { make in
            make.width.height.equalTo(100)
        }
        footerView1.snp.makeConstraints {
            $0.width.equalTo(view.frame.width-40)
            $0.height.equalTo(1)
        }
        profileImageView.layoutIfNeeded()
        profileImageView.layer.cornerRadius = profileImageView.frame.size.width/2
//        profileImageStackView.snp.makeConstraints {
////            $0.centerX.equalToSuperview()
//            $0.top.equalToSuperview().inset(20)
//            $0.leading.trailing.equalToSuperview().inset(20)
//        }
//        profileLanguagesImageView.snp.makeConstraints {
//            $0.width.height.equalTo(20)
//        }
//        profileJobImageView.snp.makeConstraints {
//            $0.width.height.equalTo(20)
//        }
//        profileAboutMeImageView.snp.makeConstraints {
//            $0.width.height.equalTo(20)
//        }
        
        profileContentStackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(20)
        }
        
        blockLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.leading.trailing.equalTo(view).inset(20)
//            $0.top.bottom.equalToSuperview().inset(8)
//            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        blockNotiView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.top.bottom.equalTo(blockLabel).inset(-4)
            $0.leading.trailing.equalTo(blockLabel).inset(-20)
        }
        
//        profileLanguagesTitleLabel.layoutIfNeeded()
//        profileJobTitleLabel.layoutIfNeeded()
//        profileAboutMeTitleLabel.layoutIfNeeded()
//        profileLanguagesTitleLabel.layer.addBorderWithMargin(arr_edge: [.top], marginLeft: 0, marginRight: 0, color: .systemGray6, width: 1, marginTop: 10)
//
//        profileJobTitleLabel.layer.addBorderWithMargin(arr_edge: [.top], marginLeft: 0, marginRight: 0, color: .systemGray6, width: 1, marginTop: 10)
//
//        profileAboutMeTitleLabel.layer.addBorderWithMargin(arr_edge: [.top], marginLeft: 0, marginRight: 0, color: .systemGray6, width: 1, marginTop: 10)
        
//        footerView1.snp.makeConstraints {
//            $0.top.equalTo(profileImageStackView.snp.bottom).offset(20)
//            $0.leading.trailing.equalToSuperview()
//            $0.height.equalTo(6)
//        }
//        lanuageLabel.snp.makeConstraints { make in
//            make.top.equalTo(footerView1.snp.bottom).offset(20)
//            make.leading.trailing.equalToSuperview().inset(20)
//        }
//        profileLanguagesLabel.snp.makeConstraints { make in
//            make.top.equalTo(lanuageLabel.snp.bottom).offset(10)
//            make.leading.trailing.equalToSuperview().inset(20)
//        }
//        footerView2.snp.makeConstraints {
//            $0.top.equalTo(profileLanguagesLabel.snp.bottom).offset(20)
//            $0.leading.trailing.equalToSuperview()
//            $0.height.equalTo(6)
//        }
//        aboutMeLabel.snp.makeConstraints { make in
//            make.top.equalTo(footerView2.snp.bottom).offset(20)
//            make.leading.trailing.equalToSuperview().inset(20)
//        }
//        aboutMe.snp.makeConstraints { make in
//            make.top.equalTo(aboutMeLabel.snp.bottom).offset(10)
//            make.leading.trailing.equalToSuperview().inset(20)
//        }
//        profileContentView.snp.makeConstraints { make in
//            make.top.equalTo(view.safeAreaLayoutGuide)
////            make.bottom.equalToSuperview()
//            make.bottom.leading.trailing.equalToSuperview()
//        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        initNavigationBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.navigationItem.rightBarButtonItems?.removeAll()
    }
    
    private func configureNavItem() {
        if getUserId == nil {
            self.navigationItem.title = "Profile"
        } else {
            self.navigationItem.title = "My profile"
        }
        self.navigationItem.leftBarButtonItem = leftButton
        self.navigationItem.rightBarButtonItem = rightButton
    }

    private func configureViewComponent() {
        self.view.backgroundColor = .systemBackground
    }
    
    private func initProgressHUD() {
        ProgressHUD.colorAnimation = ServiceColor.primaryColor
        ProgressHUD.animationType = .circleStrokeSpin
    }
    
    private func initNavigationBar() {
        self.tabBarController?.makeNaviTopLabel(title: TabBarKind.profile.rawValue)
        if getUserId == nil { // 상대방 조회 없을때
            let editButton = self.tabBarController?.makeNaviTopButton(self, action: #selector(self.editButtonTapped(_:)), named: "Edit")
            let settingButton = self.tabBarController?.makeNaviTopButton(self, action: #selector(self.settingButtonTapped(_:)), named: "Setting")
            let spacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
            spacer.width = 15
            self.tabBarController?.navigationItem.rightBarButtonItems = [settingButton!, spacer, editButton!]
        }
    }
    
    @objc private func leftButtonPressed(_ sender: Any) {
        DispatchQueue.main.async {
            self.dismiss(animated: true)
        }
    }
    
    @objc private func rightButtonPressed(_ sender: Any) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
//        alert.view.tintColor = UIColor.label
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let block = UIAlertAction(title: "Block", style: .destructive) { (action) in
            self.blockAlert()
        }
        let report = UIAlertAction(title: "Report", style: .destructive) {(action) in
            guard let reportedUserId = self.getUserId else { return }
            self.reportBoard(reportedUserId: reportedUserId)
        }
        alert.addAction(block)
        alert.addAction(report)
        alert.addAction(cancel)
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    private func blockAlert() {
        let alert = UIAlertController(title: "Block", message: "Are you sure to block this user?\n\nYou can't change it after blocking it, so please use it carefully.\n\nIf you block a user, the gathering posts and clipboards created by those users will become invisible.", preferredStyle: .alert) 
        let cancel = UIAlertAction(title: "cancel", style: .cancel)
        let ok = UIAlertAction(title: "OK", style: .destructive) { (ok) in
            guard let userIdToBlock = self.getUserId else { return }
            self.blockUser(userIdToBlock: userIdToBlock)
        }
        alert.addAction(cancel)
        alert.addAction(ok)
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    private func blockUser(userIdToBlock: Int64) {
        guard let userItem = try? KeychainManager.getUserItem() else { return }
        let userBlockReq  = UserBlockReq(blockedUserID: userIdToBlock, blockingUserID: userItem.userId, refreshToken: userItem.refresh_token)
        ProgressHUD.show(interaction: false)
        AlamofireManager.shared.session
            .request(BlockRouter.blockUser(parameters: userBlockReq))
            .validate(statusCode: 200..<501)
            .responseDecodable(of: APIResponse<UserBlockRes>.self) { response in
            switch response.result {
            case .success:
                if let value = response.value, (value.httpCode == 200 || value.httpCode == 201) {
                    DispatchQueue.main.async {
                        self.dismiss(animated: true) // 프로필 화면
                    }
                }
            case let .failure(error):
                print(error)
            }
            DispatchQueue.main.async {
                ProgressHUD.dismiss()
            }
        }
    }
    
    private func reportBoard(reportedUserId: Int64) {
        DispatchQueue.main.async(qos: .userInteractive) {
            let RVC = ReportViewController()
            RVC.reportedUserId = reportedUserId
            RVC.reportKind = .userReport
            let NC = UINavigationController(rootViewController: RVC)
            NC.modalPresentationStyle = .fullScreen
            self.present(NC, animated: true, completion: nil)
        }
    }
    
    @objc private func editButtonTapped(_ sender: UIButton) {
        print("editButtonTapped")
        DispatchQueue.main.async(qos: .userInteractive, execute: {
            let SPVC = SetProfileViewController()
            SPVC.mode = .edit
            SPVC.userProfile = self.setUserProfile
            SPVC.userProfileImage = self.profileImages.first
            SPVC.delegate = self
            self.navigationController?.pushViewController(SPVC, animated: true)
        })
    }
    
    @objc private func settingButtonTapped(_ sender: UIButton) {
        print("settingButtonTapped")
        DispatchQueue.main.async {
            let SPVC = SettingProfileViewController()
            self.navigationController?.pushViewController(SPVC, animated: true)
        }
    }
    
    func bindingUserProfileData(data: FetchUserProfile) {
        self.setUserProfile.userName = data.name
        self.setUserProfile.nationality = data.nationality
        self.setUserProfile.userAge = data.age
        self.setUserProfile.gender = data.gender
        self.setUserProfile.languageCodes = data.languageCodes
        self.setUserProfile.languageLevels = data.languageLevels
        self.setUserProfile.job = data.job
        self.setUserProfile.aboutMe = data.aboutMe
        self.setUserProfile.interests = data.interests
    }
    
    func sprayViewUserProfileData(data: FetchUserProfile) {
        bindingUserProfileData(data: data)
        let langCnt = data.languageCodes.count
        var langInfos: String = ""
        guard let localeIdentifier = Locale.preferredLanguages.first else { return }
        for i in 0..<langCnt {
            let code = data.languageCodes[i]
            let localizedLocale = Locale(identifier: localeIdentifier)
            let originLocale = Locale(identifier: code)
            if let localizedLanguage = localizedLocale.localizedString(forIdentifier: code) {
                langInfos += "\(localizedLanguage), "
            }
        }
        if langInfos.count > 0 { // 원래 값 있어야함
            langInfos.removeLast(2)
        }
        DispatchQueue.main.async(qos: .userInteractive, execute: { [self] in
            profileImages = data.imageUrls
            profileImageView.setImage(with: data.profileImg)
            profileNameLabel.text = "\(data.name) (\(data.age))"
            let code = data.nationality
            let identifier = NSLocale.localeIdentifier(fromComponents: [NSLocale.Key.countryCode.rawValue: code])
            let countryName = NSLocale(localeIdentifier: localeIdentifier).displayName(forKey: NSLocale.Key.identifier, value: identifier) ?? "" // localize
            let flag = code.emojiFlag
            profileFlagLabel.text = flag
            profileCountyLabel.text = countryName
            profileLanguagesLabel.text = langInfos
        
            if let job = data.job, job != "" {
                profileJobTitleLabel.text = "What I do"
                profileJobLabel.text = job
                let footerView = createFooterView()
                footerViewConstraint(footerView: footerView)
                profileContentStackView.addArrangedSubview(footerView)
                profileContentStackView.addArrangedSubview(profileJobStackView)
            }
            if let aboutMe = data.aboutMe, aboutMe != "" {
                profileAboutMeTitleLabel.text = "About Me"
                profileAboutMeLabel.text = aboutMe
                let footerView = createFooterView()
                footerViewConstraint(footerView: footerView)
                profileContentStackView.addArrangedSubview(footerView)
                profileContentStackView.addArrangedSubview(profileAboutMeStackView)
            }
            if let interests = data.interests, interests != [] {
                let footerView = createFooterView()
                footerViewConstraint(footerView: footerView)
                profileContentStackView.addArrangedSubview(footerView)
                profileContentStackView.addArrangedSubview(profileInterestsStackView)
                profileInterestsTitleLabel.text = "Personality & Interests"
                setupTagView(tagView: profileInterestsTagView, interests: interests)
            }
            
            if data.isBlockingUser == 0 {
                blockNotiView.isHidden = true
            } else {
                blockNotiView.isHidden = false
            }
        })
    }
    
    private func setupTagView(tagView: TTGTextTagCollectionView, interests: [String]) {
        print("setUpTagView")
        tagView.backgroundColor = UIColor.systemBackground
        tagView.scrollDirection = .horizontal
        tagView.alignment = .left
        tagView.showsHorizontalScrollIndicator = false
//        tagView.delegate = self
        
        let n = interests.count/3
        let m = interests.count%3 != 0 ? 1 : 0
        let linesNum: UInt = UInt(n + m)
        tagView.numberOfLines = linesNum
        for text in interests {
            let content = TTGTextTagStringContent.init(text: text)
            content.textColor = UIColor.systemGray//UIColor.black
            content.textFont = UIFont.systemFont(ofSize: 17, weight: .regular)//boldSystemFont(ofSize: 20)
            
            let normalStyle = TTGTextTagStyle.init()
            normalStyle.backgroundColor = UIColor.systemGray6
            normalStyle.borderWidth = 2
            normalStyle.borderColor = .systemGray6
            normalStyle.extraSpace = CGSize.init(width: 16, height: 8)
            normalStyle.cornerRadius = 8
            normalStyle.shadowColor = .clear

            let tag = TTGTextTag.init()
            tag.content = content
            tag.style = normalStyle
            
            tagView.addTag(tag)
        }
        
        tagView.horizontalSpacing = 12
        tagView.verticalSpacing = 12

        tagView.contentInset = UIEdgeInsets(top: 4, left: 0, bottom: 4, right: 0)
        tagView.reload()
        tagView.sizeToFit()
        
    }
    
    private func createFooterView() -> UIView {
        let footerView = UIView()
        footerView.translatesAutoresizingMaskIntoConstraints = false
        footerView.backgroundColor = .systemGray6
        return footerView
    }
    
    private func footerViewConstraint(footerView: UIView) {
        footerView.snp.makeConstraints {
            $0.width.equalTo(view.frame.width-40)
            $0.height.equalTo(1)
        }
    }
    
    private func getUserProfile() {
        guard let userItem = try? KeychainManager.getUserItem() else { return }
        let userId: Int64
        if let getUserId = getUserId {
            userId = getUserId
        } else {
            userId = userItem.userId
        }
        let getUserProfile = GetUserProfile(refreshToken: userItem.refresh_token, refreshTokenUserId: userItem.userId, userId: userId)
        print("refeshUserId, searchUserId", userItem.userId, userId)
        AlamofireManager.shared.session
            .request(ProfileRouter.readProfile(parameters: getUserProfile))
            .validate(statusCode: 200..<501)
            .responseDecodable(of: APIResponse<FetchUserProfile>.self) { response in
                switch response.result {
                case .success:
                    guard let value = response.value else { return }
                    if value.httpCode == 200 {
                        guard let data = value.data else { return }
                        DispatchQueue.global(qos: .userInteractive).async {
                            self.sprayViewUserProfileData(data: data)
//                            let langCnt = data.languageCodes.count
//                            var langInfos: String = ""
//                            guard let localeIdentifier = Locale.preferredLanguages.first else { return }
//                            for i in 0..<langCnt {
//                                let code = data.languageCodes[i]
//                                let localizedLocale = Locale(identifier: localeIdentifier)
//                                let originLocale = Locale(identifier: code)
//                                if let localizedLanguage = localizedLocale.localizedString(forIdentifier: code), let originLanguage = originLocale.localizedString(forIdentifier: code) {
//                                    if localizedLanguage == originLanguage {
//                                        langInfos += "\(localizedLanguage), "
//                                    } else {
//                                        langInfos += "\(localizedLanguage) (\(originLanguage)), "
//                                    }
//                                }
//                            }
////                            langInfos.removeLast(2)
//
//                                // 국가
////                            let code = data.nationality
////                            let identifier = NSLocale.localeIdentifier(fromComponents: [NSLocale.Key.countryCode.rawValue: code])
////                            let countryName = NSLocale(localeIdentifier: localeIdentifier).displayName(forKey: NSLocale.Key.identifier, value: identifier) ?? "" // localize
////                            let flag = code.emojiFlag
//                            // 노출될 값 flag + " " + countryName
//
//                            DispatchQueue.main.async(qos: .userInteractive, execute: { [self] in
//                                profileImageView.setImage(with: data.profileImg)
//                                profileImageLabel.text = data.name
//                                profileLanguagesLabel.text = langInfos
//                                profileImages = data.imageUrls
//                            })
//
//                            self.sendFetchedUserProfile(data: data)
////                            self.setUserProfile.userName = data.name
////                            self.setUserProfile.nationality = data.nationality
////                            self.setUserProfile.userAge = data.age
////                            self.setUserProfile.gender = data.gender
////                            self.setUserProfile.languageCodes = data.languageCodes
////                            self.setUserProfile.languageLevels = data.languageLevels
////                            self.setUserProfile.job = data.job
////                            self.setUserProfile.aboutMe = data.aboutMe
                        }
                    }
                case let .failure(error):
                    print("GetProfileVC - upload response result Not return", error)
                }
            }
    }
    
//    @objc func rightButtonPressed(_ sender: Any) {
////        navigationController.push
//
//
////        guard let userItem = try? KeychainManager.getUserItem() else { return }
////        userProfile.userId = userItem.userId
////        print(userProfile)
////
////
////
////        DispatchQueue.main.async {
////            let
////            self.navigationController?.pushViewController(<#T##viewController: UIViewController##UIViewController#>, animated: <#T##Bool#>)
////        }
//    }
    
    @objc func profileImageViewTapped(_ sender: UITapGestureRecognizer) {
        DispatchQueue.main.async(execute: {
            let GPIVC = GetProfileImagesViewController()
            GPIVC.profileImages = self.profileImages
            GPIVC.modalPresentationStyle = .fullScreen
//            let NC = UINavigationController(rootViewController: GPIVC)
//            NC.modalPresentationStyle = .fullScreen
            self.present(GPIVC, animated: true, completion: nil)
        })
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

extension GetProfileViewController: FetchUserProfileProtocol {
    func sendFetchedUserProfile(data: FetchUserProfile) {
        print("프로필 델리게이트 전달")
        DispatchQueue.global(qos: .userInteractive).async {
            self.sprayViewUserProfileData(data: data)
        }
    }
}
