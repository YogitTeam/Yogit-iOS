//
//  MyClubViewController.swift
//  Yogit
//
//  Created by Junseo Park on 2022/12/12.
//

import UIKit

class MyClubViewController: UIViewController {

    private let placeholderData = ["직접입력", "지도에서 검색 및 설정"]
    var borderLayer: [CALayer?] = [nil, nil, nil] // cell bottom border
//    var directInput: String?
//    var mapInput: String?
//    var mapSubInput: String?
    
    lazy var segmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["firstView", "secondView"])
        control.addTarget(self, action: #selector(didChangeValue(_:)), for: .valueChanged)
        control.selectedSegmentIndex = 0
//        control.backgroundColor = UIColor(rgb: 0x3232FF, alpha: 1.0)
        control.selectedSegmentTintColor = UIColor(rgb: 0x3232FF, alpha: 1.0)
        control.layer.cornerRadius = 30
        control.layer.masksToBounds = true
//        control.clipsToBounds = true
//        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()
    
    let firstView: UIView = {
        let view = UIView()
        view.backgroundColor = .green
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = false
        return view
    }()
    
    let secondView: UIView = {
        let view = UIView()
        view.backgroundColor = .yellow
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()
    
//    var shouldHideFirstView: Bool? {
//       didSet {
//         guard let shouldHideFirstView = self.shouldHideFirstView else { return }
//         self.firstView.isHidden = shouldHideFirstView
//         self.secondView.isHidden = !self.firstView.isHidden
//       }
//     }
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Where are you going to meetup?"
        label.font = UIFont.systemFont(ofSize: 24, weight: UIFont.Weight.bold)
        label.sizeToFit()
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    let directInputTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.regular)
        textField.isEnabled = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.leftView = nil
        textField.placeholder = "Direct Input"
//        textField.layer.borderWidth = 1
//        textField.layer.borderColor = UIColor.systemRed.cgColor
        return textField
    }()
    
    private lazy var mapInputTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.regular)
//        textField.isEnabled = false
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.tintColor = .clear
        textField.isEnabled = true
        textField.addRightImage(image: UIImage(named: "push"))
        textField.placeholder = "Search address in map"
        
//        textField.addTarget(self, action: #selector(self.mapInputButtonTapped(_:)), for: .touchUpInside)
//        textField.layer.borderWidth = 1
//        textField.layer.borderColor = UIColor.systemRed.cgColor
        return textField
    }()
    
    let mapSubInputTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.regular)
        textField.isHidden = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.leftView = nil
        textField.isEnabled = true
        textField.placeholder = "Describe detail"
//        textField.layer.borderWidth = 1
//        textField.layer.borderColor = UIColor.systemRed.cgColor
        return textField
    }()

