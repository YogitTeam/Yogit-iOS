//
//  ProfileViewController.swift
//  Yogit
//
//  Created by Junseo Park on 2022/09/11.
//

// 셀업데이트 하면서 모든값 저장
// 피커뷰 donpress 누르면 값 저장 후 reload
// 피커뷰 나눠야댐 >> 누른 textfield 에따라 피커뷰 데이터 종류 구분

import UIKit
import Alamofire

//class UserProfile: Codable {
//    var gender: String?
//    var languageNames: [String]?
//    var languageLevels: [String]?
//    var nationality: String?
//    var userAge: Int?
//    var userId: Int64?
//    var userName: String?
//}

class SetUpProfileViewController: UIViewController, UITextFieldDelegate {
   
//    var userProfile = UserProfile()
    private var image: UIImage? = nil
//    public var userName: String? = nil
//    private var userAge: Int? = nil
//    private var languageNames: [String] = []
//    private var languageLevels: [String] = []
//    private var gender: String?
//    private var nationality: String?
    private var userProfile = UserProfile()
//    private var userProfile = UserProfile(from: nil)
    
    private let genderData = ["Prefer not to say", "Male", "Female"]
    
    private var ageData: [Int] = []
    
    private lazy var rightButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Sign Up", style: .plain, target: self, action: #selector(buttonPressed(_:)))
        button.tintColor =  UIColor(rgb: 0x3232FF, alpha: 1.0)
        return button
    }()
    
    private let agePickerView: UIPickerView = {
        let pickerView = UIPickerView()
        return pickerView
    }()
    
    private let genderPickerView: UIPickerView = {
        let pickerView = UIPickerView()
        return pickerView
    }()
    
    private lazy var pickerToolBar: UIToolbar = {
        let toolBar = UIToolbar()
        toolBar.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 44)
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(donePressed))
        toolBar.setItems([flexSpace, doneButton], animated: true)
        return toolBar
    }()

    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .placeholderText
        imageView.layer.cornerRadius = 55
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    private let profileImageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16, weight: UIFont.Weight.regular)
        label.textColor = UIColor(rgb: 0x3232FF, alpha: 1.0)
        label.text = "Select photos"
        
        // Label frame size to fit as text of label
//        label.sizeToFit()
        label.numberOfLines = 1
//        label.adjustsFontSizeToFitWidth =true

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
        return view
    }()
    
    private let infoTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.isScrollEnabled = false
        tableView.separatorStyle = .none
        tableView.backgroundColor = .systemBackground
        tableView.sectionHeaderTopPadding = 16
        tableView.register(SetUpProfileTableViewCell.self, forCellReuseIdentifier: SetUpProfileTableViewCell.identifier)
        tableView.register(SetUpProfileTableViewHeader.self, forHeaderFooterViewReuseIdentifier: SetUpProfileTableViewHeader.identifier)
//        tableView.register(SetUpProfileTableViewFooter.self, forHeaderFooterViewReuseIdentifier: SetUpProfileTableViewFooter.identifier)
        return tableView
    }()
    
    private lazy var profileContentScrollView: UIScrollView = {
       let scrollView = UIScrollView()
        scrollView.backgroundColor = .systemBackground
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        [self.profileImageContentView, self.infoTableView].forEach { scrollView.addSubview($0) }
        return scrollView
    }()
    
    private var hasAllValue: Bool {
        let isTrue = (userProfile.userId != nil) && (userProfile.languageNames?.count ?? 0 > 0) && (userProfile.languageLevels?.count ?? 0 > 0) && (userProfile.userName != nil) && (userProfile.userId != nil) && (userProfile.userAge != nil) && (userProfile.gender != nil) && (userProfile.nationality != nil)
        return isTrue
    }
    
    
    // viewload 시 get 요청
    // get 요청시 object에 적재
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(profileContentScrollView)
        infoTableView.delegate = self
        infoTableView.dataSource = self
        agePickerView.delegate = self
        agePickerView.dataSource = self
        genderPickerView.delegate = self
        genderPickerView.dataSource = self
        for i in 18...60 { ageData.append(i) }
        configureViewComponent()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        print("setup viewDidLayoutSubviews")
        profileContentScrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            
//            make.top.leading.trailing.bottom.equalToSuperview()
        }
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
        profileImageContentView.snp.makeConstraints { make in
            make.height.equalTo(180)
            make.top.equalToSuperview()
            make.width.equalToSuperview()
        }
        infoTableView.snp.makeConstraints { make in
            make.height.equalTo(850)
//            make.height.equalTo(infoTableView.contentSize.height)
            make.top.equalTo(profileImageContentView.snp.bottom)
            make.width.equalToSuperview()
            make.bottom.equalToSuperview()
            
//            make.top.equalTo(profileImageContentView.snp.bottom)
//            make.width.equalToSuperview()
//
//            make.leading.trailing.bottom.equalToSuperview()
//            profileContentScrollView.contentLayoutGuide.s
//            make.width.equalTo(profileContentScrollView.frameLayoutGuide)
        }
        
