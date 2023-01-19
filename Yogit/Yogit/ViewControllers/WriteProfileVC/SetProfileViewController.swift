//
//  ProfileViewController.swift
//  Yogit
//
//  Created by Junseo Park on 2022/09/11.
//

// pickerview >> keyboard constraint error

import UIKit
//import Kingfisher

class SetProfileViewController: UIViewController {
    
    private let genderData = ["Prefer not to say", "Male", "Female"]
    private let placeholderData = ["Nick name", "International age", "Add conversational language", "Select gender", "Select nationaltiy"]
    private let maxNameCount = 25
    
    private var ageData: [Int] = []
    private var userAge = 18
    private var userGender = "Prefer not to say"
    
    var profileImage: String? {
        didSet {
            if let imageString = profileImage {
                profileImageView.setImage(with: imageString)
                profileImageLabel.textColor = .label
            } else {
                profileImageLabel.textColor = .placeholderText
            }
        }
    }
    
    var userProfile = UserProfile() {
        didSet {
            print(userProfile)
        }
    }
    
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
        let button = UIBarButtonItem(title: "Sign Up", style: .plain, target: self, action: #selector(buttonPressed(_:)))
        button.tintColor =  UIColor(rgb: 0x3232FF, alpha: 1.0)
        return button
    }()
    