//    private let inputAddressTableView: UITableView = {
//        let tableView = UITableView()
////        let tableView = UITableView(frame: .zero, style: .grouped)
//        tableView.separatorStyle = .none
//        tableView.backgroundColor = .systemBackground
//        tableView.isScrollEnabled = false
//        tableView.sectionHeaderTopPadding = 20
//        tableView.register(MyTextFieldTableViewCell.self, forCellReuseIdentifier: MyTextFieldTableViewCell.identifier)
//        return tableView
//    }()

    private lazy var doneButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(rgb: 0x3232FF, alpha: 1.0)
        button.setTitle("Done", for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 8
        button.isEnabled = false
        button.backgroundColor = .placeholderText
        button.addTarget(self, action: #selector(self.doneButtonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.didChangeValue(segment: self.segmentedControl)
        self.view.addSubview(segmentedControl)
        self.view.addSubview(firstView)
        self.view.addSubview(secondView)
        
//        self.view.addSubview(titleLabel)
//        self.view.addSubview(directInputTextField)
//        self.view.addSubview(mapInputTextField)
//        self.view.addSubview(mapSubInputTextField)
//        self.view.addSubview(doneButton)
//        directInputTextField.delegate = self
//        mapInputTextField.delegate = self
//        mapSubInputTextField.delegate = self
//        directInputTextField.tag = 0
//        mapInputTextField.tag = 1
//        mapSubInputTextField.tag = 2
        
//        view.addSubview(inputAddressTableView)
//        view.addSubview(doneButton)
//        inputAddressTableView.delegate = self
//        inputAddressTableView.dataSource = self
        configureViewComponent()
        // Do any additional setup after loading the view.
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        segmentedControl.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        firstView.snp.makeConstraints { make in
            make.top.equalTo(segmentedControl.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
        secondView.snp.makeConstraints { make in
            make.top.equalTo(segmentedControl.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
//        titleLabel.snp.makeConstraints { make in
//            make.top.equalTo(view.safeAreaLayoutGuide)
//            make.leading.trailing.equalToSuperview().inset(20)
//        }
//        directInputTextField.snp.makeConstraints { make in
//            make.top.equalTo(titleLabel.snp.bottom).offset(20)
//            make.leading.trailing.equalToSuperview().inset(20)
//            make.height.equalTo(50)
//        }
//        mapInputTextField.snp.makeConstraints { make in
//            make.top.equalTo(directInputTextField.snp.bottom).offset(50)
//            make.leading.trailing.equalToSuperview().inset(20)
//            make.height.equalTo(50)
//        }
//        mapSubInputTextField.snp.makeConstraints { make in
//            make.top.equalTo(mapInputTextField.snp.bottom).offset(16)
//            make.leading.trailing.equalToSuperview().inset(20)
//            make.height.equalTo(50)
//        }
//
////        inputAddressTableView.snp.makeConstraints { make in
////            make.top.equalTo(titleLabel.snp.bottom)
////            make.leading.trailing.bottom.equalToSuperview()
////        }
//        doneButton.snp.makeConstraints { make in
//            make.leading.trailing.equalToSuperview().inset(20)
//            make.bottom.equalTo(view.snp.bottom).inset(30)
//            make.height.equalTo(50)
//        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        self.borderLayer[0] = directInputTextField.addBottomBorderWithColor(color: .placeholderText, width: 1)
//        self.borderLayer[1] = mapInputTextField.addBottomBorderWithColor(color: .placeholderText, width: 1)
//        self.borderLayer[2] = mapSubInputTextField.addBottomBorderWithColor(color: .placeholderText, width: 1)
    }

    private func configureViewComponent() {
        view.backgroundColor = .systemBackground
    }
    
    @objc private func didChangeValue(_ sender: UISegmentedControl) {
        print("selectedSegmentIndex \(sender.selectedSegmentIndex)")
        self.firstView.isHidden = !self.firstView.isHidden
        self.secondView.isHidden = !self.secondView.isHidden
//        if sender.selectedSegmentIndex == 0 {
//            self.firstView.isHidden = false
//            self.secondView.isHidden =
//        } else {
//            self.secondView.isHidden =
//        }
//       self.shouldHideFirstView = sender.selectedSegmentIndex != 0
     }
    
    // 1번째 텍스트 필드 선택시 <<>> 2, 3번째 텍스트 필드 삭제
    @objc func valueChanged(_ textField: UITextField){
//        switch textField.tag {
//            case TextFieldData.directTextField.rawValue:
//            directInput = textField.text
//            case TextFieldData.mapAddress.rawValue:
//            mapInput = textField.text
//            case TextFieldData.mapAddDetailAdress.rawValue:
//            mapSubInput = textField.text
//            default: break
//        }
        
    }
    
    // 값 들어오면 줄 색바뀜
    // 1. 텍스트 필드 입력 시작시, 2,3번값있으면 삭제
    // 2. 텍스트 필드 못입력하게한다. clear, 대체키 함수, 다음 화면에서 변수에 전달하면 변수를 텍스트필드값에 저장하고 1번 텍스트 필드값 있으면 삭제
    // 3. 텍스트 필드 입력, 2번값 있어야 hidden false
    

    @objc func doneButtonTapped(_ sender: UIButton) {
        // pop
        //        DispatchQueue.main.async {
//            let GBTDVC = GatheringBoardTextDetailViewController()
//            GBTDVC.createBoardReq = self.createBoardReq
//            self.navigationController?.pushViewController(GBTDVC, animated: true)
//        }
    }
    
    @objc func mapInputButtonTapped(_ sender: UIButton) {
        print("1")
        // pop
        //        DispatchQueue.main.async {
//            let GBTDVC = GatheringBoardTextDetailViewController()
//            GBTDVC.createBoardReq = self.createBoardReq
//            self.navigationController?.pushViewController(GBTDVC, animated: true)
//        }
    }

}

//extension UITextField {
//    func addBottomBorderWithColor(color: UIColor, width: CGFloat) -> CALayer {
//        let border = CALayer()
//        border.backgroundColor = color.cgColor
////        border.frame = CGRect(x: bounds.minX,
////                              y: bounds.maxX - width,
////                              width: bounds.width,
////                              height: width)
//        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width: self.frame.size.width, height:width)
//        self.layer.addSublayer(border)
//        return border
//    }
//}

extension MyClubViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField.tag {
        case 0:
            if mapInputTextField.text != nil {
                mapInputTextField.text = nil
                mapSubInputTextField.text = nil
            }
            borderLayer[0]?.backgroundColor = UIColor(rgb: 0x3232FF, alpha: 1.0).cgColor
        case 1: // 값 들어오면 0번 text 삭제
           print("dfdf") // 화면 이동
//            print("tap 1")
//            if directInputTextField.text != nil {
//               directInputTextField.text = nil
//            }
//            borderLayer[1].backgroundColor = UIColor(rgb: 0x3232FF, alpha: 1.0).cgColor
//        case 2: // 1번 값 있어야 나타남
//            if mapInputTextField.text != nil {
//                mapInputTextField.text = nil
//                mapSubInputTextField.text = nil
//            }
//            borderLayer[2].backgroundColor = UIColor(rgb: 0x3232FF, alpha: 1.0).cgColor
            default: break
        }
    }
    
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
//    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
//        switch textField.tag {
//        case 0: return true
//        default: return false
//        }
//    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        switch textField.tag {
        case 1: return false
        default: return true
        }
    }
    
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        guard let text = textField.text else { return false }
//
//        // 최대 글자수 이상을 입력한 이후에는 중간에 다른 글자를 추가할 수 없게끔 작동
//        if text.count >= maxLength && range.length == 0 && range.location < maxLength {
//            return false
//        }
//
//        return true
//    }
}

