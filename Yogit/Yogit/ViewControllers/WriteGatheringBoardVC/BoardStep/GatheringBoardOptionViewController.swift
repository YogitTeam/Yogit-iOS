//
//  GatheringBoardOptionViewController.swift
//  Yogit
//
//  Created by Junseo Park on 2022/12/02.
//

import UIKit

class GatheringBoardOptionViewController: UIViewController {

    private let step = 2.0
    private let stepHeaderView = StepHeaderView()
    private var headerView: [MyHeaderView] = [MyHeaderView(), MyHeaderView(), MyHeaderView()]
    private let placeholderData = ["Number of member including host", "Gathering date", "Address", "Ex) Gangnam station 3 exit (option)"]
    private var gatheringKind = GatheringKind.small
    private let textMax = 50
//    var mode: Mode? {
//        didSet {
//            if self.mode == .edit {
//                viewGetValues()
//            }
//        }
//    }
//    var createBoardReq = CreateBoardReq() {
//        didSet {
//            hasAllData()
//            print("Select Detail createBoardReq\(createBoardReq)")
//        }
//    }
//
//    var images: [UIImage] = []
    
    
    
//    var boardWithMode = BoardWithMode(boardReq: CreateBoardReq(), boardId: nil, imageIds: [], images: []) {
//        didSet {
//            print("boardWitMode2", boardWithMode)
//            DispatchQueue.main.async {
//                self.hasAllData()
//                print(self.boardWithMode)
//            }
//        }
//    }
    
    var boardWithMode = BoardWithMode() {
        didSet {
            print("boardWithMode", boardWithMode.date)
            self.hasAllData()
        }
    }
    
    private var memberNumberData: [Int] = []
    
    private var meetDate: String?
    
    private var totalNumber = 3
    
    private lazy var textCountLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 14, weight: UIFont.Weight.regular)
        label.textColor = .placeholderText
        label.text = "\(boardWithMode.addressDetail?.count ?? 0) / \(textMax)"
        label.sizeToFit()
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.isHidden = true
        return label
    }()
    
    private let numberPickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        pickerView.backgroundColor = .systemGray6
        return pickerView
    }()
    
    private let datePicker: UIDatePicker = {
       let datePicker = UIDatePicker()
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.datePickerMode = .dateAndTime
        let localeIdentifier = Locale.preferredLanguages.first
        datePicker.locale = Locale(identifier: localeIdentifier!)
//        datePicker.locale = Locale(identifier: "en") // Need localized
//        datePicker.addTarget(self, action: #selector(dateChanged(datePikcer:)), for: .valueChanged)
//        datePicker.frame.size = CGSize(width: 0, height: 500)
        datePicker.preferredDatePickerStyle = .wheels
        
        var components = DateComponents()
        components.day = 365
        let maxDate = Calendar.autoupdatingCurrent.date(byAdding: components, to: Date())
        components.day = 0
        let minDate = Calendar.autoupdatingCurrent.date(byAdding: components, to: Date())

        datePicker.maximumDate = maxDate
        datePicker.minimumDate = minDate
        datePicker.timeZone = .current//TimeZone(identifier: "UTC")
        datePicker.sizeToFit()
      return datePicker
    }()
    
//    private let timePicker: UIDatePicker = {
//       let datePicker = UIDatePicker(frame: .zero)
//        datePicker.datePickerMode = .time
//        let localeIdentifier = Locale.preferredLanguages.first
//        datePicker.locale = Locale(identifier: localeIdentifier!)
////        datePicker.locale = Locale(identifier: "en") // Need localized
////        datePicker.addTarget(self, action: #selector(dateChanged(datePikcer:)), for: .valueChanged)
//        datePicker.frame.size = CGSize(width: 0, height: 300)
//        datePicker.preferredDatePickerStyle = .wheels
//        datePicker.timeZone = TimeZone(identifier: "UTC")
//      return datePicker
//    }()
    
    private lazy var pickerViewToolBar: UIToolbar = {
        let toolBar = UIToolbar()
        toolBar.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 44)
        toolBar.backgroundColor = .systemGray4
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(donePressed))
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelPressed))
        cancelButton.tintColor = .systemGray
        doneButton.tintColor = UIColor(rgb: 0x3232FF, alpha: 1.0)
        toolBar.setItems([cancelButton, flexSpace, doneButton], animated: true)
        return toolBar
    }()
    