    private let agePickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        return pickerView
    }()
    
    private let genderPickerView: UIPickerView = {
        let pickerView = UIPickerView()
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
        label.font = .systemFont(ofSize: 16, weight: UIFont.Weight.regular)
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
        let isTrue = (userProfile.userId != nil) && (userProfile.languageNames?.count ?? 0 > 0) && (userProfile.languageLevels?.count ?? 0 > 0) && (userProfile.userName?.count ?? 0 >= 2) && (userProfile.userAge != nil) && (userProfile.gender != nil) && (userProfile.nationality != nil) && (profileImage != nil)
        return isTrue
    }
    
    // viewload 시 get 요청
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(infoTableView)
        view.addSubview(pendingView)
        infoTableView.delegate = self
        infoTableView.dataSource = self
        agePickerView.delegate = self
        genderPickerView.delegate = self
        for i in 18...60 { ageData.append(i) }
        configureViewComponent()
        // Do any additional setup after loading the view.
    }

    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        print("setup viewDidLayoutSubviews")
        
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
    }

    private func configureViewComponent() {
        self.navigationItem.title = "Profile"
        self.navigationItem.rightBarButtonItem = self.rightButton
        self.view.backgroundColor = .systemBackground
        self.profileImageView.tag = 0
        self.hideKeyboardWhenTappedAround()
    }
    
    @objc private func buttonPressed(_ sender: Any) {
        // 값 다 있는지 확인 하고 없으면 alert창
        
        guard let userItem = try? KeychainManager.getUserItem() else { return }
        userProfile.userId = userItem.userId
        print(userProfile)
        userProfile.refreshToken = userItem.refresh_token
        userProfile.nationality = "GH"
        
        if hasAllValue == false {
            print("Not has all value")
            let alert = UIAlertController(title: "Can't sign up", message: "Please enter all required information correctly", preferredStyle: UIAlertController.Style.alert)
            let okAction = UIAlertAction(title: "OK", style: .default)
            alert.addAction(okAction)
            present(alert, animated: false, completion: nil)
            return
        }
        
        let urlConvertible = ProfileRouter.uploadEssentialProfile(parameter: userProfile)
        if let parameters = urlConvertible.toDictionary {
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
            }, to: urlConvertible, method: urlConvertible.method).validate(statusCode: 200..<501).responseDecodable(of: APIResponse<UserProfile>.self) { response in
                switch response.result {
                case .success:
                    do {
                        if response.value?.httpCode == 200 {
                            userItem.account.hasRequirementInfo = true
                            try KeychainManager.updateUserItem(userItem: userItem)
                            DispatchQueue.main.async {
                                let rootVC = UINavigationController(rootViewController: ServiceTapBarViewController())
                                self.view.window?.rootViewController = rootVC
                                self.view.window?.makeKeyAndVisible()
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
        case 3: userProfile.gender = userGender
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
            case 0, 1, 3, 4: return 1
            case 2: return (userProfile.languageNames?.count ?? 0) < 5 ? ((userProfile.languageNames?.count ?? 0) + 1) : 5
            default: return 0
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }

    
    // Providing cells for each row of the table.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SetProfileTableViewCell.identifier, for: indexPath) as? SetProfileTableViewCell else { return UITableViewCell() }
        cell.commonTextField.tag = indexPath.section
        cell.commonTextField.delegate = self
        cell.commonTextField.placeholder = placeholderData[indexPath.section]
//        cell.rightButton.removeTarget(self, action: #selector(self.deleteButtonTapped(_:)), for: .touchUpInside)
        cell.selectionStyle = .none
        switch indexPath.section {
            case 0:
            cell.configure(text: userProfile.userName, image: nil, section: indexPath.section)
            cell.commonTextField.inputAccessoryView = pickerViewToolBar
            case 1:
            cell.configure(text: userProfile.userAge == nil ? nil : "\(userProfile.userAge!)", image: nil, section: indexPath.section) // "International age"
            cell.commonTextField.inputView = agePickerView
            cell.commonTextField.inputAccessoryView = pickerViewToolBar
            agePickerView.tag = indexPath.section // picker data, event 분기
            case 2:
            cell.selectionStyle = .gray
            if indexPath.row < (userProfile.languageNames?.count ?? 0) {
                cell.configure(text: userProfile.languageNames?[indexPath.row], image: nil, section: indexPath.section) // "Add conversational
                cell.subLabel.text = userProfile.languageLevels?[indexPath.row]
                cell.selectionStyle = .none
            } else {
                cell.configure(text: nil, image: nil, section: indexPath.section)
            }
            cell.rightButton.addTarget(self, action: #selector(self.deleteButtonTapped(_:)), for: .touchUpInside)
            cell.rightButton.tag = indexPath.row
            case 3:
            cell.configure(text: userProfile.gender, image: nil, section: indexPath.section) // "Select gender"
            cell.commonTextField.inputView = genderPickerView
            cell.commonTextField.inputAccessoryView = pickerViewToolBar
            genderPickerView.tag = indexPath.section
            case 4:
            cell.selectionStyle = .gray
            cell.configure(text: userProfile.nationality, image: nil, section: indexPath.section) // "Select nationaltiy"
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
        print("Reload footer")
        // userName, age, lanages, gender, nationality
        switch section {
            case 0: footerView.configure(text: userProfile.userName ?? "", kind: section)
//            case 2: footerView.configure(text: "Your photos, name, age, languages will be public.\n\n\n", kind: section)
            case 4: footerView.configure(text: "Your photos, name, age, languages, nationality will be public. But gender is not shown publicly.", kind: section)
            default: return nil
        }
        return footerView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        switch section {
            case 0: return 18
            case 4: return 36
            default: return 0 
        }
    }
}

extension SetProfileViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print("Cell 선택")
        switch indexPath.section {
        case 2:
            if indexPath.row >= userProfile.languageNames?.count ?? 0 {
                DispatchQueue.main.async {
                    let LVC = LanguagesViewController()
                    LVC.delegate = self
                    LVC.userLangs = self.userProfile.languageNames
                    self.navigationController?.pushViewController(LVC, animated: true)
                }
            }
        case 4:
            DispatchQueue.main.async {
                let NVC = NationalityViewController()
                NVC.delegate = self
                self.navigationController?.pushViewController(NVC, animated: true)
            }
        default:
            break
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 48
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 22
    }
}

extension SetProfileViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        switch textField.tag {
        case 0:
            userProfile.userName = textField.text // cellForRow(at: IndexPath(row: 0, section: 0))
            guard let footerView = infoTableView.footerView(forSection: 0) as? SetProfileTableViewFooter else { return }
            footerView.nameCountLabelChanged(text: textField.text ?? "")
            guard let cell = infoTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? SetProfileTableViewCell else { return }
            cell.borderLayer?.backgroundColor = UIColor.placeholderText.cgColor
            print("userName = \(userProfile.userName!)")
        default: break
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("End edit")
//        if textField.tag == 0 {
//            infoTableView.reloadData()
////            guard let cell = infoTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? SetProfileTableViewCell else { return }
////            cell.borderLayer?.backgroundColor = UIColor.placeholderText.cgColor
//        }
//        switch textField.tag {
//        case 1, 3:
//            guard let cell = infoTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? SetProfileTableViewCell else { return }
//            cell.commonTextField.isEnabled = true
//            print("keyboard is Enable", cell.commonTextField.isEnabled)
//        default: break
//        }
        
//        textField.inputAccessoryView?.setNeedsUpdateConstraints()
////        textField.inputAccessoryView = nil // keyboard contraint 에러 제거를 위해 필요
//        infoTableView.reloadData() // 다시 inputaccessoryview 대입
//        infoTableView.isUserInteractionEnabled = true
//        self.view.endEditing(true)
        
//        switch textField.tag {
//        case 1: agePickerView.resignFirstResponder()
//        case 3: genderPickerView.resignFirstResponder() // pendingView.isHidden = true
//        default: break
//        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        guard let toolbar = textField.inputAccessoryView as? UIToolbar else { return }
        toolbar.items?[1].tag = textField.tag
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        switch textField.tag {
        case 0:  // 최대 글자수 이상을 입력한 이후에는 중간에 다른 글자를 추가할 수 없게끔 작동
            let currentText = textField.text ?? ""
            guard let stringRange = Range(range, in: currentText) else { return false }
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
            return updatedText.count <= maxNameCount
        default: return false
        }
    }
}

extension SetProfileViewController: ImagesProtocol {
    func imagesSend(profileImage: String) {
        self.profileImage = profileImage
    }
}


extension SetProfileViewController: LanguageProtocol {
    func languageSend(language: String, level: String) {
        userProfile.languageNames = userProfile.languageNames ?? []
        userProfile.languageLevels = userProfile.languageLevels ?? []
        userProfile.languageNames?.append(language)
        userProfile.languageLevels?.append(level)
        infoTableView.reloadData()
        print(userProfile.languageNames!, userProfile.languageLevels!)
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

extension SetProfileViewController: NationalityProtocol {
    func nationalitySend(nationality: String) {
        userProfile.nationality = nationality
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
