//
//  GatheringSelectOptionViewController.swift
//  Yogit
//
//  Created by Junseo Park on 2022/11/12.
//

import UIKit

class GatheringBoardSelectDetailViewController: UIViewController {

    let step = 2.0
    var createBoardReq = CreateBoardReq() {
        didSet {
            print("Select Detail createBoardReq.categoryId \(createBoardReq)")
        }
    }
    
    var reportDate: Date? {
        didSet {
            print("report date = \(reportDate)")
        }
    }
    
    let stepHeaderView = StepHeaderView()
    
    private var memberNumberData: [Int] = []
    
//    private var dateData: [String] = []
    
    private let placeholderData = ["Number of member including host", "2022.08.31 14:00", "Gathering place"]
    
    private let numberPickerView: UIPickerView = {
        let pickerView = UIPickerView()
        return pickerView
    }()
    
    private lazy var datePicker: UIDatePicker = {
      let datePicker = UIDatePicker(frame: .zero)
//      datePicker.timeZone = TimeZone.current
        datePicker.datePickerMode = .dateAndTime
        datePicker.locale = Locale(identifier: "en-EN")
//        datePicker.addTarget(self, action: #selector(dateChanged(datePikcer:)), for: .valueChanged)
        datePicker.frame.size = CGSize(width: 0, height: 300)
        datePicker.preferredDatePickerStyle = .wheels
      return datePicker
    }()
    
//    private let dateTimePickerView: UIPickerView = {
//        let pickerView = UIPickerView()
//        return pickerView
//    }()
    
    private lazy var pickerViewToolBar: UIToolbar = {
        let toolBar = UIToolbar()
        toolBar.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 44)
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(donePressed))
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelPressed))
        cancelButton.tintColor = .systemGray
        doneButton.tintColor = UIColor(rgb: 0x3232FF, alpha: 1.0)
        toolBar.setItems([cancelButton, flexSpace, doneButton], animated: true)
        return toolBar
    }()
    
    private lazy var datePickerToolBar: UIToolbar = {
        let toolBar = UIToolbar()
        toolBar.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 44)
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dateDone))
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelPressed))
        cancelButton.tintColor = .systemGray
        doneButton.tintColor = UIColor(rgb: 0x3232FF, alpha: 1.0)
        toolBar.setItems([cancelButton, flexSpace, doneButton], animated: true)
        return toolBar
    }()
    
    private let imagesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.register(ProfileImagesCollectionViewCell.self, forCellWithReuseIdentifier: ProfileImagesCollectionViewCell.identifier)
        collectionView.backgroundColor = .systemBackground
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    private let selectDetailTableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.backgroundColor = .systemBackground
        tableView.sectionHeaderTopPadding = 30
        tableView.register(CommonTextFieldTableViewCell.self, forCellReuseIdentifier: CommonTextFieldTableViewCell.identifier)
        tableView.register(RequirementTableViewHeader.self, forHeaderFooterViewReuseIdentifier: RequirementTableViewHeader.identifier)
        return tableView
    }()
    
    private lazy var nextButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(rgb: 0x3232FF, alpha: 1.0)
        button.setTitle("Next", for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 8
        button.isEnabled = false
        button.backgroundColor = .placeholderText
        button.addTarget(self, action: #selector(self.nextButtonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(stepHeaderView)
        view.addSubview(imagesCollectionView)
        view.addSubview(selectDetailTableView)
        view.addSubview(nextButton)
        imagesCollectionView.delegate = self
        imagesCollectionView.dataSource = self
        selectDetailTableView.delegate = self
        selectDetailTableView.dataSource = self
        numberPickerView.delegate = self
//        dateTimePickerView.delegate = self
        for i in 3...30 { memberNumberData.append(i) }
        configureViewComponent()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        stepHeaderView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.right.equalToSuperview()
            make.height.equalTo(30)
        }
        selectDetailTableView.snp.makeConstraints { make in
            make.top.equalTo(stepHeaderView.snp.bottom).offset(0)
            make.leading.trailing.bottom.equalToSuperview()
        }
        nextButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(view.snp.bottom).inset(30)
            make.height.equalTo(50)
        }
    }
    
    private func configureViewComponent() {
//        self.navigationItem.title = "Profile"
        view.backgroundColor = .systemBackground
//        self.configureDatePicker()
        stepHeaderView.step = self.step
        stepHeaderView.titleLabel.text = "Setup detail"
    }
    
