//
//  GatheringBoardOptionViewController.swift
//  Yogit
//
//  Created by Junseo Park on 2022/12/02.
//

import UIKit

class GatheringBoardOptionViewController: UIViewController, UIScrollViewDelegate {

    var boardWithMode = BoardWithMode() {
        didSet {
            self.hasAllData()
        }
    }
    
    private let step: Float = 1.0
    private let textMax = 50

    private lazy var stepHeaderView: StepHeaderView = {
        let view = StepHeaderView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 70), step: step)
        view.titleLabel.text = "GATHERING_SETTING".localized()
        return view
    }()
    
    private var headerView: [MyHeaderView] = [MyHeaderView(), MyHeaderView(), MyHeaderView()]
    
    private var gatheringKind = GatheringKind.small
    
    private var memberNumberData: [Int] = []
    
    private var meetDate: String?
    
    private var totalNumber = 3
    
    private lazy var settingContentScrollView: UIScrollView = {
       let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.isScrollEnabled = true
        scrollView.backgroundColor = .systemBackground
        scrollView.addSubview(settingContentView)
        return scrollView
    }()
    
    private lazy var settingContentView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        [self.headerView[0],
         self.memberTextField,
         self.headerView[1],
         self.dateTextField,
         self.headerView[2],
         self.placeTextField,
         self.placeDetailTextField,
         self.textCountLabel].forEach { view.addSubview($0) }
        return view
    }()
    
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
        datePicker.backgroundColor = .systemGray6
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
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold)
        let image = UIImage(systemName: "chevron.right", withConfiguration: imageConfig)
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.isHidden = false
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
        return textField
    }()
    
    private let dateTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.regular)
        textField.isEnabled = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.tintColor = .clear
        return textField
    }()
    
    private lazy var placeTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.regular)
        textField.isEnabled = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.tintColor = .clear
        textField.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.searchPlaceTapped(_:))))
        return textField
    }()
    
    private let placeDetailTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.regular)
        textField.isEnabled = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.isHidden = true
        textField.returnKeyType = .done
        return textField
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNav()
        configureView()
        configureScrollView()
        configurePickerView()
        configureHeaderView()
        configureTextField()
        viewGetValues(mode: boardWithMode.mode)
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        stepHeaderView.fillProgress(step: step + 1)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        stepHeaderView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.right.equalToSuperview()
            make.height.equalTo(70)
        }
        settingContentScrollView.snp.makeConstraints {
            $0.top.equalTo(stepHeaderView.snp.bottom)
            $0.bottom.leading.trailing.equalToSuperview()
        }
        settingContentView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.centerX.top.equalToSuperview()
            $0.bottom.equalTo(textCountLabel.snp.bottom).offset(80)
        }
        headerView[0].snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(10)
            $0.top.equalToSuperview()
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
        nextButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(20)
            $0.width.height.equalTo(60)
        }
        nextButton.layer.cornerRadius = nextButton.frame.size.width/2
        
        textCountLabel.snp.makeConstraints {
            $0.top.equalTo(placeDetailTextField.snp.bottom).offset(4)
            $0.trailing.equalToSuperview().inset(20)
        }
        
        memberTextField.addBottomBorderWithColor(color: .placeholderText, width: 0.5)
        dateTextField.addBottomBorderWithColor(color: .placeholderText, width: 0.5)
        placeTextField.addBottomBorderWithColor(color: .placeholderText, width: 0.5)
        placeDetailTextField.addBottomBorderWithColor(color: .placeholderText, width: 0.5)
    }
    
    private func configureView() {
        view.backgroundColor = .systemBackground
        view.addSubview(stepHeaderView)
        view.addSubview(settingContentScrollView)
        view.addSubview(nextButton)
    }
    
    private func configureNav() {
        navigationController?.navigationBar.topItem?.backButtonTitle = ""
    }
    
    private func configureScrollView() {
        settingContentScrollView.delegate = self
    }
    
    private func configurePickerView() {
        numberPickerView.delegate = self
        numberPickerView.dataSource = self
        for i in 3...gatheringKind.memberNumber() { memberNumberData.append(i) }
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
        
        memberTextField.placeholder = GatheringElement.memberNumber.toHolder().localized()
        dateTextField.placeholder = GatheringElement.dateTime.toHolder().localized()
        placeTextField.placeholder = GatheringElement.addressRepsent.toHolder().localized()
        placeDetailTextField.placeholder = GatheringElement.addressDetail.toHolder().localized()
        
        memberTextField.inputView = numberPickerView
        memberTextField.inputAccessoryView = pickerViewToolBar

        dateTextField.inputView = datePicker
        dateTextField.inputView?.backgroundColor = .systemGray6
        dateTextField.inputAccessoryView = datePickerToolBar
        
        memberTextField.addLeftImageWithMargin(image: UIImage(named: "MemberNumber")?.withTintColor(.placeholderText, renderingMode: .alwaysOriginal), width: 20, height: 20, margin: 4)
        dateTextField.addLeftImageWithMargin(image: UIImage(named: "Date")?.withTintColor(.placeholderText, renderingMode: .alwaysOriginal), width: 20, height: 20, margin: 4)
        placeTextField.addLeftImageWithMargin(image: UIImage(named: "Place")?.withTintColor(.placeholderText, renderingMode: .alwaysOriginal), width: 20, height: 20, margin: 4)
        placeTextField.addRightImage(image: UIImage(named: "push"))
    }
    
    private func configureHeaderView() {
        headerView[0].contentNameLabel.text = GatheringElement.memberNumber.toTitle().localized()
        headerView[1].contentNameLabel.text = GatheringElement.dateTime.toTitle().localized()
        headerView[2].contentNameLabel.text = GatheringElement.addressRepsent.toTitle().localized()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @objc func searchPlaceTapped(_ sender: UITapGestureRecognizer) {
        DispatchQueue.main.async {
            let MLSVC = MKMapLocalSearchViewController()
            MLSVC.delegate = self
            self.navigationController?.pushViewController(MLSVC, animated: true)
        }
    }
    
    private func hasAllData() {
        if boardWithMode.totalMember != nil && boardWithMode.date != nil && boardWithMode.latitude != nil && boardWithMode.longitute != nil && boardWithMode.city != nil && boardWithMode.address != nil {
            nextButton.isEnabled = true
            nextButton.backgroundColor = UIColor(rgb: 0x3232FF, alpha: 1.0)
        } else {
            nextButton.isEnabled = false
            nextButton.backgroundColor = .placeholderText
        }
    }
    
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
            GBTDVC.boardWithMode = self.boardWithMode
            self.navigationController?.pushViewController(GBTDVC, animated: true)
        }
    }
    
    @objc func donePressed(_ sender: UIButton) {
        boardWithMode.totalMember = totalNumber
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
        self.totalNumber = self.memberNumberData[row]
    }

    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 44
    }
}

extension GatheringBoardOptionViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
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
