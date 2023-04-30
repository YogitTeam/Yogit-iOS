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
import SkeletonView

class GetProfileViewController: UIViewController {
    // profile
    // profile image >> pagecontrol
    
    var getUserId: Int64? {
        didSet {
            leftButton.isHidden = false
        }
    }
    
//    private lazy var footerViews: [UIView] = {
//        let views = [UIView](repeating: UIView(), count: 4)
//        for view in views {
//            view.frame = CGRect(origin: .zero, size: CGSize(width: self.view.frame.size.width-40, height: 1))
//            view.backgroundColor = .red
//        }
//        return views
//    }()
    
    private var isBlockedUser: Int? {
        didSet {
            if isBlockedUser == 1 {
                isBlockedUserAlert()
            }
            guard let identifier = UserDefaults.standard.object(forKey: SessionManager.currentServiceTypeIdentifier) as? String, let userItem = try? KeychainManager.getUserItem(serviceType: identifier) else { return }
            if getUserId != userItem.userId {
                rightButton.isHidden = false
            }
        }
    }
    
    private var setUserProfile = UserProfile()
    
    private var profileImages = [String]()
    
    private var languagesInfo: String = ""
    
    private lazy var leftButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(leftButtonPressed(_:)))
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
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    private let footerView2: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    private let footerView3: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    private let footerView4: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var profileContentScrollView: UIScrollView = {
       let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.isScrollEnabled = true
        scrollView.showsVerticalScrollIndicator = true
        scrollView.addSubview(profileContentView)
        scrollView.isSkeletonable = true
        return scrollView
    }()
    
    private lazy var profileContentView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isSkeletonable = true
        [profileContentStackView].forEach { view.addSubview($0) }
        return view
    }()
    
    private lazy var profileImageStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .center
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.backgroundColor = .systemBackground
        stackView.isSkeletonable = true
        [profileImageView, profileNameCountryStackView].forEach { stackView.addArrangedSubview($0) }
        return stackView
    }()
    
    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        imageView.isSkeletonable = true
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
        stackView.isSkeletonable = true
        [profileNameLabel, profileCountyStackView].forEach { stackView.addArrangedSubview($0) }
        return stackView
    }()
    
    private let profileNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 18, weight: UIFont.Weight.medium)
        label.sizeToFit()
        label.numberOfLines = 1
        label.isSkeletonable = true
        return label
    }()
    
    private lazy var profileContentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 31
        stackView.alignment = .leading
        stackView.isSkeletonable = true
        [profileImageStackView,
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
        stackView.isSkeletonable = true
        [profileFlagLabel,
         profileCountyLabel].forEach { stackView.addArrangedSubview($0) }
        return stackView
    }()
    
    private let profileFlagLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 20)
        label.numberOfLines = 1
        label.sizeToFit()
        label.isSkeletonable = true
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
        label.isSkeletonable = true
        return label
    }()
    
    private lazy var profileLanguagesStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 6
        stackView.alignment = .leading
        stackView.backgroundColor = .systemBackground
        stackView.isSkeletonable = true
        [profileLanguagesTitleLabel,
         profileLanguagesLabel,
        footerView1].forEach { stackView.addArrangedSubview($0) }
        stackView.sizeToFit()
        return stackView
    }()
    
    private let profileLanguagesTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.text = ProfileSectionData.languages.toString()
        label.font = .systemFont(ofSize: 18, weight: UIFont.Weight.medium)
        label.numberOfLines = 1
        label.sizeToFit()
        label.isSkeletonable = true
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
        
        label.isSkeletonable = true
        return label
    }()
    
    private lazy var profileJobStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 6
        stackView.alignment = .leading
        stackView.backgroundColor = .systemBackground
        stackView.isSkeletonable = true
        [profileJobTitleLabel,
         profileJobLabel,
         footerView2].forEach { stackView.addArrangedSubview($0) }
        return stackView
    }()
    
    private let profileJobTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 18, weight: UIFont.Weight.medium)
        label.numberOfLines = 1
        label.sizeToFit()
        label.text = ProfileSectionData.job.toString()
        label.isSkeletonable = true
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
        label.isSkeletonable = true
        return label
    }()
    
    private lazy var profileAboutMeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 6
        stackView.alignment = .leading
        stackView.backgroundColor = .systemBackground
        stackView.isSkeletonable = true
        [profileAboutMeTitleLabel,
         profileAboutMeLabel,
         footerView3].forEach { stackView.addArrangedSubview($0) }
        return stackView
    }()
    
    private let profileAboutMeTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 18, weight: UIFont.Weight.medium)
        label.numberOfLines = 0
        label.sizeToFit()
        label.text = ProfileSectionData.aboutMe.toString()
        label.isSkeletonable = true
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
        label.isSkeletonable = true
        return label
    }()
    
    private lazy var profileInterestsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 6
        stackView.alignment = .leading
        stackView.backgroundColor = .systemBackground
        stackView.isSkeletonable = true
        [profileInterestsTitleLabel,
         profileInterestsTagView,
         footerView4].forEach { stackView.addArrangedSubview($0) }
        return stackView
    }()
    
    private let profileInterestsTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 18, weight: UIFont.Weight.medium)
        label.numberOfLines = 0
        label.sizeToFit()
        label.text = ProfileSectionData.interests.toString()
        label.isSkeletonable = true
        return label
    }()
    
    private let profileInterestsTagView: TTGTextTagCollectionView = {
        let view = TTGTextTagCollectionView()
        view.backgroundColor = UIColor.systemBackground
        view.scrollDirection = .horizontal
        view.alignment = .left
        view.horizontalSpacing = 12
        view.verticalSpacing = 12
        view.contentInset = UIEdgeInsets(top: 4, left: 0, bottom: 4, right: 0)
        view.showsHorizontalScrollIndicator = false
        view.isSkeletonable = true
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
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
        profileImageView.layoutIfNeeded()
        profileImageView.layer.cornerRadius = profileImageView.frame.size.width/2
        profileNameLabel.snp.makeConstraints {
            $0.trailing.equalTo(view).inset(20)
        }
        profileLanguagesStackView.snp.makeConstraints {
            $0.width.equalToSuperview()
        }
        profileLanguagesTitleLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
        }
        profileLanguagesLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
        }
        profileImageView.snp.makeConstraints { make in
            make.width.height.equalTo(100)
        }
        profileContentStackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(10)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(20)
        }
        footerView1.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo(30)
        }
        profileLanguagesStackView.layoutIfNeeded()
        profileLanguagesStackView.layer.addBorderWithMargin(arr_edge: [.top], marginLeft: 0, marginRight: 0, color: .systemGray6, width: 1, marginTop: 15)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initNavigationBar()
    }
    
    private func configureNavItem() {
        guard let identifier = UserDefaults.standard.object(forKey: SessionManager.currentServiceTypeIdentifier) as? String, let userItem = try? KeychainManager.getUserItem(serviceType: identifier) else { return }
        if getUserId == userItem.userId {
            self.navigationItem.title = "MY_PROFILE".localized()
        } else {
            self.navigationItem.title = "PROFILE".localized()
        }
        self.navigationItem.leftBarButtonItem = leftButton
        self.navigationItem.rightBarButtonItem = rightButton
    }

    private func configureView() {
        view.backgroundColor = .systemBackground
        view.addSubview(profileContentScrollView)
    }
    
    private func initProgressHUD() {
        ProgressHUD.colorAnimation = ServiceColor.primaryColor
        ProgressHUD.animationType = .circleStrokeSpin
    }
    
    private func initNavigationBar() {
        DispatchQueue.main.async { [weak self] in
            self?.tabBarController?.makeNaviTopLabel(title: TabBarKind.profile.rawValue.localized())
            self?.tabBarController?.navigationItem.rightBarButtonItems?.removeAll()
        }
        if getUserId == nil { // 상대방 조회 없을때
            let editButton = self.tabBarController?.makeNaviTopButton(self, action: #selector(self.editButtonTapped(_:)), named: "Edit")
            let settingButton = self.tabBarController?.makeNaviTopButton(self, action: #selector(self.settingButtonTapped(_:)), named: "SETTING")
            let spacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
            spacer.width = 15
            DispatchQueue.main.async { [weak self] in
                self?.tabBarController?.navigationItem.rightBarButtonItems = [settingButton!, spacer, editButton!]
            }
        }
    }
    
    @objc private func leftButtonPressed(_ sender: Any) {
        DispatchQueue.main.async {
            self.dismiss(animated: true)
        }
    }
    
    @objc private func rightButtonPressed(_ sender: Any) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cancel = UIAlertAction(title: "CANCEL".localized(), style: .cancel, handler: nil)
        if isBlockedUser != 1 {
            let block = UIAlertAction(title: "BLOCK".localized(), style: .destructive) { (action) in
                self.blockAlert()
            }
            alert.addAction(block)
        }
        let report = UIAlertAction(title: "REPORT".localized(), style: .destructive) {(action) in
            guard let reportedUserId = self.getUserId else { return }
            self.reportBoard(reportedUserId: reportedUserId)
        }
        alert.addAction(report)
        alert.addAction(cancel)
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    private func blockAlert() {
        let alert = UIAlertController(title: "BLOCK".localized(), message: "GET_PROFILE_BLOCK_ALERT_MESSAGE".localized(), preferredStyle: .alert)
        let cancel = UIAlertAction(title: "CANCEL".localized(), style: .cancel)
        let ok = UIAlertAction(title: "OK".localized(), style: .destructive) { (ok) in
            guard let userIdToBlock = self.getUserId else { return }
            self.blockUser(userIdToBlock: userIdToBlock)
        }
        alert.addAction(cancel)
        alert.addAction(ok)
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    private func deleteAlert() {
        let alert = UIAlertController(title: "GET_PROFILE_DELETED_USER_ALERT_TITLE".localized(), message: "GET_PROFILE_DELETED_USER_ALERT_MESSAGE".localized(), preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default) { (ok) in
            DispatchQueue.main.async {
                self.dismiss(animated: true)
            }
        }
        alert.addAction(ok)
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    private func isBlockedUserAlert() {
        let alert = UIAlertController(title: "GET_PROFILE_BLOCKED_USER_ALERT_TITLE".localized(), message: "GET_PROFILE_BLOCKED_USER_ALERT_MESSAGE".localized(), preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default)
        alert.addAction(ok)
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    private func blockUser(userIdToBlock: Int64) {
        guard let identifier = UserDefaults.standard.object(forKey: SessionManager.currentServiceTypeIdentifier) as? String, let userItem = try? KeychainManager.getUserItem(serviceType: identifier) else { return }
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
        DispatchQueue.main.async(qos: .userInteractive) {
            let SPVC = SetProfileViewController()
            SPVC.mode = .edit
            SPVC.userProfile = self.setUserProfile
            SPVC.userProfileImage = self.profileImages.first
            SPVC.delegate = self
            self.navigationController?.pushViewController(SPVC, animated: true)
        }
    }
    
    @objc private func settingButtonTapped(_ sender: UIButton) {
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
    
    private func configureStackView(stackView: UIStackView, footerView: UIView) {
        footerView.backgroundColor = .clear
        stackView.snp.makeConstraints {
            $0.width.equalToSuperview()
        }
        footerView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo(30)
        }
        stackView.layoutIfNeeded()
        stackView.layer.addBorderWithMargin(arr_edge: [.top], marginLeft: 0, marginRight: 0, color: .systemGray6, width: 1, marginTop: 15)
    }
    
    func sprayViewUserProfileData(data: FetchUserProfile) {
        bindingUserProfileData(data: data)
        let langCnt = data.languageCodes.count
        var langInfos: String = ""
        guard let localeIdentifier = Locale.preferredLanguages.first else { return }
        for i in 0..<langCnt {
            let code = data.languageCodes[i]
            let localizedLocale = Locale(identifier: localeIdentifier)
//            let originLocale = Locale(identifier: code)
            if let localizedLanguage = localizedLocale.localizedString(forIdentifier: code), let langLevelStr = LanguageLevels(rawValue: data.languageLevels[i])?.toString() {
                langInfos += "\(localizedLanguage)(\(langLevelStr))\n"
            }
        }
        if langInfos.count > 0 { // 원래 값 있어야함
            langInfos.removeLast()
        }
        
        DispatchQueue.main.async(qos: .userInteractive) { [self] in
            view.stopSkeletonAnimation()
            view.hideSkeleton()
            
            let attributedString = NSMutableAttributedString(string: langInfos)
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 4
            attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedString.length))

            profileLanguagesLabel.attributedText = attributedString
            profileImages = data.imageUrls
            profileImageView.setImage(with: data.profileImg)
            if let name = data.name, let age = data.age {
                profileNameLabel.text = "\(name) (\(age))"
            }
            if let code = data.nationality {
                let identifier = NSLocale.localeIdentifier(fromComponents: [NSLocale.Key.countryCode.rawValue: code])
                let countryName = NSLocale(localeIdentifier: localeIdentifier).displayName(forKey: NSLocale.Key.identifier, value: identifier) ?? "" // localize
                let flag = code.emojiFlag
                profileFlagLabel.text = flag
                profileCountyLabel.text = countryName
            }
        
            profileInterestsStackView.removeFromSuperview()
            profileAboutMeStackView.removeFromSuperview()
            profileJobStackView.removeFromSuperview()
            
            if let job = data.job, job != "" {
                profileJobLabel.text = job
                profileContentStackView.addArrangedSubview(profileJobStackView)
                configureStackView(stackView: profileJobStackView, footerView: footerView2)
            }
            if let aboutMe = data.aboutMe, aboutMe != "" {
                profileAboutMeLabel.text = aboutMe
                profileContentStackView.addArrangedSubview(profileAboutMeStackView)
                configureStackView(stackView: profileAboutMeStackView, footerView: footerView3)
            }
            if let interests = data.interests, interests != [] {
                setupTagView(tagView: profileInterestsTagView, interests: interests)
                profileContentStackView.addArrangedSubview(profileInterestsStackView)
                configureStackView(stackView: profileInterestsStackView, footerView: footerView4)
            }
            isBlockedUser = data.isBlockingUser
        }
    }
    
    private func setupTagView(tagView: TTGTextTagCollectionView, interests: [String]) {
        tagView.removeAllTags()
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
        tagView.reload()
        tagView.sizeToFit()
        
    }
    
    private func createFooterView() -> UIView {
        let footerView = UIView()
//        footerView.translatesAutoresizingMaskIntoConstraints = false
        footerView.backgroundColor = .red
        footerView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo(50)
        }
        footerView.layoutIfNeeded()
        return footerView
    }
    
//    private func constraintFooterView(footerView: UIView) {
//        footerView.snp.makeConstraints {
//            $0.width.equalToSuperview()
//            $0.height.equalTo(1)
//        }
//        footerView.layoutIfNeeded()
//    }
//
    private func getUserProfile() {
        guard let identifier = UserDefaults.standard.object(forKey: SessionManager.currentServiceTypeIdentifier) as? String, let userItem = try? KeychainManager.getUserItem(serviceType: identifier) else { return }
        let userId: Int64
        if let getUserId = getUserId {
            userId = getUserId
        } else {
            userId = userItem.userId
        }
        let getUserProfile = GetUserProfile(refreshToken: userItem.refresh_token, refreshTokenUserId: userItem.userId, userId: userId)
        let skeletonAnimation = SkeletonAnimationBuilder().makeSlidingAnimation(withDirection: .leftRight)
        profileContentScrollView.showAnimatedGradientSkeleton(usingGradient: .init(colors: [.systemGray6, .systemGray5]), animation: skeletonAnimation, transition: .none)
        AlamofireManager.shared.session
            .request(ProfileRouter.readProfile(parameters: getUserProfile))
            .validate(statusCode: 200..<501)
            .responseDecodable(of: APIResponse<FetchUserProfile>.self) { response in
                switch response.result {
                case .success:
                    if let value = response.value, (value.httpCode == 200 || value.httpCode == 201), let data = value.data {
                        if data.userStatus == "DELETE" {
                            print("탈퇴한 유저")
                            self.deleteAlert()
                        } else {
                            DispatchQueue.global(qos: .userInteractive).async { [weak self] in
                                self?.sprayViewUserProfileData(data: data)
                            }
                        }
                    }
                case let .failure(error):
                    print("GetProfileVC - upload response result Not return", error)
                }
            }
    }
    
    @objc func profileImageViewTapped(_ sender: UITapGestureRecognizer) {
        DispatchQueue.main.async {
            let GPIVC = GetProfileImagesViewController()
            GPIVC.profileImages = self.profileImages
            GPIVC.modalPresentationStyle = .fullScreen
            self.present(GPIVC, animated: true, completion: nil)
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

extension GetProfileViewController: FetchUserProfileProtocol {
    func sendFetchedUserProfile(data: FetchUserProfile) {
        DispatchQueue.global(qos: .userInteractive).async {
            self.sprayViewUserProfileData(data: data)
        }
    }
}