//    private lazy var dateContainerView: UIView = {
//        let view = UIView()
//        view.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(datePicker)
//        return view
//    }()
    
    private lazy var datePickerToolBar: UIToolbar = {
        let toolBar = UIToolbar()
        toolBar.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 44)
        toolBar.backgroundColor = .systemGray4
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dateDone))
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelPressed))
        cancelButton.tintColor = .systemGray
        doneButton.tintColor = UIColor(rgb: 0x3232FF, alpha: 1.0)
        toolBar.setItems([cancelButton, flexSpace, doneButton], animated: true)
        toolBar.sizeToFit()
        return toolBar
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
    
    private let memberTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.regular)
        textField.isEnabled = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.tintColor = .clear
//        textField.layer.borderWidth = 1
//        textField.layer.borderColor = UIColor.systemRed.cgColor
        return textField
    }()
    
    private let dateTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.regular)
        textField.isEnabled = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.tintColor = .clear
//        textField.layer.borderWidth = 1
//        textField.layer.borderColor = UIColor.systemRed.cgColor
        return textField
    }()
    
    private lazy var placeTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.regular)
        textField.isEnabled = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.tintColor = .clear
//        textField.rightView?.tintColor = .placeholderText
//        textField.layer.borderWidth = 1
//        textField.layer.borderColor = UIColor.systemRed.cgColor
        textField.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.searchPlaceTapped(_:))))
        return textField
    }()
    
    private let placeDetailTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.regular)
        textField.isEnabled = true
        textField.translatesAutoresizingMaskIntoConstraints = false
//        textField.tintColor = .clear
        textField.isHidden = true
//        textField.layer.borderWidth = 1
//        textField.layer.borderColor = UIColor.systemRed.cgColor
        return textField
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        [self.stepHeaderView,
         self.nextButton,
         self.memberTextField,
         self.dateTextField,
         self.placeTextField,
         self.placeDetailTextField,
         self.textCountLabel].forEach { view.addSubview($0) }
        [self.headerView[0],
         self.headerView[1],
         self.headerView[2]].forEach { view.addSubview($0) }
        numberPickerView.delegate = self
        numberPickerView.dataSource = self
        for i in 3...gatheringKind.memberNumber() { memberNumberData.append(i) }
        configureViewComponent()
        configureTextField()
        configureHeaderView()
        viewGetValues(mode: boardWithMode.mode)
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        NSLayoutConstraint.activate([
//            dateContainerView.heightAnchor.constraint(equalTo: datePicker.heightAnchor),
//            dateContainerView.widthAnchor.constraint(equalTo: datePicker.widthAnchor),
//            datePicker.centerXAnchor.constraint(equalTo: dateContainerView.centerXAnchor),
//            datePicker.centerYAnchor.constraint(equalTo: dateContainerView.centerYAnchor)
//        ])
        stepHeaderView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(30)
        }
        headerView[0].snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(10)
            $0.top.equalTo(stepHeaderView.snp.bottom).offset(30)
        }
        headerView[1].snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(10)
            $0.top.equalTo(memberTextField.snp.bottom).offset(30)
        }
        headerView[2].snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(10)
            $0.top.equalTo(dateTextField.snp.bottom).offset(30)
        }
        memberTextField.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(48)
            $0.top.equalTo(headerView[0].snp.bottom).offset(20)
        }
        dateTextField.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(48)
            $0.top.equalTo(headerView[1].snp.bottom).offset(20)
        }
        placeTextField.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(48)
            $0.top.equalTo(headerView[2].snp.bottom).offset(20)
        }
        placeDetailTextField.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(48)
            $0.top.equalTo(placeTextField.snp.bottom).offset(20)
        }
        nextButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(view.snp.bottom).inset(30)
            make.height.equalTo(50)
        }
        
        textCountLabel.snp.makeConstraints {
            $0.top.equalTo(placeDetailTextField.snp.bottom).offset(4)
            $0.trailing.equalToSuperview().inset(20)
        }
        