//    private func configureDatePicker() {
//        let datePicker = UIDatePicker()
//        datePicker.datePickerMode = .dateAndTime
//        datePicker.locale = Locale(identifier: "ko-KR")
//        datePicker.addTarget(self, action: #selector(dateChange(datePikcer:)), for: .)
//        datePicker.frame.size = CGSize(width: 0, height: 300)
//        datePicker.preferredDatePickerStyle = .wheels
////        dateTextField.inputView = datePicker
////        dateTextField.text = formatDate(date: Date())
////        reportDate = Date()
//    }
    
    private func formatDate(date: Date) -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY.MM.dd HH:mm"
        return formatter.string(from: date)
    }
    
//    @objc func dateDoned(datePikcer: UIDatePicker){
////        dateTextField.text = formatDate(date: datePikcer.date) // 보여주는 데이터
//        print("dateChange")
//        createBoardReq.date = formatDate(date: datePikcer.date)
//        self.reportDate = datePikcer.date // 데이터 저장
//        selectDetailTableView.reloadData()
//    }
    
    @objc func dateDone(_ sender: UIButton) {
//        datePicker.date
        createBoardReq.date = formatDate(date: self.datePicker.date)
        print(createBoardReq.date)
        selectDetailTableView.reloadData()
    }
    
    @objc func nextButtonTapped(_ sender: UIButton) {
        DispatchQueue.main.async {
            let GBTDVC = GatheringBoardTextDetailViewController()
            GBTDVC.createBoardReq = self.createBoardReq
            self.navigationController?.pushViewController(GBTDVC, animated: true)
        }
    }
    
    @objc func donePressed(_ sender: UIButton) {
        selectDetailTableView.reloadData()
        self.view.endEditing(true)
    }
    
    @objc func cancelPressed(_ sender: UIButton) {
        self.view.endEditing(true)
    }
}

extension GatheringBoardSelectDetailViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 48

    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 22
    }
    
    // Reporting the number of sections and rows in the table.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 1
        case 1: return 1
        case 2: return 1
        default: fatalError("GatheringBoardSelectDetailVC out of section")
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CommonTextFieldTableViewCell.identifier, for: indexPath) as? CommonTextFieldTableViewCell else { return UITableViewCell() }
        cell.commonTextField.tag = indexPath.section
        cell.commonTextField.placeholder = placeholderData[indexPath.section]
        cell.selectionStyle = .none
        switch indexPath.section {
            case 0:
            cell.commonTextField.inputView = numberPickerView
            cell.commonTextField.inputAccessoryView = pickerViewToolBar
            cell.configure(text: createBoardReq.totalMember == nil ? nil : "\(createBoardReq.totalMember!)", image: nil, section: indexPath.section, kind: Kind.boardSelectDetail)
            case 1:
//            cell.commonTextField.delegate = self
            cell.commonTextField.inputView = datePicker
            cell.commonTextField.inputAccessoryView = datePickerToolBar
            cell.configure(text: createBoardReq.date, image: nil, section: indexPath.section, kind: Kind.boardSelectDetail)
            case 2:
            cell.selectionStyle = .blue
            cell.configure(text: createBoardReq.address, image: nil, section: indexPath.section, kind: Kind.boardSelectDetail)
//            cell.subLabel.text = userProfile.languageLevels?[indexPath.row]
            default: fatalError("Out of Setup Profile table view section")
        }
        cell.layoutIfNeeded()
        cell.addBottomBorderWithColor(color: .placeholderText, width: 1)
        print("cell update section = \(indexPath.section)")
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: RequirementTableViewHeader.identifier) as? RequirementTableViewHeader else { return UITableViewHeaderFooterView() }
        
        // userName, age, lanages, gender, nationality
        switch section {
        case 0: headerView.configure(text: "The number of people in a gathering")
        case 1: headerView.configure(text: "Date & Time")
        case 2: headerView.configure(text: "Location")
        default: fatalError("Out of header section index")
        }
        return headerView
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

