//
//  ProfileViewController.swift
//  Yogit
//
//  Created by Junseo Park on 2022/09/11.
//

// pickerview >> keyboard constraint error

import UIKit

class SetProfileViewController: UIViewController {
    
    private let genderData = ["Prefer not to say", "Male", "Female"]
    private var ageData = [Int]()
    private var userAge = 18
    private var userGender = "Prefer not to say"
    private var sectionNumber: Int = 5
    private var lastSectionFooterHeight: CGFloat = 100
//    let  = UserDefaults.standard.object(forKey: Preferences.PUSH_NOTIFICATION)
    
    // 설정화면에서 오면 edit 모드 (모든 정보), create 모드 (필수 정보)
    var mode: Mode = .create {
        didSet {
            if mode == .edit {
                sectionNumber = 7
                lastSectionFooterHeight = 40
                nextButton.isHidden = true
                rightButton.isHidden = false
            }
        }
    }
    
    var userProfile = UserProfile() {
        didSet {
            print("userProfile", userProfile)
            if mode == .create {
                if hasAllValue == true {
                    nextButton.isEnabled = true
                    nextButton.backgroundColor = UIColor(rgb: 0x3232FF, alpha: 1.0)
                } else{
                    nextButton.isEnabled = false
                    nextButton.backgroundColor = .placeholderText
                }
            }
        }
    }
    
    var userProfileImage: String? {
        didSet {
            if let imageString = userProfileImage {
                DispatchQueue.main.async(qos: .userInteractive) { [self] in
                    profileImageView.setImage(with: imageString)
                    profileImageLabel.textColor = .label
                    profileImageLabel.text = "Chage photos"
                }
            }
        }
    }
    
    private lazy var nextButton: UIButton = {
        let button = UIButton()
//        button.setTitle("Done", for: .normal)
        button.setImage(UIImage(named: "push")?.withTintColor(.white, renderingMode: .alwaysOriginal), for: .normal)
        button.tintColor = .white
        button.isHidden = false
        button.isEnabled = false
        button.backgroundColor = .placeholderText
//        button.setTitleColor(UIColor(rgb: 0x3232FF, alpha: 1.0), for: .normal)
//        button.titleLabel?.font = .systemFont(ofSize: 18, weight: UIFont.Weight.semibold)
        button.addTarget(self, action: #selector(self.nextButtonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var pendingView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(rgb: 0x3232FF, alpha: 1.0).withAlphaComponent(0.7)
        view.frame = CGRect(origin: .zero, size: CGSize(width: self.view.frame.size.width, height: self.view.frame.size.height))
        view.isHidden = true
        return view
    }()
    
    // requirement expression blue point
    private lazy var requirementView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(rgb: 0x3232FF, alpha: 1.0)
        view.layer.cornerRadius = 4
        return view
    }()
    
    private lazy var rightButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Sign Up", style: .plain, target: self, action: #selector(rightButtonPressed(_:)))
        button.isHidden = true
        button.tintColor =  UIColor(rgb: 0x3232FF, alpha: 1.0)
        return button
    }()
    
    private let agePickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        pickerView.backgroundColor = .systemBackground
        return pickerView
    }()
    
    private let genderPickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.backgroundColor = .systemBackground
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        return pickerView
    }()
    
    private lazy var pickerViewToolBar: UIToolbar = {
        let toolBar = UIToolbar(frame: CGRect(origin: .zero, size: CGSize(width: view.frame.width, height: 44.0)))
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(donePressed))
//        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelPressed))
//        let titleButton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
//        titleButton.tintColor = .label
//        cancelButton.tintColor = .systemGray
        toolBar.backgroundColor = .systemBackground
        doneButton.tintColor = UIColor(rgb: 0x3232FF, alpha: 1.0)
        toolBar.setItems([flexSpace, doneButton], animated: true)
        return toolBar
    }()

    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "profileImageNULL")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .placeholderText
        imageView.layer.cornerRadius = 55
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    private let profileImageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 17, weight: UIFont.Weight.regular)
        label.text = "Select photos"
        label.textColor = .placeholderText
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
        stackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.profileImageViewTapped(_:))))
        [self.profileImageView, self.profileImageLabel].forEach { stackView.addArrangedSubview($0) }
        return stackView
    }()
    
    private lazy var profileImageContentView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.addSubview(profileImageStackView)
        view.addSubview(requirementView)
        return view
    }()
    
    private let infoTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.isScrollEnabled = true
        tableView.separatorStyle = .none
        tableView.backgroundColor = .systemBackground
        tableView.sectionHeaderTopPadding = 16
        tableView.register(SetProfileTableViewCell.self, forCellReuseIdentifier: SetProfileTableViewCell.identifier)
        tableView.register(RequirementTableViewHeader.self, forHeaderFooterViewReuseIdentifier: RequirementTableViewHeader.identifier)
        tableView.register(SetProfileTableViewFooter.self, forHeaderFooterViewReuseIdentifier: SetProfileTableViewFooter.identifier)
        return tableView
    }()
    
    private var hasAllValue: Bool {
        let isTrue = (userProfile.languageNames?.count ?? 0 > 0) && (userProfile.languageLevels?.count ?? 0 > 0) && (userProfile.userName != nil) && (userProfile.userAge != nil) && (userProfile.gender != nil) && (userProfile.nationality != nil) && (userProfileImage != nil)
        return isTrue
    }
    
    // viewload 시 get 요청
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSuperView()
        configureNavigation()
        configureTableView()
        configurePickerVew()
        mode = .edit