//        memberTextField.layoutIfNeeded()
//        dateTextField.layoutIfNeeded()
//        placeTextField.layoutIfNeeded()
//        placeDetailTextField.layoutIfNeeded()
        memberTextField.addBottomBorderWithColor(color: .placeholderText, width: 0.5)
        dateTextField.addBottomBorderWithColor(color: .placeholderText, width: 0.5)
        placeTextField.addBottomBorderWithColor(color: .placeholderText, width: 0.5)
        placeDetailTextField.addBottomBorderWithColor(color: .placeholderText, width: 0.5)
       
        print("viewDidLayoutSubview")
    }
    
    private func configureViewComponent() {
//        self.navigationItem.title = "Profile"
        view.backgroundColor = .systemBackground
//        self.configureDatePicker()
        self.navigationController?.navigationBar.topItem?.backButtonTitle = ""
        stepHeaderView.step = self.step
        stepHeaderView.titleLabel.text = "Setting"
    }
    
    
    private func configureTextField() {
        memberTextField.delegate = self
        dateTextField.delegate = self
        placeTextField.delegate = self
        placeDetailTextField.delegate = self
        memberTextField.tag = 0
        dateTextField.tag = 1
        placeTextField.tag = 2
        placeDetailTextField.tag = 3
        memberTextField.placeholder = placeholderData[0]
        dateTextField.placeholder = placeholderData[1]
        placeTextField.placeholder = placeholderData[2]
        placeDetailTextField.placeholder = placeholderData[3]
        memberTextField.inputView = numberPickerView
        memberTextField.inputAccessoryView = pickerViewToolBar
        memberTextField.addLeftImageWithMargin(image: UIImage(named: "MemberNumber")?.withTintColor(.placeholderText, renderingMode: .alwaysOriginal), width: 20, height: 20, margin: 4)
        dateTextField.inputView = datePicker
        dateTextField.inputView?.backgroundColor = .systemGray6
        dateTextField.inputAccessoryView = datePickerToolBar
//        memberTextField.addLeftImage(image: UIImage(named: "MemberNumber"))
        dateTextField.addLeftImageWithMargin(image: UIImage(named: "Date")?.withTintColor(.placeholderText, renderingMode: .alwaysOriginal), width: 20, height: 20, margin: 4)
        placeTextField.addLeftImageWithMargin(image: UIImage(named: "Place")?.withTintColor(.placeholderText, renderingMode: .alwaysOriginal), width: 20, height: 20, margin: 4)
        placeTextField.addRightImage(image: UIImage(named: "push"))
    }
    
    private func configureHeaderView() {
        headerView[0].contentNameLabel.text = "The number of people in a gathering"
        headerView[1].contentNameLabel.text = "Date & Time"
        headerView[2].contentNameLabel.text = "Meet up place"
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @objc func searchPlaceTapped(_ sender: UITapGestureRecognizer) {
        print("searchPlaceTapped")
        DispatchQueue.main.async {
            let MLSVC = MKMapLocalSearchViewController()
            MLSVC.delegate = self
            self.navigationController?.pushViewController(MLSVC, animated: true)
        }
    }
    
//    @objc func numberPickerViewTapped(_ sender: UITapGestureRecognizer) {
//        print(" numberPickerViewTapped")
//        self.boardWithMode.boardReq?.totalMember = 3
//        guard let boardReq = boardWithMode.boardReq else { return }
//        guard let memberNumber = boardReq.totalMember else { return }
//        self.memberTextField.text = String(memberNumber)
//    }
    
//    private func formatDate(date: Date) -> String{
//        let formatter = DateFormatter()
//        formatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
//        boardWithMode.boardReq?.date = date.dateToStringAPI() // formatter.string(from: date) // api 데이터
////        createBoardReq.date = formatter.string(from: date)
//        formatter.dateFormat = "E, MMM d, h:mm a"
//        return formatter.string(from: date) // 보여줄 데이터
//    }
    
//    private func hasAllData() {
//        if self.boardWithMode.boardReq?.totalMember != nil && self.boardWithMode.boardReq?.date != nil && self.boardWithMode.boardReq?.latitude != nil && self.boardWithMode.boardReq?.longitute != nil && self.boardWithMode.boardReq?.localityName != nil && self.boardWithMode.boardReq?.address != nil {
//            self.nextButton.isEnabled = true
//            self.nextButton.backgroundColor = UIColor(rgb: 0x3232FF, alpha: 1.0)
//            print("Has all data")
//        } else {
//            print("Not has all data")
//            self.nextButton.isEnabled = false
//            self.nextButton.backgroundColor = .placeholderText
//        }
//    }
    
    private func hasAllData() {
        if boardWithMode.totalMember != nil && boardWithMode.date != nil && boardWithMode.latitude != nil && boardWithMode.longitute != nil && boardWithMode.city != nil && boardWithMode.address != nil {
            nextButton.isEnabled = true
            nextButton.backgroundColor = UIColor(rgb: 0x3232FF, alpha: 1.0)
            print("Has all data")
        } else {
            print("Not has all data")
            nextButton.isEnabled = false
            nextButton.backgroundColor = .placeholderText
        }
    }
    
//    private func viewGetValues(mode: Mode?) {
//        if mode != .edit { return }
//        guard let memberNumber = boardWithMode.boardReq?.totalMember else { return }
//        self.memberTextField.text = String(memberNumber)
//        self.dateTextField.text = boardWithMode.boardReq?.date?.stringToDate()?.dateToStringUser()
//        self.placeTextField.text = boardWithMode.boardReq?.address
//        if boardWithMode.boardReq?.address != nil {
//            self.placeDetailTextField.text = boardWithMode.boardReq?.addressDetail
//            self.placeDetailTextField.isHidden = false
//        }
//    }
    
    private func viewGetValues(mode: Mode?) {
        if mode != .edit { return }
        guard let memberNumber = boardWithMode.totalMember else { return }
        memberTextField.text = String(memberNumber)
        dateTextField.text = boardWithMode.date?.stringToDate()?.dateToStringUser()
        placeTextField.text = boardWithMode.address
        if boardWithMode.address != nil {
            placeDetailTextField.text = boardWithMode.addressDetail
            placeDetailTextField.isHidden = false
            textCountLabel.isHidden = false
        }
    }
    
//    @objc func dateDone(_ sender: UIButton) {
////        self.meetDate = formatDate(date: self.datePicker.date)
//        self.boardWithMode.boardReq?.date = self.datePicker.date.dateToStringAPI()
//        self.dateTextField.text = self.datePicker.date.dateToStringUser() //self.meetDate
//        self.view.endEditing(true)
//    }
    
    @objc func dateDone(_ sender: UIButton) {
        boardWithMode.date = datePicker.date.dateToStringAPI()
        dateTextField.text = datePicker.date.dateToStringUser() //self.meetDate
        view.endEditing(true)
    }
    
    @objc func nextButtonTapped(_ sender: UIButton) {
        DispatchQueue.main.async {
            let GBTDVC = GatheringBoardContentViewController()
//            GBTDVC.createBoardReq = self.createBoardReq
//            GBTDVC.images = self.images
//            GBTDVC.mode = self.mode
            GBTDVC.boardWithMode = self.boardWithMode
            self.navigationController?.pushViewController(GBTDVC, animated: true)
        }
    }
    
//    @objc func donePressed(_ sender: UIButton) {
//        boardWithMode.boardReq?.totalMember = self.totalNumber
//        guard let boardReq = boardWithMode.boardReq else { return }
//        guard let memberNumber = boardReq.totalMember else { return }
//        self.memberTextField.text = String(memberNumber)
//        self.view.endEditing(true)
//    }
    
    @objc func donePressed(_ sender: UIButton) {
        boardWithMode.totalMember = totalNumber
//        guard let boardReq = boardWithMode.boardReq else { return }
//        guard let memberNumber = boardReq.totalMember else { return }
//        guard let memberNumber = boardWithMode.totalMember else { return }
        self.memberTextField.text = String(totalNumber)
        self.view.endEditing(true)
    }
    
    @objc func cancelPressed(_ sender: UIButton) {
        self.view.endEditing(true)
    }
}