extension GatheringBoardSelectDetailViewController: UITableViewDelegate {
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//        print("Cell 선택")
//        switch indexPath.section {
//        case 2:
//            DispatchQueue.main.async {
//                let GBTDVC = GatheringBoardTextDetailViewController()
//                GBTDVC.delegate = self
//                self.navigationController?.pushViewController(GBTDVC, animated: true)
//            }
//        default:
//            break
//        }
//    }
}

extension GatheringBoardSelectDetailViewController: UICollectionViewDelegate {
    
}

extension GatheringBoardSelectDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (createBoardReq.images?.count ?? 0) < 5 ? ((createBoardReq.images?.count ?? 0) + 1) : 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileImagesCollectionViewCell.identifier, for: indexPath) as? ProfileImagesCollectionViewCell else    {
            fatalError()
        }
//        cell.configure(with: viewModels[indexPath.row])
        return cell
    }
}

//extension GatheringBoardSelectDetailViewController: UITextFieldDelegate {
//    func textFieldDidChangeSelection(_ textField: UITextField) {
////        userProfile.userName = textField.text
////        print("userName = \(userProfile.userName!)")
//        switch textField.tag {
//        case 0:
//            userProfile.userName = textField.text
//            print("userName = \(userProfile.userName!)")
//        default: break
//        }
//    }
//
////    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
////        textField.resignFirstResponder()
////        return true
////    }
//
////    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
////        switch textField.tag {
////        case 0: return true
////        default: return false
////        }
////    }
//
////    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
////        switch textField.tag {
////        case 0: return true
////        default: return false
////        }
////    }
////
////    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
////        guard let text = textField.text else { return false }
////
////        // 최대 글자수 이상을 입력한 이후에는 중간에 다른 글자를 추가할 수 없게끔 작동
////        if text.count >= maxLength && range.length == 0 && range.location < maxLength {
////            return false
////        }
////
////        return true
////    }
//}

extension GatheringBoardSelectDetailViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case BoardSelectDetailSectionData.numberOfMember.rawValue:
            return self.memberNumberData.count
//        case BoardSelectDetailSectionData.dateTime.rawValue:
//            switch <#value#> {
//            case <#pattern#>:
//                <#code#>
//            default:
//                <#code#>
//            }
//            return self.genderData.count
        default:
            fatalError("일치하는 피커뷰 없다")
        }
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag {
        case BoardSelectDetailSectionData.numberOfMember.rawValue:
            return "\(self.memberNumberData[row])"
//        case BoardSelectDetailSectionData.dateTime.rawValue:
//            switch <#value#> {
//            case <#pattern#>:
//                <#code#>
//            default:
//                <#code#>
//            }
//            return self.genderData.count
        default: fatalError("Pickerview tag error")
        }
    }
}
//
// textfield 터치시 어디에서 터치 했는지 알아야함

extension GatheringBoardSelectDetailViewController: UIPickerViewDelegate {

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView.tag {
        case BoardSelectDetailSectionData.numberOfMember.rawValue:
            return createBoardReq.totalMember = self.memberNumberData[row]
//        case BoardSelectDetailSectionData.dateTime.rawValue:
//            switch <#value#> {
//            case <#pattern#>:
//                <#code#>
//            default:
//                <#code#>
//            }
//            return self.genderData.count
        default: fatalError("Pickerview tag error")
        }
    }

    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 44
    }
}




//extension GatheringBoardSelectDetailViewController: NationalityProtocol {
//    func nationalitySend(nationality: String) {
//        userProfile.nationality = nationality
//        infoTableView.reloadData()
//    }
//}

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

