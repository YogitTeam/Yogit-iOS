//
//  TestBoardViewController.swift
//  Yogit
//
//  Created by Junseo Park on 2022/12/02.
//

import UIKit

class TestBoardViewController: UIViewController {

    let step = 2.0
    let stepHeaderView = StepHeaderView()
    var headerView: [MyHeaderView] = [MyHeaderView(), MyHeaderView(), MyHeaderView()]
    private let placeholderData = ["Number of member including host", "2022.08.31 14:00", "MeetUp place", "Ex) Gangnam station 3 exit (option)"]
    
    var createBoardReq = CreateBoardReq() {
        didSet {
            hasAllData()
            print("Select Detail createBoardReq\(createBoardReq)")
        }
    }
    
    private var memberNumberData: [Int] = []
    
    private var date: String?
    
    private let numberPickerView: UIPickerView = {
        let pickerView = UIPickerView()
        return pickerView
    }()
    
    private let datePicker: UIDatePicker = {
        print("datePicker lazy var")
      let datePicker = UIDatePicker(frame: .zero)
//      datePicker.timeZone = TimeZone.current
        datePicker.datePickerMode = .dateAndTime
        datePicker.locale = Locale(identifier: "en") // Need localized
//        datePicker.addTarget(self, action: #selector(dateChanged(datePikcer:)), for: .valueChanged)
        datePicker.frame.size = CGSize(width: 0, height: 300)
        datePicker.preferredDatePickerStyle = .wheels
      return datePicker
    }()
    
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
        textField.tintColor = .clear
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
         self.placeDetailTextField].forEach { view.addSubview($0) }
        [self.headerView[0],
         self.headerView[1],
         self.headerView[2]].forEach { view.addSubview($0) }
        numberPickerView.delegate = self
        for i in 3...30 { memberNumberData.append(i) }
        configureViewComponent()
        configureTextField()
        configureHeaderView()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
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
        dateTextField.inputView = datePicker
        dateTextField.inputAccessoryView = datePickerToolBar
        memberTextField.addLeftImage(image: UIImage(named: "MemberNumber"))
        dateTextField.addLeftImage(image: UIImage(named: "Date"))
        placeTextField.addLeftImage(image: UIImage(named: "MeetUpPlace"))
        placeTextField.addRightImage(image: UIImage(named: "push"))
    }
    
    private func configureHeaderView() {
        headerView[0].contentNameLabel.text = "The number of people in a gathering"
        headerView[1].contentNameLabel.text = "Date & Time"
        headerView[2].contentNameLabel.text = "Location"
    }
    
    @objc func searchPlaceTapped(_ sender: UITapGestureRecognizer) {
        print("searchPlaceTapped")
        DispatchQueue.main.async {
            let MLSVC = MKMapLocalSearchViewController()
            MLSVC.delegate = self
            self.navigationController?.pushViewController(MLSVC, animated: true)
        }
    }
    
    private func formatDate(date: Date) -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
        createBoardReq.date = formatter.string(from: date)
        formatter.dateFormat = "E, MMM d, h:mm a"
        return formatter.string(from: date)
    }
    
    private func hasAllData() {
        if self.createBoardReq.totalMember != nil && self.createBoardReq.date != nil && self.createBoardReq.latitude != nil && self.createBoardReq.longitute != nil && self.createBoardReq.cityName != nil && self.createBoardReq.address != nil {
            self.nextButton.isEnabled = true
            self.nextButton.backgroundColor = UIColor(rgb: 0x3232FF, alpha: 1.0)
            print("Has all data")
        } else {
            print("Not has all data")
            self.nextButton.isEnabled = false
            self.nextButton.backgroundColor = .placeholderText
        }
    }
    
    @objc func dateDone(_ sender: UIButton) {
        date = formatDate(date: self.datePicker.date)
        dateTextField.text = date
        self.view.endEditing(true)
    }
    
    @objc func nextButtonTapped(_ sender: UIButton) {
        DispatchQueue.main.async {
            let GBTDVC = GatheringBoardContentViewController()
            GBTDVC.createBoardReq = self.createBoardReq
            self.navigationController?.pushViewController(GBTDVC, animated: true)
        }
    }
    
    @objc func donePressed(_ sender: UIButton) {
        memberTextField.text = createBoardReq.totalMember == nil ? nil : "\(createBoardReq.totalMember!)"
        self.view.endEditing(true)
    }
    
    @objc func cancelPressed(_ sender: UIButton) {
        self.view.endEditing(true)
    }
}

extension TestBoardViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.memberNumberData.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        print("commponent")
        return "\(self.memberNumberData[row])"
    }
}

extension TestBoardViewController: UIPickerViewDelegate {

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        return createBoardReq.totalMember = self.memberNumberData[row]
    }

    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 44
    }
}

extension TestBoardViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        createBoardReq.addressDetail = textField.text
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        switch textField.tag {
        case 3: return true
        default: return false
        }
    }
}

extension TestBoardViewController: MeetUpPlaceProtocol {
    func locationSend(meetUpPlace: MeetUpPlace?) {
        self.createBoardReq.address = meetUpPlace?.address
        self.createBoardReq.latitude = meetUpPlace?.latitude
        self.createBoardReq.longitute = meetUpPlace?.longitude
        self.createBoardReq.cityName = meetUpPlace?.city
        placeTextField.text = self.createBoardReq.address
        placeDetailTextField.isHidden = false
    }
}