//        agePickerView.snp.makeConstraints { make in
//            make.leading.trailing.bottom.equalTo(view)
//            make.height.equalTo(300)
//        }
//        genderPickerView.snp.makeConstraints { make in
//            make.leading.trailing.bottom.equalTo(view)
//        }
//        infoTableView.constant = infoTableView.contentSize.height
        
    }
    
    private func configureViewComponent() {
        self.navigationItem.title = "Profile"
        self.navigationItem.rightBarButtonItem = self.rightButton
        view.backgroundColor = .systemBackground
    }

    func textFieldDidChangeSelection(_ textField: UITextField) {
        userProfile.userName = textField.text
        print("userName = \(userProfile.userName!)")
//        userName = textField.text
//        print("userName = \(userName!)")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    @objc private func buttonPressed(_ sender: Any) {
        // 값 다 있는지 확인 하고 없으면 alert창
        //
        userProfile.userId = 1
        print(userProfile)
        
        if hasAllValue == false {
            print("Not has all value")
            let alert = UIAlertController(title: "Please input requirement value", message: "Input all requirement value", preferredStyle: UIAlertController.Style.alert)
            let okAction = UIAlertAction(title: "OK", style: .default)
            alert.addAction(okAction)
            present(alert, animated: false, completion: nil)
            // present alert
            return
        }
        
        let url = "https://www.yogit.world/users/essential-profile"
        
        let parameters: [String: Any] = [
            "gender": userProfile.gender!,
            "languageLevels": userProfile.languageLevels!,
            "languageNames": userProfile.languageNames!,
            "nationality": userProfile.nationality!,
            "userAge": userProfile.userAge!,
            "userId": userProfile.userId!,
            "userName": userProfile.userName!
        ]
        
        AF.upload(multipartFormData: { multipartFormData in
            for (key, value) in parameters {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key)
            }
        }, to: url, method: .patch)
        .validate(statusCode: 200..<500)
        .responseData { response in
            switch response.result {
            case .success:
                debugPrint(response)
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
                }
            case let .failure(error):
                print(error)
            }
        }
    }
    
    @objc func profileImageViewTapped(_ sender: UITapGestureRecognizer) {
        DispatchQueue.main.async {
            let PICV = ProfileImagesViewController()
            PICV.delegate = self
            self.navigationController?.pushViewController(PICV, animated: true)
        }
    }
    
    @objc func donePressed(_ sender: UIButton) {
        infoTableView.reloadData()
        self.view.endEditing(true)
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 48
//        switch indexPath.section {
//        case 2:
//            return 48 // indexPath.row < languageNames.count ? 58 : 44
//        default:
//            return 48
//        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 24
    }
    
    
//    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        switch section {
//        case 2, 4:
//            return 50
//        default:
//            return 0
//        }
//    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension SetUpProfileViewController: UITableViewDataSource {
    // Reporting the number of sections and rows in the table.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
            case 0:
            // userName
                return 1
            case 1:
            // age
                return 1
            case 2:
            return (userProfile.languageNames?.count ?? 0) < 5 ? ((userProfile.languageNames?.count ?? 0) + 1) : 5// languageNames.count < 5 ? languageNames.count + 1 : 5
            case 3:
            // gender
                return 1
            case 4:
            // nationality
                return 1
            default:
                return 0
        }
    }
    
    // Providing cells for each row of the table.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SetUpProfileTableViewCell.identifier, for: indexPath) as? SetUpProfileTableViewCell else { return UITableViewCell() }
        cell.profileTextField.delegate = nil
