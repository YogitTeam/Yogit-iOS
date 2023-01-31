//
//  SearchProfileViewController.swift
//  Yogit
//
//  Created by Junseo Park on 2022/11/20.
//

import UIKit
import SnapKit
import Alamofire

class ReadProfileViewController: UIViewController {
    // profile
    // profile image >> pagecontrol
    
    var readUserId: Int64?
    
    private var essentialProfile = UserProfile()
    
    private var profileImages = [String]()
    
    private var languagesInfo: String = ""
    
    private let lanuageLabel: UILabel = {
        let label = UILabel()
        label.text = "Languages"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 20, weight: UIFont.Weight.semibold)
        label.numberOfLines = 1
        label.sizeToFit()
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private let profileLanguagesLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.textColor = .systemGray
        label.font = .systemFont(ofSize: 16, weight: UIFont.Weight.medium)
        label.sizeToFit()
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 0
        return label
    }()
    
    private let aboutMeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "About Me"
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 20, weight: UIFont.Weight.semibold)
        label.numberOfLines = 1
        label.sizeToFit()
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private let aboutMe: UILabel = {
        let label = UILabel()
        label.text = "I love global friends\nI am also studying English conversation\nI am attending Sejong University."
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 16, weight: UIFont.Weight.medium)
        label.textColor = .systemGray
        label.numberOfLines = 0
        label.sizeToFit()
        return label
    }()
    
    private let footerView1: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(rgb: 0xF5F5F5, alpha: 1.0)
        return view
    }()

    private let footerView2: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(rgb: 0xF5F5F5, alpha: 1.0)
        return view
    }()

    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .placeholderText
        imageView.layer.cornerRadius = 55
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.profileImageViewTapped(_:))))
        return imageView
    }()
    
    private let profileImageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 22, weight: UIFont.Weight.medium)
