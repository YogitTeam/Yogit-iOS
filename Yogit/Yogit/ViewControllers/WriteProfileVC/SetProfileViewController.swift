//
//  ProfileViewController.swift
//  Yogit
//
//  Created by Junseo Park on 2022/09/11.
//

// pickerview >> keyboard constraint error

import UIKit
import ProgressHUD
import SkeletonView

protocol FetchUserProfileProtocol: AnyObject {
    func sendFetchedUserProfile(data: FetchUserProfile)
}

class SetProfileViewController: UIViewController {
    private let genderData = ["Prefer not to say", "Male", "Female"]
    private var ageData = [Int]()
    private var userAge = 18
    private var userGender = "Prefer not to say"
    private var sectionNumber: Int = 5
    private var lastSectionFooterHeight: CGFloat = 100
    
    weak var delegate: FetchUserProfileProtocol?
    
    // 설정화면에서 오면 edit 모드 (모든 정보), create 모드 (필수 정보)
    var mode: Mode = .create {
        didSet {
            if mode == .edit {
                sectionNumber = 8
                lastSectionFooterHeight = 46
                nextButton.isHidden = true
                rightButton.isHidden = false
            }
        }
    }
    
    var userProfile = UserProfile() {
        didSet {
            print("userProfile", userProfile)
        }
    }
    
    var userProfileImage: String? {
        didSet {
            if let imageString = userProfileImage {
                let skeletonAnimation = SkeletonAnimationBuilder().makeSlidingAnimation(withDirection: .leftRight)
                profileImageView.showAnimatedGradientSkeleton(usingGradient: .init(colors: [.systemGray6, .systemGray5]), animation: skeletonAnimation, transition: .none)
                profileImageView.setImage(with: imageString)
                profileImageLabel.textColor = .label
                profileImageLabel.text = "CHANGE_PHOTOS".localized()
                profileImageView.stopSkeletonAnimation()
                profileImageView.hideSkeleton()
            }
        }
    }
    
    private lazy var nextButton: UIButton = {
        let button = UIButton()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold)
        let image = UIImage(systemName: "chevron.right", withConfiguration: imageConfig)
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.isHidden = false
        button.backgroundColor = ServiceColor.primaryColor
        button.addTarget(self, action: #selector(self.nextButtonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var pendingView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = ServiceColor.primaryColor.withAlphaComponent(0.7)
        view.frame = CGRect(origin: .zero, size: CGSize(width: self.view.frame.size.width, height: self.view.frame.size.height))
        view.isHidden = true
        return view
    }()
    
