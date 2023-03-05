//
//  InterestsViewController.swift
//  Yogit
//
//  Created by Junseo Park on 2023/01/20.
//

import UIKit
import TTGTags
import SnapKit

private enum InterestCategoryId: Int, CaseIterable {
    case personality = 0
    case lifestyle
    case hobby
    case sports
    case food

    func toTitle() -> String {
        switch self.rawValue {
        case 0: return "Personality"
        case 1: return "Lifestyle"
        case 2: return "Hobbies & Interests"
        case 3: return "Sports"
        case 4: return "Food"
        default: fatalError("Not exist InterestCategoryId")
        }
    }
}

protocol InterestsProtocol {
    func interestsSend(interests: [String])
}


class InterestsViewController: UIViewController, TTGTextTagCollectionViewDelegate {

    var mode: Mode = .create
    
    var selectedTags: [String] = [] {
        didSet {
            print("selectedTags", selectedTags)
        }
    }
    
    var userProfile = UserProfile()
    
    var delegate: InterestsProtocol?
    
    private let seletedMax = 15
    
    private let contents = [["🙂 Introvert", "😆 Extrovert", "🥹 Emotional","🤩 Positive", "🤣 Humorous","🫢 Shy", "😮 Careful"], ["👋 New friends","🏠 Housekeeper","🐶 Pet","👟 Take a walk","🥑 Diet","🚶 Alone", "👩‍❤️‍👨 Marriage"], ["🎥 Movie","🎬 Drama", "🎮 Game", "🎤 Singing", "🗣 Language exchnage", "🎻 Playing an instrument", "🥂 Party", "✈️ Travel", "🧺 Picnic", "📖 Reading", "🚗 Driving","🎨 Painting","🛍 Shopping","🍞 Baking","🍳 Cooking","🖼 Visit the exhibition","📸 Taking a photo","🎵 Music", "👯‍♀️ Dance"], ["🥎 Tennis","⚽️ Soccer","🧘 Yoga","🏃‍♂️ Running", "🏊‍♀️ Swimming", "⚾️ Baseball","🏀 Basketball","🏄‍♂️ Surfing","🎳 Bowling","🧘‍♂️ Pilates","🏋️ Fitness", "🚴‍♀️ Cycling", "🗻 Hiking", "🏕 Camping", "🧘‍♀️ Meditation", "🪂 Extreme sports"], ["🍷 Alcohol","🙅‍♀️ Non-Alcohol","🥬 Vegan", "☕️ Coffee"]]
    
    private lazy var categoryTagContentScrollView: UIScrollView = {
       let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.isScrollEnabled = true
        scrollView.backgroundColor = .systemBackground
        scrollView.addSubview(categoryTagContentView)
        
        return scrollView
    }()

    private let categoryTagContentView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var noticeLabelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .leading
        stackView.axis = .vertical
        stackView.spacing = 6
        stackView.backgroundColor = .systemBackground
        [noticeLabel, limitLabel].forEach { stackView.addArrangedSubview($0) }
        return stackView
    }()
    
    private let noticeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 24, weight: UIFont.Weight.bold)
        label.text = "Choose my interests"
        label.sizeToFit()
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var limitLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .systemRed
        label.font = .systemFont(ofSize: 16, weight: UIFont.Weight.medium)
        label.text = "\(selectedTags.count) / \(seletedMax)"
        label.sizeToFit()
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var rightButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(rightButtonPressed(_:)))
        button.tintColor = ServiceColor.primaryColor
        return button
    }()
    
