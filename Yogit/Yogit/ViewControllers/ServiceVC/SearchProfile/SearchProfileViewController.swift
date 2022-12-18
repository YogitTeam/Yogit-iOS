//
//  SearchProfileViewController.swift
//  Yogit
//
//  Created by Junseo Park on 2022/11/20.
//

import UIKit
import SnapKit
import Alamofire

class SearchProfileViewController: UIViewController {
    // profile
    // profile image >> pagecontrol
    
    var otherUserId: Int64?
    
    private var languagesInfo: String = ""
    
    private let aboutMe: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 16, weight: UIFont.Weight.regular)
        label.sizeToFit()
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 0
        return label
    }()
    
    private let profileLanguagesLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 16, weight: UIFont.Weight.regular)
        label.sizeToFit()
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 0
        return label
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
        label.font = .systemFont(ofSize: 16, weight: UIFont.Weight.regular)
        label.text = "Select photos"
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
        [self.profileImageView, self.profileImageLabel].forEach { stackView.addArrangedSubview($0) }
        return stackView
    }()
    
    private lazy var profileContentView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.addSubview(profileImageStackView)
        return view
    }()
    
    private lazy var rightButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "", image: UIImage(named: "Edit"), target: self, action: #selector(self.rightButtonPressed(_:)))
//        let button = UIBarButtonItem(title: "Sign Up", style: .plain, target: self, action: #selector(buttonPressed(_:)))
        button.tintColor =  UIColor(rgb: 0x3232FF, alpha: 1.0)
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(profileContentView)
        view.addSubview(profileLanguagesLabel)
        getProfile()
        configureViewComponent()
        // Do any additional setup after loading the view.
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
        profileLanguagesLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageStackView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        profileContentView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
//            make.bottom.equalToSuperview()
            make.bottom.leading.trailing.equalToSuperview()
        }
    }
    

    private func configureViewComponent() {
        self.view.backgroundColor = .systemBackground
        self.navigationItem.rightBarButtonItem = self.rightButton
    }
    
    func getProfile() {
        guard let userItem = try? KeychainManager.getUserItem() else { return }
        if self.otherUserId == nil {
            self.otherUserId = userItem.userId
        }
        guard let userId = self.otherUserId else { return }
        let getUserProfile = GetUserProfile(refreshToken: userItem.refresh_token, refreshTokenUserId: userItem.userId, userId: userId)
        print("refeshID userId", userItem.userId, userId)
//        URLEncodedFormParameterEncoder(destination: .httpBody)
//         JSONParameterEncoder.default
        AF.request(API.BASE_URL + "users/profile",
                   method: .post,
                   parameters: getUserProfile,
                   encoder:  URLEncodedFormParameterEncoder(destination: .httpBody)) // default set body and Content-Type HTTP header field of an encoded request is set to application/json
        .validate(statusCode: 200..<500)
        .response { response in // reponseData
            switch response.result {
            case .success:
                debugPrint(response)
                guard let data = response.data else { return }
                do{
                    let decodedData = try JSONDecoder().decode(APIResponse<ServiceUserProfile>.self, from: data)
                    print(decodedData.data)
                    var getImage: UIImage?
                    DispatchQueue.global().async {
                        guard let imageUrl = decodedData.data?.profileImg else { return }
                        imageUrl.urlToImage { (image) in
                            guard let image = image else { return }
                            getImage = image
                        }
                        let langCnt = decodedData.data?.languageNames.count ?? 0
                        for i in 0..<langCnt {
                            self.languagesInfo += "\(decodedData.data?.languageNames[i] ?? "") (\(decodedData.data?.languageLevels[i] ?? ""))\n"
                        }
                        DispatchQueue.main.async {
                            self.profileImageView.image = getImage
                            self.profileImageLabel.text = decodedData.data?.name
                            self.profileLanguagesLabel.text = self.languagesInfo
                        }
                    }
                }
                catch{
                    print(error.localizedDescription)
                }
            case .failure(let error):
                debugPrint(response)
                print(error)
            }
        }
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
    
    @objc private func rightButtonPressed(_ sender: Any) {
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
            let SPIVC = SearchProfileImagesViewController()
            SPIVC.modalPresentationStyle = .fullScreen
            self.present(SPIVC, animated: true)
//            self.navigationController?.pushViewController(SPIVC, animated: true)
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
