//
//  GatheringTextDetailViewController.swift
//  Yogit
//
//  Created by Junseo Park on 2022/11/12.
//

import UIKit
import Alamofire
import SnapKit

// 글자수 n 글자 이상 m 이하
class GatheringBoardTextDetailViewController: UIViewController, UITableViewDelegate {
    var createBoardReq = CreateBoardReq() {
        didSet {
            print("BoardTextDetail \(createBoardReq)")
        }
    }
    
    let stepHeaderView = StepHeaderView()
    let step = 3.0
    let minChar = [10, 50, 50]
    let maxChar = [35, 200, 200]
    let placeholderData = ["Ex) Hangout", "Ex) Hangout", "Ex) Hangout"]
    var textViewCount = [0, 0, 0] {
        didSet {
//            for i in 0..<3 {
//                if textViewCount[i] >= minChar[i] && textViewCount[i] <= maxChar[i] {
//                    uploadButton.isEnabled = true
//                    uploadButton.backgroundColor = UIColor(rgb: 0x3232FF, alpha: 1.0)
//                } else {
//                    uploadButton.isEnabled = false
//                    uploadButton.backgroundColor = .placeholderText
//                    break
//                }
//            }
        }
    }
    
    private lazy var rightButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(buttonPressed(_:)))
        button.tintColor =  UIColor(rgb: 0x3232FF, alpha: 1.0)
        return button
    }()
    
    private let textDetailTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .systemBackground
        tableView.sectionHeaderTopPadding = 10
        tableView.register(MyTextViewTableViewCell.self, forCellReuseIdentifier: MyTextViewTableViewCell.identifier)
        tableView.register(RequirementTableViewHeader.self, forHeaderFooterViewReuseIdentifier: RequirementTableViewHeader.identifier)
        return tableView
    }()
    
//    private lazy var uploadButton: UIButton = {
//        let button = UIButton()
//        button.setTitle("Upload", for: .normal)
//        button.tintColor = .white
//        button.layer.cornerRadius = 8
//        button.isEnabled = false
//        button.backgroundColor = .placeholderText
//        button.addTarget(self, action: #selector(self.uploadButtonTapped(_:)), for: .touchUpInside)
//        return button
//    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(stepHeaderView)
        view.addSubview(textDetailTableView)
//        view.addSubview(uploadButton)
        textDetailTableView.delegate = self
        textDetailTableView.dataSource = self
        configureViewComponent()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        stepHeaderView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(30)
        }
//        textDetailTableView.frame = view.bounds
        
        textDetailTableView.snp.makeConstraints { make in
            make.top.equalTo(stepHeaderView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
//        uploadButton.snp.makeConstraints { make in
//            make.leading.trailing.equalToSuperview().inset(20)
//            make.bottom.equalToSuperview().inset(30)
//            make.height.equalTo(50)
//        }
    }
    
    private func configureViewComponent() {
//        self.navigationItem.title = "Profile"
        self.hideKeyboardWhenTappedAround()
        self.navigationItem.rightBarButtonItem = self.rightButton
        self.stepHeaderView.step = step
        view.backgroundColor = .systemBackground
    }

    @objc func buttonPressed(_ sender: UIButton) {
        for i in 0..<3 {
            if textViewCount[i] >= minChar[i] && textViewCount[i] <= maxChar[i] {
                createBoardReq.hostId = 1 // 아이디 받으면 아이디로
                createBoardReq.cityId = 1 // 수정 필요
//                createBoardReq.notice = "" // 빈값
            
                // 통신완료 후 pop root까지
                let parameters: [String: Any] = [
                    "cityId": createBoardReq.cityId!,
                    "hostId": createBoardReq.hostId!,
                    "title": createBoardReq.title!,
                    "address": createBoardReq.address!,
                    "addressDetail": createBoardReq.addressDetail ?? "",
                    "longitute": createBoardReq.longitute!,
                    "latitude": createBoardReq.latitude!,
                    "date": createBoardReq.date!,
                    "notice": createBoardReq.notice ?? "",
                    "introduction": createBoardReq.introduction!,
                    "kindOfPerson": createBoardReq.kindOfPerson!,
                    "totalMember": createBoardReq.totalMember!,
                    "categoryId": createBoardReq.categoryId!,
                ]
                print(parameters)
                
//                for (key, value) in parameters {
//                    print(key, value)
//                }
//                for image in self.createBoardReq.images! {
//                    print(image)
//                }

//                let url = "https://www.yogit.world/boards"
                
                AF.upload(multipartFormData: { multipartFormData in
                    for (key, value) in parameters {
                        multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key)
                        print("\(value)".data(using: String.Encoding.utf8)!)
                    }
                    for image in self.createBoardReq.images! {
                        multipartFormData.append(image.toFile(format: .jpeg(1))!, withName: "images", fileName: "images.jpeg", mimeType: "images/jpeg")
                        print(image.toFile(format: .jpeg(1))!)
                    }
                }, to: API.BASE_URL + "boards", method: .post)
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
                
            } else {
                // 경고창
                print("Not has all value")
                let alert = UIAlertController(title: "Please enter the required information correctly", message: "Please enter the required information according to the number of text", preferredStyle: UIAlertController.Style.alert)
                let okAction = UIAlertAction(title: "OK", style: .default)
                alert.addAction(okAction)
                present(alert, animated: false, completion: nil)
            }
        }
        // pop root까지
//        DispatchQueue.main.async {
//            let GBSDVC = GatheringBoardSelectDetailViewController()
//            GBSDVC.createBoardReq = self.createBoardReq
//            self.navigationController?.pushViewController(GBSDVC, animated: true)
//        }
    }
}

