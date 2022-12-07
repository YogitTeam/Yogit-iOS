////
////  ClipBoardViewController.swift
////  Yogit
////
////  Created by Junseo Park on 2022/12/07.
////
//
//import UIKit
//import SnapKit
//import Alamofire
//class ClipBoardViewController: UIViewController {
//    
//    var height: CGFloat = 0.0
//    var cursor = 0
//    var boardId: Int64?
//    var clipBoardData: [GetAllClipBoardsRes] = []
//    private var hostId: Int64?
////    private lazy var chatTextField: UITextField = {
////        let textField = UITextField()
////        textField.font = UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.regular)
////        textField.isEnabled = true
////        textField.translatesAutoresizingMaskIntoConstraints = false
//////        textField.addrightView(view: self.sendButton)
//////        textField.tintColor = .clear
////        textField.layer.borderWidth = 1
////        textField.layer.borderColor = UIColor.systemRed.cgColor
////        return textField
////    }()
//    
//    private let chatTableView: UITableView = {
//        let tableView = UITableView()
//        tableView.isScrollEnabled = true
//        tableView.separatorStyle = .none
//        tableView.backgroundColor = .systemBackground
////        tableView.sectionHeaderTopPadding = 16
//        tableView.register(ClipBoardTableViewCell.self, forCellReuseIdentifier: ClipBoardTableViewCell.identifier)
////        tableView.register(RequirementTableViewHeader.self, forHeaderFooterViewReuseIdentifier: RequirementTableViewHeader.identifier)
//////        tableView.register(SetUpProfileTableViewFooter.self, forHeaderFooterViewReuseIdentifier: SetUpProfileTableViewFooter.identifier)
//        return tableView
//    }()
//    
//    private let chatTextView: UITextView = {
//        let textView = UITextView()
//        textView.translatesAutoresizingMaskIntoConstraints = false
//        textView.isScrollEnabled = false
//        textView.backgroundColor = .systemBackground
//        textView.font = .systemFont(ofSize: 20, weight: UIFont.Weight.regular)
//        textView.layer.borderWidth = 1
//        textView.layer.borderColor = UIColor.placeholderText.cgColor
//        textView.layer.cornerRadius = 8
//        textView.textColor = .placeholderText
//        textView.sizeToFit()
//        textView.textContainerInset = UIEdgeInsets(top: 6, left: 6, bottom: 6, right: 6)
//        return textView
//    }()
//    
//    private lazy var sendButton: UIButton = {
//        let button = UIButton()
//        button.backgroundColor = UIColor(rgb: 0x3232FF, alpha: 1.0)
////        button.setImage(UIImage(named: "Apply")?.withTintColor(.white, renderingMode: .alwaysTemplate), for: .normal)
//        button.setTitle("Send", for: .normal)
////        button.setTitle("Applied", for: .disabled)
//        button.titleLabel?.font = .systemFont(ofSize: 17, weight: UIFont.Weight.semibold)
//        button.tintColor = .white
//        button.setTitleColor(.white, for: .normal) // 이렇게 해야 적용된다!
//        button.layer.cornerRadius = 8
//        button.isEnabled = true
//        button.addTarget(self, action: #selector(self.sendButtonTapped(_:)), for: .touchUpInside)
//        return button
//    }()
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        configureViewCompoent()
////        view.addSubview(chatTextField)
//        view.addSubview(chatTableView)
//        view.addSubview(chatTextView)
//        view.addSubview(sendButton)
////        chatTextField.delegate = self
//        chatTextView.delegate = self
//        chatTableView.delegate = self
//        chatTableView.dataSource = self
//        getClipBoardData()
//        // Do any additional setup after loading the view.
//    }
//    
//    override func viewDidLayoutSubviews() {
//        chatTableView.frame = view.bounds
//        sendButton.snp.makeConstraints {
//            $0.trailing.equalToSuperview()
//            $0.bottom.equalToSuperview()
//            $0.height.equalTo(44)
//            $0.width.equalTo(60)
//        }
//        chatTextView.snp.makeConstraints {
//            $0.leading.bottom.equalToSuperview()
//            $0.trailing.equalTo(sendButton.snp.leading)
//            $0.height.greaterThanOrEqualTo(44)
//            $0.height.lessThanOrEqualTo(200) // greaterThanOrEqualTo(48) // .priority(.high)
////            $0.height.equalTo(48)
//        }
////        chatTextField.snp.makeConstraints {
////            $0.leading.bottom.equalToSuperview()
////            $0.trailing.equalTo(sendButton.snp.leading)
////            $0.height.equalTo(48)
////        }
//    }
//    
//    override func viewWillAppear(_ animated: Bool) {
//       super.viewWillAppear(animated)
//       subscribeToKeyboardNotifications()
//   }
//   
//   override func viewDidDisappear(_ animated: Bool) {
//       super.viewDidDisappear(animated)
//       unsubscribeFromKeyboardNotifications()
//   }
//    
//    private func configureViewCompoent() {
//        self.view.backgroundColor = .systemBackground
//    }
//    
//    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
//        let userInfo = notification.userInfo
//        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
//        return keyboardSize.cgRectValue.height
//    }
//    
//    @objc func keyboardWillShow(_ notification: Notification) {
////        if chatTextField.isFirstResponder {
////            height = getKeyboardHeight(notification)
////            chatTableView.frame.origin.y = height
////            view.frame.origin.y = -height
////        }
//        if chatTextView.isFirstResponder {
//            height = getKeyboardHeight(notification)
//            chatTableView.frame.origin.y = height
//            view.frame.origin.y = -height
//        }
//    }
//        
//    @objc func keyboardWillHide(_ notification: Notification) {
////        if chatTextField.isFirstResponder {
////            chatTableView.frame.origin.y = 0
////            view.frame.origin.y = 0
////        }
//        if chatTextView.isFirstResponder {
//            chatTableView.frame.origin.y = 0
//            view.frame.origin.y = 0
//        }
//    }
//    
//    func subscribeToKeyboardNotifications() {
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
//    }
//    
//    func unsubscribeFromKeyboardNotifications() {
//        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidChangeFrameNotification, object: nil)
//        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
//    }
//    
//    @objc func sendButtonTapped(_ sender: UIButton) {
//        // update tableview
//        chatTextView.resignFirstResponder()
//    }
//    
//    private func getClipBoardData() {
//        guard let userItem = try? KeychainManager.getUserItem() else { return }
//        hostId = userItem.userId
//        guard let boardId = self.boardId else { return }
//        let getAllClipBoardsReq = GetAllClipBoardsReq(boardId: boardId, cursor: self.cursor, refreshToken: userItem.refresh_token, userId: userItem.userId)
//        AF.request(API.BASE_URL + "clipboards/all/board/\(boardId)/user/\(userItem.userId)",
//                   method: .post,
//                   parameters: getAllClipBoardsReq,
//                   encoder: JSONParameterEncoder.default) // default set body and Content-Type HTTP header field of an encoded request is set to application/json
//        .validate(statusCode: 200..<500)
//        .response { response in // reponseData
//            switch response.result {
//            case .success:
//                debugPrint(response)
//                if let data = response.data {
//                    do{
//                        let decodedData = try JSONDecoder().decode(APIResponse<[GetAllClipBoardsRes]>.self, from: data)
//                        guard let inputData = decodedData.data else { return }
//                        self.clipBoardData = inputData
//                        self.chatTableView.reloadData()
//                    }
//                    catch{
//                        print(error.localizedDescription)
//                    }
//                }
//            case .failure(let error):
//                debugPrint(response)
//                print(error)
//            }
//        }
//        
//    }
//    
////    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//////        chatTextField.resignFirstResponder()
////        chatTextView.resignFirstResponder()
////        return true
////    }
////
////    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
////        var newText: NSString = textField.text! as NSString
////        newText = newText.replacingCharacters(in: range, with: string) as NSString
////        
////        if newText.length < 1 {
////            sendButton.isEnabled = false
////        } else {
////            sendButton.isEnabled = true
////        }
////        return true
////    }
////    
//
//}
//
//extension ClipBoardViewController: UITextViewDelegate {
//    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
////        if textView.tag == 0 && text == "\n" { textView.resignFirstResponder() }
//        
//        // get the current text, or use an empty string if that failed
//        let currentText = textView.text ?? ""
//
//        // attempt to read the range they are trying to change, or exit if we can't
//        guard let stringRange = Range(range, in: currentText) else { return false }
//
//        // add their new text to the existing text
//        let updatedText = currentText.replacingCharacters(in: stringRange, with: text)
//        if currentText.count < 1 {
//            self.sendButton.isEnabled = false
//        } else {
//            self.sendButton.isEnabled = true
//        }
//        // make sure the result is under 16 characters
//        return updatedText.count <= 500
//    }
//    
//    func textViewDidChange(_ textView: UITextView) {
//        print("textViewDidChange")
//        let size = CGSize(width: textView.frame.size.width, height: .infinity)
//        let estimatedSize = textView.sizeThatFits(size)
//
//        if estimatedSize.height < 200 { return }
//        textView.isScrollEnabled = true
//        textView.reloadInputViews()
//        textView.setNeedsUpdateConstraints()
//
//    }
//}
//
//extension ClipBoardViewController: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print("didSelectRowAt")
//    }
//}
//
//extension ClipBoardViewController: UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return clipBoardData.count
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: ClipBoardTableViewCell.identifier, for: indexPath) as? ClipBoardTableViewCell else { return UITableViewCell() }
//        cell.configure(userId: clipBoardData[indexPath.row].userID, isMe: clipBoardData[indexPath.row].userID == hostId, imageUrl: clipBoardData[indexPath.row].profileImgURL, coment: clipBoardData[indexPath.row].content, updateDate: clipBoardData[indexPath.row].updatedAt)
//        return cell
//    }
//}