extension GatheringBoardOptionViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.memberNumberData.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(self.memberNumberData[row])"
    }
}

extension GatheringBoardOptionViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("select total number")
        self.totalNumber = self.memberNumberData[row]
    }

    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 44
    }
}

extension GatheringBoardOptionViewController: UITextFieldDelegate {
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        boardWithMode.boardReq?.addressDetail = textField.text
//        textField.resignFirstResponder()
//        return true
//    }
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        print("textFieldDidEndEditing", textField.text)
//        if textField.tag == 3 {
//            boardWithMode.addressDetail = textField.text
//        }
//    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        switch textField.tag {
//        case 3: return true
//        default: return false
//        }
//    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField.tag == 3 {
            boardWithMode.addressDetail = textField.text
            textCountLabel.text = "\(textField.text?.count ?? 0) / \(textMax)"
            if (boardWithMode.addressDetail?.count ?? 0) <= 0 {
                textCountLabel.textColor = .placeholderText
            } else {
                textCountLabel.textColor = .label
            }
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        switch textField.tag {
        case 3:
            let currentText = textField.text ?? ""
            guard let stringRange = Range(range, in: currentText) else { return false }
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
            return updatedText.count <= textMax
        default: return false
        }
    }
}

extension GatheringBoardOptionViewController: MeetUpPlaceProtocol {
//    func locationSend(meetUpPlace: MeetUpPlace?) {
//        self.boardWithMode.boardReq?.address = meetUpPlace?.address
//        self.boardWithMode.boardReq?.latitude = meetUpPlace?.latitude
//        self.boardWithMode.boardReq?.longitute = meetUpPlace?.longitude
//        self.boardWithMode.boardReq?.localityName = meetUpPlace?.locality
//        placeTextField.text = self.boardWithMode.boardReq?.address
//        placeDetailTextField.isHidden = false
//    }
    
    func locationSend(meetUpPlace: MeetUpPlace?) {
        boardWithMode.address = meetUpPlace?.address
        boardWithMode.latitude = meetUpPlace?.latitude
        boardWithMode.longitute = meetUpPlace?.longitude
        boardWithMode.city = meetUpPlace?.locality
        placeTextField.text = meetUpPlace?.address
        placeDetailTextField.isHidden = false
        textCountLabel.isHidden = false
    }
}