//        guard let identifier = Locale.preferredLanguages.first else { return } // ko-KR
//        let language = String(identifier.dropLast(3)) // ko
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        dismissKeyboard()
    }

    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        infoTableView.frame = view.bounds
        infoTableView.tableHeaderView = profileImageContentView
        profileImageContentView.frame = CGRect(origin: .zero, size: CGSize(width: view.frame.size.width, height: 180))
        profileImageView.snp.makeConstraints { make in
            make.width.height.equalTo(110)
        }
        profileImageLabel.snp.makeConstraints { make in
            make.width.equalTo(110)
            make.height.equalTo(20)
        }
        profileImageStackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        requirementView.snp.makeConstraints { make in
            make.width.height.equalTo(8)
            make.top.equalTo(profileImageStackView.snp.top).offset(0)
            make.leading.equalTo(profileImageStackView.snp.leading).offset(0)
        }
        nextButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(0)
            $0.width.height.equalTo(60)
        }
        nextButton.layer.cornerRadius = nextButton.frame.size.width/2
    }

    private func configureSuperView() {
        view.addSubview(infoTableView)
        view.addSubview(pendingView)
        view.addSubview(nextButton)
        view.backgroundColor = .systemBackground
    }
    
    private func configureNavigation() {
        navigationItem.title = "Profile"
        navigationItem.rightBarButtonItem = rightButton
    }
    
    private func configureTableView() {
        infoTableView.delegate = self
        infoTableView.dataSource = self
        hideKeyboardWhenTappedAround()
    }
    
    private func configurePickerVew() {
        agePickerView.delegate = self
        genderPickerView.delegate = self
        for i in 18...60 { ageData.append(i) }
    }
    
    @objc func nextButtonTapped(_ sender: UIButton) {
        DispatchQueue.main.async(qos: .userInteractive, execute: {
            let JVC = JobViewController()
            JVC.mode = self.mode
            JVC.userProfile = self.userProfile
            self.navigationController?.pushViewController(JVC, animated: true)
        })
    }
    
    // rightbutton는 pop이고
    // 하단 버튼은 push이다.
    @objc private func rightButtonPressed(_ sender: Any) {
        print("rightButtonPressed userProfile Data", userProfile)
        
        if hasAllValue == false {
            let alert = UIAlertController(title: "Can't sign up", message: "Please enter all required information correctly", preferredStyle: UIAlertController.Style.alert)
            let okAction = UIAlertAction(title: "OK", style: .default)
            alert.addAction(okAction)
            present(alert, animated: false, completion: nil)
            return
        }
        
        guard let userItem = try? KeychainManager.getUserItem() else { return }
        userProfile.userId = userItem.userId
        userProfile.refreshToken = userItem.refresh_token

        
        // 추가 정보 포함된 SearchUserProfile로 요청 때린다.
        // userProfile에  SearchUserProfile 모든 데이터 포함
        let urlRequestConvertible = ProfileRouter.uploadEssentialProfile(parameters: userProfile)
        if let parameters = urlRequestConvertible.toDictionary {
            print("parameters", parameters)
            AlamofireManager.shared.session.upload(multipartFormData: { multipartFormData in
                for (key, value) in parameters {
                    if let arrayValue = value as? [Any] {
                        for arrValue in arrayValue {
                            print("key arrValue", key, arrValue)
                            multipartFormData.append(Data("\(arrValue)".utf8), withName: key)
                        }
                    } else {
                        print("key value", key, value)
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
                            userItem.userName = data.name // 유저 이름
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
    
    @objc private func profileImageViewTapped(_ sender: UITapGestureRecognizer) {
        DispatchQueue.main.async {
            let SPICV = SetProfileImagesViewController()
            SPICV.delegate = self
            self.navigationController?.pushViewController(SPICV, animated: true)
        }
    }
    
    @objc private func donePressed(_ sender: UIButton) {
        print("seder.tag", sender.tag)
        switch sender.tag {
        case 1: userProfile.userAge = userAge
        case 4: userProfile.gender = userGender
        default: break
        }
        infoTableView.reloadData()
        self.view.endEditing(true)
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

extension SetProfileViewController: UITableViewDataSource {
    // Reporting the number of sections and rows in the table.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
            case 2: return (userProfile.languageNames?.count ?? 0) < 5 ? ((userProfile.languageNames?.count ?? 0) + 1) : 5
            default: return 1
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionNumber
    }

    
    // Providing cells for each row of the table.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SetProfileTableViewCell.identifier, for: indexPath) as? SetProfileTableViewCell else { return UITableViewCell() }
        cell.commonTextField.tag = indexPath.section
        cell.commonTextField.delegate = self
//        cell.rightButton.removeTarget(self, action: #selector(self.deleteButtonTapped(_:)), for: .touchUpInside)
        cell.selectionStyle = .gray
        switch indexPath.section {
            case 0:
            cell.configure(text: userProfile.userName, section: indexPath.section)
            case 1:
            cell.configure(text: userProfile.userAge == nil ? nil : "\(userProfile.userAge!)", section: indexPath.section) // "International age"
            cell.commonTextField.inputView = agePickerView
            cell.commonTextField.inputAccessoryView = pickerViewToolBar
            agePickerView.tag = indexPath.section // picker data, event 분기
            case 2:
            if indexPath.row < (userProfile.languageNames?.count ?? 0) {
                if let code = userProfile.languageNames?[indexPath.row], let identifier = Locale.preferredLanguages.first {
                    let localizedLocale = Locale(identifier: identifier)
                    let originLocale = Locale(identifier: code)
                    if let localizedLanguage = localizedLocale.localizedString(forIdentifier: code), let originLanguage = originLocale.localizedString(forIdentifier: code) {
                        if localizedLanguage == originLanguage {
                            cell.configure(text: "\(localizedLanguage)", section: indexPath.section) // "Add
                        } else {
                            cell.configure(text: "\(localizedLanguage) (\(originLanguage))", section: indexPath.section) // "Add
                        }
                        cell.subLabel.text = userProfile.languageLevels?[indexPath.row]
                    }
                }
                cell.selectionStyle = .none
            } else {
                cell.configure(text: nil, section: indexPath.section)
            }
            cell.rightButton.addTarget(self, action: #selector(self.deleteButtonTapped(_:)), for: .touchUpInside)
            cell.rightButton.tag = indexPath.row
            case 3:
            if let code = userProfile.nationality {
                let identifier = NSLocale.localeIdentifier(fromComponents: [NSLocale.Key.countryCode.rawValue: code])
                let localeIdentifier = Locale.preferredLanguages.first ?? ""
                let countryName = NSLocale(localeIdentifier: localeIdentifier).displayName(forKey: NSLocale.Key.identifier, value: identifier) ?? "" // localize
                let flag = code.emojiFlag
                cell.configure(text: flag + " " + countryName, section: indexPath.section) // "Select nationaltiy"
            } else {
                cell.configure(text: userProfile.nationality, section: indexPath.section) // "Select nationaltiy"
            }
            case 4:
            cell.selectionStyle = .none
            cell.configure(text: userProfile.gender, section: indexPath.section) // "Select gender"
            cell.commonTextField.inputView = genderPickerView
            cell.commonTextField.inputAccessoryView = pickerViewToolBar
            genderPickerView.tag = indexPath.section
            case 5:
            cell.configure(text: userProfile.job, section: indexPath.section) // "Select gender"
            case 6:
            cell.configure(text: userProfile.aboutMe, section: indexPath.section) // "Select gender"
        default: fatalError("Out of Setup Profile table view section")
        }
        cell.layoutIfNeeded()
        cell.addBottomBorderWithColor(color: .placeholderText, width: 1)
        print("Setup profile cell update section = \(indexPath.section)")
        return cell
        
    }
    
    @objc private func deleteButtonTapped(_ button: UIButton) {
        print("Language of profile deleteButtonTapped")
        let deletedLanguage = userProfile.languageNames?.remove(at: button.tag)
        let deletedLevel = userProfile.languageLevels?.remove(at: button.tag)
        infoTableView.reloadData()
        print("deletedLangInfo \(deletedLanguage!) \(deletedLevel!)")
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: RequirementTableViewHeader.identifier) as? RequirementTableViewHeader else { return UITableViewHeaderFooterView() }
        headerView.configure(text: ProfileSectionData(rawValue: section)?.toString())
        headerView.layoutIfNeeded()
        return headerView
    }

//    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
//        // enum toString 작업 요구
//        switch section {
//        case 2:
//            return "Your name, age, languageNames will be public.\n\n"
//        case 4:
//            return "Gender, nationality help improve recommendations but are not shown publicly."
//        default:
//            return nil
//        }
//    }
//
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let footerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: SetProfileTableViewFooter.identifier) as? SetProfileTableViewFooter else { return UITableViewHeaderFooterView() }
        // userName, age, lanages, gender, nationality
        switch section {
        case 0: footerView.configure(text: "The name can't be modified after sign up.\nPlease make a careful decision.", kind: section)
        case 3: footerView.configure(text: "The nationality can't be modified after sign up.", kind: section)
        case 4: footerView.configure(text: "Your photos, name, age, languages, nationality will be public. But gender is not shown publicly.", kind: section)
        default: return nil
        }
        return footerView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        switch section {
            case 0: return 40
            case 3: return 24
            case 4: return lastSectionFooterHeight // 40 or 120
            default: return 8 // origin 8
        }
    }
}

extension SetProfileViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print("Cell 선택")
        DispatchQueue.main.async(qos: .userInteractive, execute: {
            switch indexPath.section {
            case 0:
                let NVC = NameViewController()
                NVC.delegate = self
                NVC.userName = self.userProfile.userName
                self.navigationController?.pushViewController(NVC, animated: true)
            case 2:
                if indexPath.row >= self.userProfile.languageNames?.count ?? 0 {
                    let LVC = LanguagesViewController()
                    LVC.delegate = self
                    LVC.userLangs = self.userProfile.languageNames
                    self.navigationController?.pushViewController(LVC, animated: true)
                }
            case 3:
                let NVC = NationalityViewController()
                NVC.delegate = self
                self.navigationController?.pushViewController(NVC, animated: true)
            case 5:
                let JVC = JobViewController()
                JVC.delegate = self
                JVC.mode = self.mode
                JVC.jobTextField.text = self.userProfile.job
                self.navigationController?.pushViewController(JVC, animated: true)
            case 6:
                let AMVC = AboutMeViewController()
                AMVC.delegate = self
                AMVC.mode = self.mode
                AMVC.aboutMeTextView.myTextView.text = self.userProfile.aboutMe
                self.navigationController?.pushViewController(AMVC, animated: true)
            default:
                break
            }
        })
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 48
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension SetProfileViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        guard let toolbar = textField.inputAccessoryView as? UIToolbar else { return }
        toolbar.items?[1].tag = textField.tag
    }
}

extension SetProfileViewController: ImagesProtocol {
    func imagesSend(profileImage: String) {
        userProfileImage = profileImage
    }
}

extension SetProfileViewController: JobProtocol {
    func jobSend(job: String) {
        userProfile.job = job
        infoTableView.reloadData()
    }
}

extension SetProfileViewController: AboutMeProtocol {
    func aboutMeSend(aboutMe: String) {
        userProfile.aboutMe = aboutMe
        infoTableView.reloadData()
    }
}



extension SetProfileViewController: LanguageProtocol {
    func languageSend(languageCode: String, language: String, level: String) {
        userProfile.languageNames = userProfile.languageNames ?? []
        userProfile.languageLevels = userProfile.languageLevels ?? []
        userProfile.languageNames?.append(languageCode)
        userProfile.languageLevels?.append(level)
        infoTableView.reloadData()
    }
}

extension SetProfileViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case ProfileSectionData.age.rawValue:
            return self.ageData.count
        case ProfileSectionData.gender.rawValue:
            return self.genderData.count
        default:
            fatalError("일치하는 피커뷰 없다")
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag {
        case ProfileSectionData.age.rawValue: return "\(self.ageData[row])"
        case ProfileSectionData.gender.rawValue: return "\(self.genderData[row])"
        default: fatalError("Pickerview tag error")
        }
    }
}

// textfield 터치시 어디에서 터치 했는지 알아야함
// 
extension SetProfileViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView.tag {
        case ProfileSectionData.age.rawValue: userAge = self.ageData[row]
        case ProfileSectionData.gender.rawValue: userGender = "\(self.genderData[row])"
        default: fatalError("Pickerview tag error")
        }
    }
    
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 44
    }
}

extension SetProfileViewController: NameProtocol {
    func nameSend(name: String) {
        userProfile.userName = name
        infoTableView.reloadData()
    }
}

extension SetProfileViewController: NationalityProtocol {
    func nationalitySend(nationality: Country) {
        userProfile.nationality = nationality.countryCode // nationality.countryEmoji + " " + nationality.countryName
        infoTableView.reloadData()
    }
}

extension SetProfileViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false // 해당 뷰컨의 뷰안에는 터치 못하게
        infoTableView.addGestureRecognizer(tap)
    }

    @objc private func dismissKeyboard() {
        print("tableView Tap")
        infoTableView.endEditing(true)
    }
}