//    private lazy var nextButton: UIButton = {
//        let button = UIButton()
//        button.setImage(UIImage(named: "push")?.withTintColor(.white, renderingMode: .alwaysOriginal), for: .normal)
//        button.tintColor = .white
//        button.isHidden = false
//        button.isEnabled = true
//        button.backgroundColor = ServiceColor.primaryColor
//        button.addTarget(self, action: #selector(self.nextButtonTapped(_:)), for: .touchUpInside)
//        return button
//    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureCategoryTagView()
        configureNav()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        noticeLabelStackView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        categoryTagContentScrollView.snp.makeConstraints {
            $0.top.equalTo(noticeLabelStackView.snp.bottom).offset(20)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        categoryTagContentView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.top.equalToSuperview()
            $0.centerX.bottom.equalToSuperview()
        }
    }
    
    private func configureView() {
        view.addSubview(noticeLabelStackView)
        view.addSubview(categoryTagContentScrollView)
        view.backgroundColor = .systemBackground
    }
    
    private func configureNav() {
        navigationItem.rightBarButtonItem = rightButton
    }
    
    private func configureCategoryTagView() {
        noticeLabelStackView.layoutIfNeeded()
        let categoryCnt = InterestCategoryId.allCases.count
        var stackViewAccumulatedY: CGFloat = 0
        for i in 0..<categoryCnt {
            let label = UILabel()
            let tagView = TTGTextTagCollectionView()
            let stackView = UIStackView()
            label.tag = i
            tagView.tag = i
            stackView.addArrangedSubview(label)
            stackView.addArrangedSubview(tagView)
            categoryTagContentView.addSubview(stackView)
            let labelHeight = setupLabel(label: label)
            let tagViewHeight = setupTagView(tagView: tagView)
            let stackViewHeight = labelHeight + tagViewHeight + stackView.spacing + tagView.verticalSpacing
            setupStackView(stackView: stackView)
            print("label, tagview. stackview", labelHeight, tagViewHeight, stackViewHeight)
            NSLayoutConstraint.activate([
                stackView.topAnchor.constraint(equalTo: categoryTagContentView.topAnchor, constant: stackViewAccumulatedY + CGFloat(30 * i)),
                stackView.leadingAnchor.constraint(equalTo: categoryTagContentView.leadingAnchor, constant: 20),
                stackView.trailingAnchor.constraint(equalTo: categoryTagContentView.trailingAnchor, constant: 0),
                stackView.heightAnchor.constraint(equalToConstant: stackViewHeight)
            ])
            if i == categoryCnt-1 {
                NSLayoutConstraint.activate([
                    stackView.bottomAnchor.constraint(equalTo: categoryTagContentView.bottomAnchor, constant: -30)
                ])
            }
            stackViewAccumulatedY += stackViewHeight
        }
    }

    private func setupLabel(label: UILabel) -> CGFloat {
        if let title = InterestCategoryId(rawValue: label.tag)?.toTitle() {
            label.text = title
        }
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        label.sizeToFit()
        return label.frame.size.height
    }

    private func setupTagView(tagView: TTGTextTagCollectionView) -> CGFloat {
        tagView.backgroundColor = UIColor.systemBackground
        tagView.scrollDirection = .horizontal
        tagView.alignment = .left
        tagView.showsHorizontalScrollIndicator = false
        tagView.delegate = self
        
        let n = contents[tagView.tag].count/5
        let m = contents[tagView.tag].count%5 != 0 ? 1 : 0
        let linesNum: UInt = UInt(n + m)
        tagView.numberOfLines = linesNum
        for text in contents[tagView.tag] {
            let content = TTGTextTagStringContent.init(text: text)
            content.textColor = UIColor.systemGray//UIColor.black
            content.textFont = UIFont.systemFont(ofSize: 17, weight: .regular)//boldSystemFont(ofSize: 20)
            
            let selectedContent = TTGTextTagStringContent.init(text: text)
            selectedContent.textColor = ServiceColor.primaryColor
            selectedContent.textFont = UIFont.systemFont(ofSize: 17, weight: .regular)
        
            let normalStyle = TTGTextTagStyle.init()
            normalStyle.backgroundColor = UIColor.systemGray6
            normalStyle.borderWidth = 2
            normalStyle.borderColor = .systemGray6
            normalStyle.extraSpace = CGSize.init(width: 16, height: 8)
            normalStyle.cornerRadius = 16
            normalStyle.shadowColor = .clear

            let selectedStyle = TTGTextTagStyle.init()
            selectedStyle.backgroundColor = .systemBackground
            selectedStyle.borderWidth = 2
            selectedStyle.shadowColor = .clear
            selectedStyle.borderColor = ServiceColor.primaryColor
            selectedStyle.extraSpace = CGSize.init(width: 16, height: 8)
            selectedStyle.cornerRadius = 16

            let tag = TTGTextTag.init()
            tag.content = content
            tag.style = normalStyle
            tag.selectedContent = selectedContent
            tag.selectedStyle = selectedStyle

            for selectedTag in selectedTags {
                tag.selected = selectedTag == text ? true : false
            }
            
            tagView.addTag(tag)
        }
        
        tagView.horizontalSpacing = 12
        tagView.verticalSpacing = 12

        tagView.contentInset = UIEdgeInsets(top: 4, left: 0, bottom: 4, right: 20)
        tagView.reload()
        tagView.sizeToFit()
        return tagView.frame.size.height
    }

    private func setupStackView(stackView: UIStackView) {
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 10
        stackView.alignment = .leading
//        stackView.layer.borderWidth = 1
//        stackView.layer.borderColor = UIColor.blue.cgColor
        stackView.backgroundColor = .systemBackground
    }
    
    @objc private func rightButtonPressed(_ sender: Any) {
        if mode == .edit {
            delegate?.interestsSend(interests: selectedTags)
            DispatchQueue.main.async(qos: .userInteractive, execute: {
                self.navigationController?.popViewController(animated: true)
            })
        } else {
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
    }
    
//    @objc private func nextButtonTapped(_ sender: UIButton) {
//
//
////        userProfile.aboutMe = aboutMeTextView.myTextView.text
////
////        print("nextButtonTapped userPrfile data", userProfile)
//
////        guard let userItem = try? KeychainManager.getUserItem() else { return }
////        userProfile.userId = userItem.userId
////        userProfile.refreshToken = userItem.refresh_token
////
////        // 추가 정보 포함된 SearchUserProfile로 요청 때린다.
////        // userProfile에  SearchUserProfile 모든 데이터 포함
////        let urlRequestConvertible = ProfileRouter.uploadEssentialProfile(parameters: userProfile)
//        if let parameters = urlRequestConvertible.toDictionary {
//            AlamofireManager.shared.session.upload(multipartFormData: { multipartFormData in
//                for (key, value) in parameters {
//                    if let arrayValue = value as? [Any] {
//                        for arrValue in arrayValue {
//                            multipartFormData.append(Data("\(arrValue)".utf8), withName: key)
//                        }
//                    } else {
//                        multipartFormData.append(Data("\(value)".utf8), withName: key)
//                    }
//                }
//            }, with: urlRequestConvertible)
//            .validate(statusCode: 200..<501)
//            .responseDecodable(of: APIResponse<FetchUserProfile>.self) { response in
//                switch response.result {
//                case .success:
//                    do {
//                        guard let value = response.value else { return }
//                        guard let data = value.data else { return }
//                        if value.httpCode == 200 {
//                            userItem.account.hasRequirementInfo = true // 유저 hasRequirementInfo 저장 (필수데이터 정보)
//                            userItem.userName = data.name // 유저 이름, 상태 저장
//                            try KeychainManager.updateUserItem(userItem: userItem)
//                            let rootVC = UINavigationController(rootViewController: ServiceTapBarViewController())
//                            DispatchQueue.main.async { [self] in
//                                view.window?.rootViewController = rootVC
//                                view.window?.makeKeyAndVisible()
//                            }
//                        }
//                    } catch {
//                        print("Error - KeychainManager.update \(error.localizedDescription)")
//                    }
//                case let .failure(error):
//                    print("SetProfileVC - upload response result Not return", error)
//                }
//            }
//        }
//    }
    
    func textTagCollectionView(_ textTagCollectionView: TTGTextTagCollectionView!, canTap tag: TTGTextTag!, at index: UInt) -> Bool {
        if selectedTags.count < seletedMax && tag.selected == false {
            return true
        }
        else if selectedTags.count <= seletedMax && tag.selected == true {
            return true
        } else {
            return false
        }
    }

//    func textTagCollectionView(_ textTagCollectionView: TTGTextTagCollectionView!, updateContentSize contentSize: CGSize) {
//        let contentWidth = textTagCollectionView.intrinsicContentSize.width
//        let contentHeight = textTagCollectionView.intrinsicContentSize.height
//        CGSize(width: contentWidth+20, height: contentHeight)
//    }
    
    func textTagCollectionView(_ textTagCollectionView: TTGTextTagCollectionView!, didTap tag: TTGTextTag!, at index: UInt) {
        let tapedTag = contents[textTagCollectionView.tag][Int(index)]
        if tag.selected == true {
            selectedTags.append(tapedTag)
        } else {
            print("삭제전", selectedTags)
            for i in 0..<selectedTags.count {
                if selectedTags[i] == tapedTag {
                    selectedTags.remove(at: i)
                    break
                }
            }
            print("삭제후", selectedTags)
        }
        DispatchQueue.main.async { [self] in
            limitLabel.text = "\(selectedTags.count) / \(seletedMax)"
        }
    }
}

