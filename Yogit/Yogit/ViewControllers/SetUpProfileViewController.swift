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

// click sign up >> post
//struct UserProfile {
//    var age: String?
//    var language1: String?
//    var level1: String?
//    var language2: String?
//    var level2: String?
//    var language3: String?
//    var level3: String?
//    var language4: String?
//    var level4: String?
//    var language5: String?
//    var level5: String?
//    var gender: String?
//    var nationality: String?
//    var name: String?
//}

//enum SectionData: Int {
//    case name = 0
//    case age
//    case languages
//    case gender
//    case nationality
//}

class SetUpProfileViewController: UIViewController, UITextFieldDelegate {
    
//    var userProfile = UserProfile()
    private var image: UIImage? = nil
    public var name: String? = nil
    private var age: String? = nil
    var languages: [String] = []
    var levels: [String] = []
    private var gender: String?
    private var nationality: String?
    private var langCount = 1
    
    let placeholderData = ["Name", "International age", "Add conversational language", "Select gender", "Select nationaltiy"]
    
    let genderData = ["Prefer not to say", "Male", "Female"]
    
    var ageData: [Int] = []
    
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
        toolBar.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 44)
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(profileContentScrollView)
        infoTableView.delegate = self
        infoTableView.dataSource = self
        agePickerView.delegate = self
        genderPickerView.delegate = self
        for i in 18...100 { ageData.append(i) }
        configureViewComponent()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        print("setup viewDidLayoutSubviews")
        profileContentScrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
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
    }
    
    private func configureViewComponent() {
        self.navigationItem.title = "Profile"
        view.backgroundColor = .systemBackground
    }
    
    // 각 셀 section 데이터에 넣어줄수 있음 (tag 이용)
    @objc func textFieldDidChange(_ textField: UITextField) {
        name = textField.text
        print("name = \(name!)")
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
//            return 48 // indexPath.row < languages.count ? 58 : 44
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
            // name
                return 1
            case 1:
            // age
                return 1
            case 2:
            // langages
//                if languages.count < 5 {
//                    langCount = languages.count + 1
//                } else {
//                    langCount = 5
//                }
                return languages.count < 5 ? languages.count + 1 : 5
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
        cell.profileTextField.tag = indexPath.section
        cell.selectionStyle = .none
        switch indexPath.section {
            case 0:
                //                cell.profileTextField.tag = indexPath.section
                cell.configure(text: name, profileSectionData: indexPath.section) // "Age"
                cell.profileTextField.delegate = self // action component assign 가능
                cell.profileTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
            case 1:
                cell.configure(text: age, profileSectionData: indexPath.section) // "International age"
                cell.profileTextField.inputView = agePickerView
                cell.profileTextField.inputAccessoryView = pickerToolBar
                agePickerView.tag = indexPath.section // picker data, event 분기
            case 2:
                if indexPath.row < languages.count {
                    cell.configure(text: languages[indexPath.row], profileSectionData: indexPath.section) // "Add conversational
                    cell.levelLabel.text = levels[indexPath.row]
                    cell.selectionStyle = .none
                } else {
                    cell.configure(text: nil, profileSectionData: indexPath.section)
                }
                cell.languageDeleteButton.addTarget(self, action: #selector(self.deleteButtonTapped(_:)), for: .touchUpInside)
                cell.languageDeleteButton.tag = indexPath.row
            case 3:
                cell.configure(text: gender, profileSectionData: indexPath.section) // "Select gender"
                cell.profileTextField.inputView = genderPickerView
                cell.profileTextField.inputAccessoryView = pickerToolBar
                // profileTextField.delegate = ?
                genderPickerView.tag = indexPath.section
            case 4: cell.configure(text: nationality, profileSectionData: indexPath.section) // "Select nationaltiy"
            default: fatalError("cellInSection default")
        }
        cell.layoutIfNeeded()
        cell.addBottomBorderWithColor(color: UIColor(rgb: 0xD9D9D9, alpha: 1.0), width: 0.3)
        print("cell update section = \(indexPath.section)")
        return cell
        
    }
    
    @objc func deleteButtonTapped(_ button: UIButton) {
        print("deleteButtonTapped")
        let deletedLang = languages.remove(at: button.tag)
        infoTableView.reloadData()
        print("deletedLang \(deletedLang)")
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: SetUpProfileTableViewHeader.identifier) as? SetUpProfileTableViewHeader else { return UITableViewHeaderFooterView() }
    
        // name, age, lanages, gender, nationality
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
            return "Your name, age, languages will be public.\n\n"
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
//        // name, age, lanages, gender, nationality
//        switch section {
//            case 2: footerView.configure(text: "Your name, age, languages will be public.")
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
            if indexPath.row >= languages.count {
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
        languages.append(language)
        levels.append(level)
        infoTableView.reloadData()
        print(languages, levels)
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
        case ProfileSectionData.age.rawValue: self.age = "\(self.ageData[row])"
        case ProfileSectionData.gender.rawValue: self.gender = "\(self.genderData[row])"
        default: fatalError("Pickerview tag error")
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 44
    }
}

extension SetUpProfileViewController: NationalityProtocol {
    func nationalitySend(nationality: String) {
        self.nationality = nationality
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