//extension MyClubViewController: UITableViewDataSource {
//
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 2
//    }
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 48
//
//    }
//
//    // Reporting the number of sections and rows in the table.
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        switch section {
//        case 0: return 1  // 직접 입력
//        case 1: return 2 // 지도에서 찾은 값, 상세 입력
//        default: fatalError("MyClubViewController out of section")
//        }
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: MyTextFieldTableViewCell.identifier, for: indexPath) as? MyTextFieldTableViewCell else { return UITableViewCell() }
//        cell.commonTextField.tag = indexPath.section
//        cell.commonTextField.placeholder = placeholderData[indexPath.section]
//        cell.commonTextField.delegate = self
//        switch indexPath.section {
//        case 0:
//            cell.commonTextField.isEnabled = true
//        case 1:
//            switch indexPath.row {
//            case 0:
//                // 지도로 화면 이동
//                cell.commonTextField.isEnabled = false
//            default:
//                cell.commonTextField.isEnabled = true // 텍스트 입력
//                break
//            }
//        default:
//            <#code#>
//        }
//        cell.selectionStyle = .none
//        cell.layoutIfNeeded()
//        cell.addBottomBorderWithColor(color: .placeholderText, width: 1)
//        print("cell update row = \(indexPath.row)")
//        return cell
//
//    }
//}
//
//extension MyClubViewController: UITableViewDelegate {
//    // 지도 화면 으로 이동 인터렉션
//
////    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
////        tableView.deselectRow(at: indexPath, animated: true)
////        print("Cell 선택")
////        switch indexPath.section {
////        case 2:
////            DispatchQueue.main.async {
////                let GBTDVC = GatheringBoardTextDetailViewController()
////                GBTDVC.delegate = self
////                self.navigationController?.pushViewController(GBTDVC, animated: true)
////            }
////        default:
////            break
////        }
////    }
//}
//
//extension MyClubViewController: UICollectionViewDelegate {
////    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
////        collectionView.deselectItem(at: indexPath, animated: true)
////        print("Tapped collectionview")
//////        let viewModel = viewModels[indexPath.row]
//////        delegate?.collectionTableViewTapIteom(with: viewModel)
////    }
//
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        collectionView.deselectItem(at: indexPath, animated: true)
//        print("Tapped gatherging board collectionview image")
//        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
//        alert.view.tintColor = UIColor.label
//        let cancel = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
//
//        if indexPath.row < images.count {
//            let delete = UIAlertAction(title: "Delete", style: .destructive) { (action) in self.deleteImage(indexPath.row)}
//            alert.addAction(delete)
//            alert.addAction(cancel)
//        } else {
//            let library = UIAlertAction(title: "Upload photo", style: .default) { (action) in self.openLibrary()}
//            let camera = UIAlertAction(title: "Take photo", style: .default) { (action) in self.openCamera()}
//            alert.addAction(library)
//            alert.addAction(camera)
//            alert.addAction(cancel)
//        }
//        DispatchQueue.main.async {
//            self.present(alert, animated: true, completion: nil)
//        }
//    }
//
//}
//
//extension MyClubViewController: UICollectionViewDataSource {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
////        return 10
//        return images.count < 5 ? (images.count + 1) : 5
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
////        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyImagesCollectionViewCell.identifier, for: indexPath)
//        print("ProfileImages indexpath update \(indexPath)")
//        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier:  MyImagesCollectionViewCell.identifier, for: indexPath) as? MyImagesCollectionViewCell else { return UICollectionViewCell() }
//        if indexPath.row < images.count {
//            cell.configure(image: images[indexPath.row], sequence: indexPath.row + 1, kind: Kind.boardSelectDetail)
//        } else {
//            cell.configure(image: UIImage(named: "imageNULL"), sequence: indexPath.row + 1, kind: Kind.boardSelectDetail)
//        }
//        return cell
//    }
//}
//
//extension MyClubViewController: UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//
////        let size: CGFloat = imagesCollectionView.frame.size.width/2
//////        CGSize(width: size, height: size)
////
////        CGSize(width: view.frame.width / 5, height: view.frame.width / 5)
//
//        return CGSize(width: collectionView.frame.height - 20, height: collectionView.frame.height - 20)
//    }
//}
//
//
//
////extension MyClubViewController: UITextFieldDelegate {
////    func textFieldDidChangeSelection(_ textField: UITextField) {
//////        userProfile.userName = textField.text
//////        print("userName = \(userProfile.userName!)")
////        switch textField.tag {
////        case 0:
////            userProfile.userName = textField.text
////            print("userName = \(userProfile.userName!)")
////        default: break
////        }
////    }
////
//////    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//////        textField.resignFirstResponder()
//////        return true
//////    }
////
//////    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
//////        switch textField.tag {
//////        case 0: return true
//////        default: return false
//////        }
//////    }
////
//////    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//////        switch textField.tag {
//////        case 0: return true
//////        default: return false
//////        }
//////    }
//////
//////    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//////        guard let text = textField.text else { return false }
//////
//////        // 최대 글자수 이상을 입력한 이후에는 중간에 다른 글자를 추가할 수 없게끔 작동
//////        if text.count >= maxLength && range.length == 0 && range.location < maxLength {
//////            return false
//////        }
//////
//////        return true
//////    }
////}
//
//extension MyClubViewController: UIPickerViewDataSource {
//    func numberOfComponents(in pickerView: UIPickerView) -> Int {
//        return 1
//    }
//
//    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        switch pickerView.tag {
//        case BoardSelectDetailSectionData.numberOfMember.rawValue:
//            return self.memberNumberData.count
////        case BoardSelectDetailSectionData.dateTime.rawValue:
////            switch <#value#> {
////            case <#pattern#>:
////                <#code#>
////            default:
////                <#code#>
////            }
////            return self.genderData.count
//        default:
//            fatalError("일치하는 피커뷰 없다")
//        }
//    }
//
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        switch pickerView.tag {
//        case BoardSelectDetailSectionData.numberOfMember.rawValue:
//            return "\(self.memberNumberData[row])"
////        case BoardSelectDetailSectionData.dateTime.rawValue:
////            switch <#value#> {
////            case <#pattern#>:
////                <#code#>
////            default:
////                <#code#>
////            }
////            return self.genderData.count
//        default: fatalError("Pickerview tag error")
//        }
//    }
//}
//
//extension MyClubViewController: UIPickerViewDelegate {
//
//    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        switch pickerView.tag {
//        case BoardSelectDetailSectionData.numberOfMember.rawValue:
//            return createBoardReq.totalMember = self.memberNumberData[row]
////        case BoardSelectDetailSectionData.dateTime.rawValue:
////            switch <#value#> {
////            case <#pattern#>:
////                <#code#>
////            default:
////                <#code#>
////            }
////            return self.genderData.count
//        default: fatalError("Pickerview tag error")
//        }
//    }
//
//    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
//        return 44
//    }
//}
//
//extension MyClubViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
//    func openLibrary() {
//        imagePicker.sourceType = .photoLibrary
//        DispatchQueue.main.async {
//            self.present(self.imagePicker, animated: true, completion: nil)
//        }
//    }
//
//    func openCamera() {
//        imagePicker.sourceType = .camera
//        DispatchQueue.main.async {
//            self.present(self.imagePicker, animated: true, completion: nil)
//        }
//    }
//
//    func deleteImage(_ index: Int) {
//        images.remove(at: index)
//    }
//
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        // action 각기 다르게
//        if let img = info[UIImagePickerController.InfoKey.originalImage] {
//            print("image pick")
//            if let image = img as? UIImage {
//                images.append(image)
//            }
//        }
//        DispatchQueue.main.async {
//            self.dismiss(animated: true, completion: nil)
//        }
//    }
//}
//
//
//
////extension MyClubViewController: NationalityProtocol {
////    func nationalitySend(nationality: String) {
////        userProfile.nationality = nationality
////        infoTableView.reloadData()
////    }
////}
//
////extension UIScrollView {
////   func updateContentView() {
////      contentSize.height = subviews.sorted(by: { $0.frame.maxY < $1.frame.maxY }).last?.frame.maxY ?? contentSize.height
////   }
////}
//
////extension UIScrollView {
////    func updateContentSize() {
////        let unionCalculatedTotalRect = recursiveUnionInDepthFor(view: self)
////
////        // 계산된 크기로 컨텐츠 사이즈 설정
////        self.contentSize = CGSize(width: self.frame.width, height: unionCalculatedTotalRect.height+50)
////    }
////
////    private func recursiveUnionInDepthFor(view: UIView) -> CGRect {
////        var totalRect: CGRect = .zero
////
////        // 모든 자식 View의 컨트롤의 크기를 재귀적으로 호출하며 최종 영역의 크기를 설정
////        for subView in view.subviews {
////            totalRect = totalRect.union(recursiveUnionInDepthFor(view: subView))
////        }
////
////        // 최종 계산 영역의 크기를 반환
////        return totalRect.union(view.frame)
////    }
////}
//