//        cell.profileTextField.tag = indexPath.section
        cell.selectionStyle = .none
        switch indexPath.section {
            case 0:
            cell.configure(text: userProfile.userName, profileSectionData: indexPath.section) // "Age"
                cell.profileTextField.delegate = self // action component assign 가능
            case 1:
                cell.configure(text: userProfile.userAge == nil ? nil : "\(userProfile.userAge!)", profileSectionData: indexPath.section) // "International age"
                cell.profileTextField.inputView = agePickerView
                cell.profileTextField.inputAccessoryView = pickerToolBar
                agePickerView.tag = indexPath.section // picker data, event 분기
            case 2:
                if indexPath.row < (userProfile.languageNames?.count ?? 0) {
                    cell.configure(text: userProfile.languageNames?[indexPath.row], profileSectionData: indexPath.section) // "Add conversational
                    cell.levelLabel.text = userProfile.languageLevels?[indexPath.row]
                    cell.selectionStyle = .none
                } else {
                    cell.configure(text: nil, profileSectionData: indexPath.section)
                }
                cell.languageDeleteButton.addTarget(self, action: #selector(self.deleteButtonTapped(_:)), for: .touchUpInside)
                cell.languageDeleteButton.tag = indexPath.row
            case 3:
            cell.configure(text: userProfile.gender, profileSectionData: indexPath.section) // "Select gender"
                cell.profileTextField.inputView = genderPickerView
                cell.profileTextField.inputAccessoryView = pickerToolBar
                // profileTextField.delegate = ?
                genderPickerView.tag = indexPath.section
            case 4: cell.configure(text: userProfile.nationality, profileSectionData: indexPath.section) // "Select nationaltiy"
            default: fatalError("cellInSection default")
        }
        cell.layoutIfNeeded()
        cell.addBottomBorderWithColor(color: UIColor(rgb: 0xD9D9D9, alpha: 1.0), width: 0.3)
        print("cell update section = \(indexPath.section)")
        return cell
        
    }
    
    @objc func deleteButtonTapped(_ button: UIButton) {
        print("deleteButtonTapped")
        let deletedLanguage = userProfile.languageNames?.remove(at: button.tag)
        let deletedLevel = userProfile.languageLevels?.remove(at: button.tag)
        infoTableView.reloadData()
        print("deletedLangInfo \(deletedLanguage!) \(deletedLevel!)")
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: SetUpProfileTableViewHeader.identifier) as? SetUpProfileTableViewHeader else { return UITableViewHeaderFooterView() }
    
        // userName, age, lanages, gender, nationality
        switch section {
            case 0: headerView.configure(text: "Name")
            case 1: headerView.configure(text: "Age")
            case 2: headerView.configure(text: "Languages")
            case 3: headerView.configure(text: "Gender")
            case 4: headerView.configure(text: "Nationality")
            default: fatalError("Out of header section index")
        }
        return headerView
    }

    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        switch section {
        case 2:
            return "Your userName, age, languageNames will be public.\n\n"
        case 4:
            return "Gender, nationality help improve recommendations but are not shown publicly."
        default:
            return nil
        }
    }
    
//    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        guard let footerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: SetUpProfileTableViewFooter.identifier) as? SetUpProfileTableViewFooter else { return UITableViewHeaderFooterView() }
//
//
//        // userName, age, lanages, gender, nationality
//        switch section {
//            case 2: footerView.configure(text: "Your userName, age, languageNames will be public.")
//            case 4: footerView.configure(text: "Gender, nationality help improve recommendations but are not shown publicly.")
//            default: return nil // footerView.configure(text: "")
//        }
//
////        footerView.layoutIfNeeded() // layout 로딩 (동적이므로 다름)
//        return footerView
//    }
    
  
//    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 100
//    }
    // static size
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        switch indexPath.section {
//            case 0: return 100  // image
//            case 1: return 200
//            default: fatalError("FirstSetUpTableVeiw section 0: indexPath row error")
//        }
//
//        return tableView.rowHeight
//    }


}

extension SetUpProfileViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print("Cell 선택")
        switch indexPath.section {
        case 2:
            if indexPath.row >= userProfile.languageNames?.count ?? 0 {
                DispatchQueue.main.async {
                    let LVC = LanguagesViewController()
                    LVC.delegate = self
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
}

extension SetUpProfileViewController: ImagesProtocol {
    func imagesSend(profileImage: UIImage?) {
        image = profileImage
        profileImageView.image = image
    }
}


extension SetUpProfileViewController: LanguageProtocol {
    func languageSend(language: String, level: String) {
        userProfile.languageNames?.append(language)
        userProfile.languageLevels?.append(level)
        infoTableView.reloadData()
        print(userProfile.languageNames!, userProfile.languageLevels!)
    }
}

extension SetUpProfileViewController: UIPickerViewDataSource {
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
extension SetUpProfileViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView.tag {
        case ProfileSectionData.age.rawValue: userProfile.userAge = self.ageData[row]
        case ProfileSectionData.gender.rawValue: userProfile.gender = "\(self.genderData[row])"
        default: fatalError("Pickerview tag error")
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 44
    }
}

extension SetUpProfileViewController: NationalityProtocol {
    func nationalitySend(nationality: String) {
        userProfile.nationality = nationality
        infoTableView.reloadData()
    }
}

//extension UIScrollView {
//   func updateContentView() {
//      contentSize.height = subviews.sorted(by: { $0.frame.maxY < $1.frame.maxY }).last?.frame.maxY ?? contentSize.height
//   }
//}

//extension UIScrollView {
//    func updateContentSize() {
//        let unionCalculatedTotalRect = recursiveUnionInDepthFor(view: self)
//
//        // 계산된 크기로 컨텐츠 사이즈 설정
//        self.contentSize = CGSize(width: self.frame.width, height: unionCalculatedTotalRect.height+50)
//    }
//
//    private func recursiveUnionInDepthFor(view: UIView) -> CGRect {
//        var totalRect: CGRect = .zero
//
//        // 모든 자식 View의 컨트롤의 크기를 재귀적으로 호출하며 최종 영역의 크기를 설정
//        for subView in view.subviews {
//            totalRect = totalRect.union(recursiveUnionInDepthFor(view: subView))
//        }
//
//        // 최종 계산 영역의 크기를 반환
//        return totalRect.union(view.frame)
//    }
//}