    // requirement expression blue point
    private lazy var requirementView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = ServiceColor.primaryColor
        view.layer.cornerRadius = 4
        return view
    }()
    
    private lazy var rightButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "DONE".localized(), style: .plain, target: self, action: #selector(rightButtonPressed(_:)))
        button.isHidden = true
        button.tintColor =  ServiceColor.primaryColor
        return button
    }()
    
    private let agePickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        pickerView.backgroundColor = .systemGray6
        return pickerView
    }()
    
    private let genderPickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.backgroundColor = .systemGray6
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
        toolBar.backgroundColor = .systemGray4
        toolBar.layer.cornerRadius = 10
        doneButton.tintColor = ServiceColor.primaryColor
        toolBar.setItems([flexSpace, doneButton], animated: true)
        return toolBar
    }()

    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.isSkeletonable = true
        imageView.image = UIImage(named: "PROFILE_IMAGE_NULL")
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
        label.text = "SELECT_PHOTOS".localized()
        label.textColor = .placeholderText
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
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
    
    private var hasMissingValue: String? {
        let str: String?
        if userProfileImage == nil {
            str = "PROFILE_IMAGE"
        } else if userProfile.userName == nil {
            str = "PROFILE_NAME"
        } else if userProfile.userAge == nil {
            str = "PROFILE_AGE"
        } else if !((userProfile.languageCodes?.count ?? 0 > 0) && (userProfile.languageLevels?.count ?? 0 > 0)) {
            str = "PROFILE_LANGUAGE"
        } else if userProfile.nationality == nil  {
            str = "PROFILE_NATIONALIY"
        } else if userProfile.gender == nil {
            str = "PROFILE_GENDER"
        } else {
            str = nil
        }
        return str?.localized().lowercased()
//        let isTrue = (userProfileImage != nil) && (userProfile.userName != nil) && (userProfile.userAge != nil) && (userProfile.languageCodes?.count ?? 0 > 0) && (userProfile.languageLevels?.count ?? 0 > 0) && (userProfile.nationality != nil) && (userProfile.gender != nil)
//        return isTrue
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        initProgressHUD()
        configureTableView()
        configurePickerVew()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNav()
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
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(20)
            $0.width.height.equalTo(60)
        }
        nextButton.layer.cornerRadius = nextButton.frame.size.width/2
    }
    
    private func configureView() {
        view.addSubview(infoTableView)
        view.addSubview(pendingView)
        view.addSubview(nextButton)
        view.backgroundColor = .systemBackground
    }
    
    private func configureNav() {
        navigationItem.title = "PROFILE".localized()
        navigationItem.backButtonTitle = "" // remove back button title
        navigationItem.rightBarButtonItem = rightButton
    }
    
    private func initProgressHUD() {
        ProgressHUD.colorAnimation = ServiceColor.primaryColor
        ProgressHUD.animationType = .circleStrokeSpin
    }
    
    private func configureTableView() {
        infoTableView.delegate = self
        infoTableView.dataSource = self
        hideKeyboardWhenTappedAroundInTableView()
    }
    
    private func configurePickerVew() {
        agePickerView.delegate = self
        genderPickerView.delegate = self
        for i in 18...60 { ageData.append(i) }
    }
    
    private func missingDataAlert() {
        let message = String(format: "PROFILE_MISSING_DATA_ALERT".localized(), "\(hasMissingValue!)")
        let alert = UIAlertController(title: "", message: message, preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "OK".localized(), style: .default)
        alert.addAction(okAction)
        DispatchQueue.main.async(qos: .userInteractive) {
            self.present(alert, animated: false, completion: nil)
        }
    }
    
    @objc private func nextButtonTapped(_ sender: UIButton) {
        
        guard hasMissingValue == nil else {
            missingDataAlert()
            return
        }
        
        DispatchQueue.main.async(qos: .userInteractive, execute: {
            let JVC = JobViewController()
            JVC.mode = self.mode
            JVC.userProfile = self.userProfile
            self.navigationController?.pushViewController(JVC, animated: true)
        })
    }
    
    @objc private func rightButtonPressed(_ sender: Any) {
        print("rightButtonPressed userProfile Data", userProfile)
        guard hasMissingValue == nil else {
            missingDataAlert()
            return
        }
        
        ProgressHUD.show(interaction: false)
        
        guard let identifier = UserDefaults.standard.object(forKey: SessionManager.currentServiceTypeIdentifier) as? String, let userItem = try? KeychainManager.getUserItem(serviceType: identifier) else { return }
        
        userProfile.userId = userItem.userId
        userProfile.refreshToken = userItem.refresh_token

        let urlRequestConvertible = ProfileRouter.uploadEssentialProfile(parameters: userProfile)
        if let parameters = urlRequestConvertible.toDictionary {
            print("parameters", parameters)
            AlamofireManager.shared.session.upload(multipartFormData: { multipartFormData in
                for (key, value) in parameters {
                    if let arrayValue = value as? [Any] {
                        if arrayValue.isEmpty {
                            multipartFormData.append(Data("".utf8), withName: key) // 0 byte
                        } else {
                            for arrValue in arrayValue {
                                multipartFormData.append(Data("\(arrValue)".utf8), withName: key)
                            }
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
                    if let value = response.value, (value.httpCode == 200 || value.httpCode == 201) {
                        guard let data = value.data else { return }
                        DispatchQueue.main.async { [weak self] in
                            self?.delegate?.sendFetchedUserProfile(data: data)
                            self?.navigationController?.popViewController(animated: true)
                            ProgressHUD.dismiss()
                        }
                    }
                case let .failure(error):
                    print("SetProfileVC - upload response result Not return", error)
                    DispatchQueue.main.async { // 변경
                        ProgressHUD.dismiss()
                    }
                }
            }
        }
    }
    
//    private func checkAllData() {
//        if mode == .create {
//            if hasMissingValue == nil {
//                nextButton.backgroundColor = ServiceColor.primaryColor
//            } else {
//                nextButton.backgroundColor = .placeholderText
//            }
//        }
//    }
    
    @objc private func profileImageViewTapped(_ sender: UITapGestureRecognizer) {
        DispatchQueue.main.async {
            let SPICV = SetProfileImagesViewController()
            SPICV.delegate = self
            self.navigationController?.pushViewController(SPICV, animated: true)
        }
    }
    
    @objc private func donePressed(_ sender: UIButton) {
        switch sender.tag {
        case 1: userProfile.userAge = userAge
        case 4: userProfile.gender = userGender
        default: break
        }
        DispatchQueue.main.async {
            self.infoTableView.reloadData()
            self.view.endEditing(true)
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

extension SetProfileViewController: UITableViewDataSource {
    // Reporting the number of sections and rows in the table.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
            case 2: return (userProfile.languageCodes?.count ?? 0) < 5 ? ((userProfile.languageCodes?.count ?? 0) + 1) : 5
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
        switch indexPath.section {
            case 0:
            if mode == .edit {
                cell.commonTextField.textColor = .placeholderText
                cell.selectionStyle = .none
            }
            cell.configure(text: userProfile.userName, section: indexPath.section)
            case 1:
            cell.selectionStyle = .none
            cell.configure(text: userProfile.userAge == nil ? nil : "\(userProfile.userAge!)", section: indexPath.section) // "International age"
            cell.commonTextField.inputView = agePickerView
            cell.commonTextField.inputAccessoryView = pickerViewToolBar
            agePickerView.tag = indexPath.section // picker data, event 분기
            case 2:
            if indexPath.row < (userProfile.languageCodes?.count ?? 0) {
                if let code = userProfile.languageCodes?[indexPath.row], let identifier = Locale.preferredLanguages.first {
                    let localizedLocale = Locale(identifier: identifier)
                    let originLocale = Locale(identifier: code)
                    if let localizedLanguage = localizedLocale.localizedString(forIdentifier: code), let originLanguage = originLocale.localizedString(forIdentifier: code) {
                        if localizedLanguage == originLanguage {
                            cell.configure(text: "\(localizedLanguage)", section: indexPath.section) // "Add
                        } else {
                            cell.configure(text: "\(localizedLanguage) (\(originLanguage))", section: indexPath.section) // "Add
                        }
                        cell.subLabel.text = LanguageLevels(rawValue: (userProfile.languageLevels?[indexPath.row])!)?.toString()
                    }
                }
            } else {
                cell.configure(text: nil, section: indexPath.section)
            }
            cell.rightButton.addTarget(self, action: #selector(self.deleteButtonTapped(_:)), for: .touchUpInside)
            cell.rightButton.tag = indexPath.row
            case 3:
            if mode == .edit {
                cell.commonTextField.textColor = .placeholderText
                cell.selectionStyle = .none
            }
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
            cell.configure(text: userProfile.gender?.localized(), section: indexPath.section) // "Select gender"
            cell.commonTextField.inputView = genderPickerView
            cell.commonTextField.inputAccessoryView = pickerViewToolBar
            genderPickerView.tag = indexPath.section
            case 5:
            cell.configure(text: userProfile.job, section: indexPath.section) // "Select gender"
            case 6:
            cell.configure(text: userProfile.aboutMe, section: indexPath.section) // "Select gender"
            case 7:
            var text = ""
            if let hashTags = userProfile.interests, hashTags.count != 0 {
                for hashTag in hashTags {
                    text += "\(hashTag), "
                }
                text.removeLast(2)
            }
            cell.configure(text: text, section: indexPath.section)
        default: fatalError("Out of Setup Profile table view section")
        }
        cell.layoutIfNeeded()
        cell.addBottomBorderWithColor(color: .placeholderText, width: 1)
        return cell
        
    }
    
    @objc private func deleteButtonTapped(_ button: UIButton) {
        userProfile.languageCodes?.remove(at: button.tag)
        userProfile.languageLevels?.remove(at: button.tag)
        DispatchQueue.main.async {
            self.infoTableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: RequirementTableViewHeader.identifier) as? RequirementTableViewHeader else { return UITableViewHeaderFooterView() }
        headerView.configure(at: section)
        headerView.layoutIfNeeded()
        return headerView
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let footerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: SetProfileTableViewFooter.identifier) as? SetProfileTableViewFooter else { return UITableViewHeaderFooterView() }
        // userName, age, lanages, gender, nationality
        switch section {
        case 0: footerView.configure(text: "PROFILE_FOOTER_NAME", kind: section)
        case 3: footerView.configure(text: "PROFILE_FOOTER_NATIONALITY", kind: section)
        case 4: footerView.configure(text: "PROFILE_FOOTER_LAST", kind: section)
        default: return nil
        }
        return footerView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        switch section {
            case 0: return 46
            case 3: return 30
            case 4: return lastSectionFooterHeight // 40 or 120
            default: return 14 // origin 14
        }
    }
}

extension SetProfileViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        DispatchQueue.main.async(qos: .userInteractive) {
            switch indexPath.section {
            case 0:
                if self.mode == .edit {
                    let NVC = NameViewController()
                    NVC.delegate = self
                    NVC.userName = self.userProfile.userName
                    self.navigationController?.pushViewController(NVC, animated: true)
                }
            case 2:
                if indexPath.row >= self.userProfile.languageCodes?.count ?? 0 {
                    let LVC = LanguagesViewController()
                    LVC.delegate = self
                    LVC.userLangs = self.userProfile.languageCodes
                    self.navigationController?.pushViewController(LVC, animated: true)
                }
            case 3:
                if self.mode == .edit {
                    let NVC = NationalityViewController()
                    NVC.delegate = self
                    self.navigationController?.pushViewController(NVC, animated: true)
                }
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
            case 7:
                let IVC = InterestsViewController()
                IVC.delegate = self
                IVC.mode = self.mode
                if let interests = self.userProfile.interests {
                    IVC.selectedTags = interests
                }
                self.navigationController?.pushViewController(IVC, animated: true)
            default:
                break
            }
        }
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

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        switch textField.tag {
        default: return false
        }
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
        DispatchQueue.main.async {
            self.infoTableView.reloadData()
        }
    }
}

extension SetProfileViewController: AboutMeProtocol {
    func aboutMeSend(aboutMe: String) {
        userProfile.aboutMe = aboutMe
        DispatchQueue.main.async {
            self.infoTableView.reloadData()
        }
    }
}



extension SetProfileViewController: LanguageProtocol {
    func languageSend(languageCode: String, language: String, level: Int) {
        userProfile.languageCodes = userProfile.languageCodes ?? []
        userProfile.languageLevels = userProfile.languageLevels ?? []
        userProfile.languageCodes?.append(languageCode)
        userProfile.languageLevels?.append(level)
        DispatchQueue.main.async {
            self.infoTableView.reloadData()
        }
    }
}

extension SetProfileViewController: InterestsProtocol {
    func interestsSend(interests: [String]) {
        userProfile.interests = interests
        DispatchQueue.main.async {
            self.infoTableView.reloadData()
        }
    }
}

extension SetProfileViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case ProfileSectionData.age.rawValue: return self.ageData.count
        case ProfileSectionData.gender.rawValue: return self.genderData.count
        default: fatalError("Non exist picker view")
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag {
        case ProfileSectionData.age.rawValue: return "\(self.ageData[row])"
        case ProfileSectionData.gender.rawValue: return "\(self.genderData[row].localized())"
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
        DispatchQueue.main.async {
            self.infoTableView.reloadData()
        }
    }
}

extension SetProfileViewController: NationalityProtocol {
    func nationalitySend(nationality: Country) {
        userProfile.nationality = nationality.countryCode // nationality.countryEmoji + " " + nationality.countryName
        DispatchQueue.main.async {
            self.infoTableView.reloadData()
        }
    }
}

extension SetProfileViewController {
    func hideKeyboardWhenTappedAroundInTableView() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false // 해당 뷰컨의 뷰안에는 터치 못하게
        infoTableView.addGestureRecognizer(tap)
    }

    @objc private func dismissKeyboard() {
        DispatchQueue.main.async {
            self.infoTableView.endEditing(true)
        }
    }
}