//        label.text = "Select photos"
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var profileImageStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .center
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.backgroundColor = .systemBackground
        [profileImageView, profileImageLabel].forEach { stackView.addArrangedSubview($0) }
        return stackView
    }()
    
    private lazy var profileContentView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.addSubview(profileImageStackView)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        [profileContentView,
         footerView1,
         lanuageLabel,
         profileLanguagesLabel,
         footerView2,
         aboutMeLabel,
         aboutMe].forEach { view.addSubview($0) }
        configureViewComponent()
        getUserProfile()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        profileImageView.snp.makeConstraints { make in
            make.width.height.equalTo(110)
        }
        profileImageLabel.snp.makeConstraints { make in
            make.width.equalTo(110)
            make.height.equalTo(20)
        }
        profileImageStackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(profileContentView).inset(20)
        }
        footerView1.snp.makeConstraints {
            $0.top.equalTo(profileImageStackView.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(6)
        }
        lanuageLabel.snp.makeConstraints { make in
            make.top.equalTo(footerView1.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        profileLanguagesLabel.snp.makeConstraints { make in
            make.top.equalTo(lanuageLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        footerView2.snp.makeConstraints {
            $0.top.equalTo(profileLanguagesLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(6)
        }
        aboutMeLabel.snp.makeConstraints { make in
            make.top.equalTo(footerView2.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        aboutMe.snp.makeConstraints { make in
            make.top.equalTo(aboutMeLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        profileContentView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
//            make.bottom.equalToSuperview()
            make.bottom.leading.trailing.equalToSuperview()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        initNavigationBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.navigationItem.rightBarButtonItems?.removeAll()
    }
    

    private func configureViewComponent() {
        self.view.backgroundColor = .systemBackground
    }
    
    private func initNavigationBar() {
        self.tabBarController?.makeNaviTopLabel(title: TabBarKind.profile.rawValue)
        let editButton = self.tabBarController?.makeNaviTopButton(self, action: #selector(self.editButtonTapped(_:)), named: "Edit")
        let settingButton = self.tabBarController?.makeNaviTopButton(self, action: #selector(self.settingButtonTapped(_:)), named: "Setting")
        let spacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        spacer.width = 15
        self.tabBarController?.navigationItem.rightBarButtonItems = [settingButton!, spacer, editButton!]
    }
    
    @objc private func editButtonTapped(_ sender: UIButton) {
        print("editButtonTapped")
//        DispatchQueue.main.async {
//            let SPVC = SetProfileViewController()
//            SPVC.userProfile = self.essentialProfile
//            SPVC.profileImage = self.profileImageView.image
//            self.navigationController?.pushViewController(SPVC, animated: true)
//        }
    }
    
    @objc private func settingButtonTapped(_ sender: UIButton) {
        print("settingButtonTapped")
        DispatchQueue.main.async {
            let SPVC = SettingProfileViewController()
            self.navigationController?.pushViewController(SPVC, animated: true)
        }
    }
    
    private func getUserProfile() {
        guard let userItem = try? KeychainManager.getUserItem() else { return }
        let userId: Int64
        if let readUserId = readUserId {
            userId = readUserId
        } else {
            userId = userItem.userId
        }
        let getUserProfile = GetUserProfile(refreshToken: userItem.refresh_token, refreshTokenUserId: userItem.userId, userId: userId)
        print("refeshUserId, searchUserId", userItem.userId, userId)
        AlamofireManager.shared.session
            .request(ProfileRouter.readProfile(parameters: getUserProfile))
            .validate(statusCode: 200..<501)
            .responseDecodable(of: APIResponse<SearchUserProfile>.self) { response in
                switch response.result {
                case .success:
                    guard let value = response.value else { return }
                    if value.httpCode == 200 {
                        guard let data = value.data else { return }
                        DispatchQueue.global(qos: .userInitiated).async {
                            let langCnt = data.languageNames.count
                            var langInfos: String = ""
                            for i in 0..<langCnt {
                                langInfos += "\(data.languageNames[i]) (\(data.languageLevels[i])), "
                            }
                            langInfos.removeLast()
                            langInfos.removeLast()
                            DispatchQueue.main.async(qos: .userInteractive, execute: { [self] in
                                profileImageView.setImage(with: data.profileImg)
                                profileImageLabel.text = data.name
                                profileLanguagesLabel.text = langInfos
                                profileImages = data.imageUrls
                            })
                            self.essentialProfile.userName = data.name
                            self.essentialProfile.nationality = data.nationality
                            self.essentialProfile.userAge = data.age
                            self.essentialProfile.gender = data.gender
                            self.essentialProfile.languageNames = data.languageNames
                            self.essentialProfile.languageLevels = data.languageLevels
                        }
                    }
                case let .failure(error):
                    print("SearchProfileVC - upload response result Not return", error)
                }
            }
        
//        AF.request(API.BASE_URL + "users/profile",
//                   method: .post,
//                   parameters: getUserProfile,
//                   encoder:  URLEncodedFormParameterEncoder(destination: .httpBody)) // default set body and Content-Type HTTP header field of an encoded request is set to application/json
//        .validate(statusCode: 200..<500)
//        .response { response in // reponseData
//            switch response.result {
//            case .success:
//                debugPrint(response)
//                guard let data = response.data else { return }
//                do{
//                    let decodedData = try JSONDecoder().decode(APIResponse<ServiceUserProfile>.self, from: data)
//                    print(decodedData.data)
//                    if let data = decodedData.data {
//
//                        var getImage: UIImage?
//                        DispatchQueue.global().async {
//                            guard let imageUrl = decodedData.data?.profileImg else { return }
//                            imageUrl.urlToImage { (image) in
//                                guard let image = image else { return }
//                                getImage = image
//                            }
//                            let langCnt = decodedData.data?.languageNames.count ?? 0
//
//                            // 변경 필요 계속 추가됨
//                            for i in 0..<langCnt {
//                                self.languagesInfo += "\(decodedData.data?.languageNames[i] ?? "") (\(decodedData.data?.languageLevels[i] ?? ""))\n"
//                            }
//                            DispatchQueue.main.async {
//                                self.profileImageView.image = getImage // 따로 넣어줌
//                                self.profileImageLabel.text = data.name
//                                self.profileLanguagesLabel.text = self.languagesInfo
//                                self.essentialProfile.userName = data.name
//                                self.essentialProfile.nationality = data.nationality
//                                self.essentialProfile.userAge = data.age
//                                self.essentialProfile.gender = data.gender
//                                self.essentialProfile.languageNames = data.languageNames
//                                self.essentialProfile.languageLevels = data.languageLevels
//                            }
//                        }
//                    }
//                }
//                catch{
//                    print(error.localizedDescription)
//                }
//            case .failure(let error):
//                debugPrint(response)
//                print(error)
//            }
//        }
//        AF.request(API.BASE_URL + "users/profile",
//                   method: .get,
//                   parameters: nil,
//                   encoding: JSONEncoding.default)
//            .validate(statusCode: 200..<500)
//            .responseData { response in
//            switch response.result {
//            case .success:
//                debugPrint(response)
//                guard let data = response.value else { return }
//                do{
//                    let decodedData = try JSONDecoder().decode(APIResponse<ServiceUserProfile>.self, from: data)
//                    var getImage: UIImage?
//                    DispatchQueue.global().async {
//                        guard let imageUrl = decodedData.data?.profileImg else { return }
//                        imageUrl.urlToImage { (image) in
//                            guard let image = image else { return }
//                            getImage = image
//                        }
//                        let langCnt = decodedData.data?.languageNames.count ?? 0
//                        for i in 0..<langCnt {
//                            self.languagesInfo += "\(decodedData.data?.languageNames[i] ?? "") (\(decodedData.data?.languageLevels[i] ?? ""))\n"
//                        }
//                        DispatchQueue.main.async {
//                            self.profileImageView.image = getImage
//                            self.profileImageLabel.text = decodedData.data?.name
//                            self.profileLanguagesLabel.text = self.languagesInfo
//                        }
//                    }
//                }
//                catch{
//                    print(error.localizedDescription)
//                }
//            case let .failure(error):
//                print(error)
//            }
//        }
    }
    
    @objc func rightButtonPressed(_ sender: Any) {
//        navigationController.push
        
        
//        guard let userItem = try? KeychainManager.getUserItem() else { return }
//        userProfile.userId = userItem.userId
//        print(userProfile)
//        
//        
//        
//        DispatchQueue.main.async {
//            let
//            self.navigationController?.pushViewController(<#T##viewController: UIViewController##UIViewController#>, animated: <#T##Bool#>)
//        }
    }
    
    @objc func profileImageViewTapped(_ sender: UITapGestureRecognizer) {
        DispatchQueue.main.async(execute: {
            let GPIVC = GetProfileImagesViewController()
            GPIVC.profileImages = self.profileImages
            GPIVC.modalPresentationStyle = .fullScreen
            self.present(GPIVC, animated: true)
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