extension GatheringBoardTextDetailViewController: UITableViewDataSource {
    // Reporting the number of sections and rows in the table.
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 1
        case 1: return 1
        case 2: return 1
        default: fatalError("GatheringBoardSelectDetailVC out of section")
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 22
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0: return 54
        case 1: return 150
        case 2: return 150
        default: fatalError("GatheringBoardTextDetailViewController out of section index")
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MyTextViewTableViewCell.identifier, for: indexPath) as? MyTextViewTableViewCell else { return UITableViewCell() }
        cell.myTextView.tag = indexPath.section
        cell.myTextView.delegate = self
        cell.myTextView.text = placeholderData[indexPath.section]
        switch indexPath.section {
        case 0: createBoardReq.title = cell.myTextView.text
        case 1: createBoardReq.introduction = cell.myTextView.text
        case 2: createBoardReq.kindOfPerson = cell.myTextView.text
        default: fatalError("Textdetail out of index error")
        }
        cell.textCountLabel.text = "0 / \(maxChar[indexPath.section])"
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: RequirementTableViewHeader.identifier) as? RequirementTableViewHeader else { return UITableViewHeaderFooterView() }
        
        // userName, age, lanages, gender, nationality
        switch section {
        case 0: headerView.configure(text: "Title")
        case 1: headerView.configure(text: "Gathering introduction")
        case 2: headerView.configure(text: "Please apply this kind of person")
        default: fatalError("Out of header RequirementTableViewHeader section index")
        }
        return headerView
    }
}

extension GatheringBoardTextDetailViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if textView.tag == 0 && text == "\n" { textView.resignFirstResponder() }
        
        // get the current text, or use an empty string if that failed
        let currentText = textView.text ?? ""

        // attempt to read the range they are trying to change, or exit if we can't
        guard let stringRange = Range(range, in: currentText) else { return false }

        // add their new text to the existing text
        let updatedText = currentText.replacingCharacters(in: stringRange, with: text)

        // make sure the result is under 16 characters
        return updatedText.count <= maxChar[textView.tag]
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == placeholderData[textView.tag] {
            textView.text = nil
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text =  placeholderData[textView.tag]
            textView.textColor = .placeholderText
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        // textfield count
        // 개수 표시
        let indexPath = IndexPath(row: 0, section: textView.tag)
        guard let cell = textDetailTableView.cellForRow(at: indexPath) as?  MyTextViewTableViewCell else { return }
        if textView.text.count == 0 {
            cell.textCountLabel.textColor = .placeholderText
        }
        else if textView.text.count >= minChar[textView.tag] {
            cell.textCountLabel.textColor = UIColor(rgb: 0x3232FF, alpha: 1.0)
        } else {
            cell.textCountLabel.textColor = .red
        }
        cell.textCountLabel.text = "\(textView.text.count) / \(maxChar[textView.tag])"
        textViewCount[textView.tag] = textView.text.count
        switch textView.tag {
        case 0: createBoardReq.title = textView.text
        case 1: createBoardReq.introduction = textView.text
        case 2: createBoardReq.kindOfPerson = textView.text
        default: fatalError("Gathering board textview error")
        }
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

