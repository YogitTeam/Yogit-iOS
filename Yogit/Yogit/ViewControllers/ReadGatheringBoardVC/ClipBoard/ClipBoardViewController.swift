//
//  ClipBoardViewController.swift
//  Yogit
//
//  Created by Junseo Park on 2022/12/07.
//

import UIKit
import SnapKit
import Alamofire
import InputBarAccessoryView
import IQKeyboardManagerSwift

class ClipBoardViewController: UIViewController {
    // 초기값 끝 페이지 까지 불러온다.
    var totalPage = 0
    var lastPageDataCount = 0
    var pageCursor = 0
    var isPaging = false
    var heightConstraint: NSLayoutConstraint?
    private var keyboardHeight: CGFloat = 0.0
    var boardId: Int64?
    var clipBoardData: [GetAllClipBoardsRes] = []
    private var hostId: Int64?
    var cellHeights: [IndexPath: CGFloat] = [:] // 이미 만들어진 셀들의 높이 값을 저장
    var inputContentViewBottomMargin: NSLayoutConstraint!
    var inputTextViewHeight: NSLayoutConstraint!

    private lazy var chatTableView: UITableView = {
        let tableView = UITableView()
        tableView.isScrollEnabled = true
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.backgroundColor = .systemBackground
        tableView.layer.borderColor = UIColor.blue.cgColor
        tableView.layer.borderWidth = 3
//        tableView.sectionHeaderTopPadding = 16
        tableView.register(MyClipBoardTableViewCell.self, forCellReuseIdentifier: MyClipBoardTableViewCell.identifier)
        tableView.register(YourClipBoardTableViewCell.self, forCellReuseIdentifier: YourClipBoardTableViewCell.identifier)
//        tableView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard(_:))))
//        tableView.register(RequirementTableViewHeader.self, forHeaderFooterViewReuseIdentifier: RequirementTableViewHeader.identifier)
////        tableView.register(SetUpProfileTableViewFooter.self, forHeaderFooterViewReuseIdentifier: SetUpProfileTableViewFooter.identifier)
        return tableView
    }()

    private lazy var inputTextContentView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        view.autoresizingMask = [.flexibleHeight]
        view.addSubview(chatTextView)
        view.addSubview(sendButton)
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.placeholderText.cgColor
        return view
    }()

//    private lazy var input: UIView = {
//        let view = UIView()
//        view.backgroundColor = .systemBackground
//        view.translatesAutoresizingMaskIntoConstraints = false
//        view.layer.borderWidth = 1
//        view.layer.borderColor = UIColor.placeholderText.cgColor
//
//        return view
//    }()

    private let chatTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isScrollEnabled = false
        textView.backgroundColor = .systemBackground
        textView.font = .systemFont(ofSize: 16, weight: UIFont.Weight.regular)
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.placeholderText.cgColor
        textView.layer.cornerRadius = 8
        textView.textColor = .label
        textView.isEditable = true
        textView.sizeToFit()
        textView.textContainerInset = UIEdgeInsets(top: 12, left: 10, bottom: 12, right: 10)
        return textView
    }()

    private lazy var sendButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor(rgb: 0x3232FF, alpha: 1.0)
//        button.setImage(UIImage(named: "Apply")?.withTintColor(.white, renderingMode: .alwaysTemplate), for: .normal)
        button.setTitle("Send", for: .normal)
//        button.setTitle("Applied", for: .disabled)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: UIFont.Weight.semibold)
        button.tintColor = .white
        button.setTitleColor(.white, for: .normal) // 이렇게 해야 적용된다!
        button.layer.cornerRadius = 8
        button.isEnabled = false
        button.addTarget(self, action: #selector(self.sendButtonTapped(_:)), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewCompoent()
//        view.addSubview(chatTextField)
        view.addSubview(chatTableView)
        view.addSubview(inputTextContentView)
        chatTableView.tag = 0
        chatTextView.tag = 1
//        view.addSubview(chatTextView)
//        view.addSubview(sendButton)
//        chatTextField.delegate = self
        chatTextView.delegate = self
        chatTableView.delegate = self
        chatTableView.dataSource = self
//        chatTableView.keyboardDismissMode = .interactive
//        getRequest()
        // Do any additional setup after loading the view.
    }

    override func viewDidLayoutSubviews() {
//        chatTableView.frame = view.bounds
//        view.layoutIfNeeded()
//        inputTextContentView.layoutIfNeeded()
//        chatTextView.layoutIfNeeded()
//        sendButton.layoutIfNeeded()

        inputTextContentView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide).priority(.high)
//            $0.top.equalTo(chatTableView)
//            $0.height.lessThanOrEqualTo(100)
//            $0.top.bottom.equalTo(chatTextView).inset(-6)
//            $0.bottom.lessThanOrEqualTo(view.safeAreaLayoutGuide)
        }
        sendButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(6)
            $0.width.equalTo(60)
            $0.height.equalTo(44)
        }
        chatTextView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.trailing.equalTo(sendButton.snp.leading).offset(10)
            $0.top.bottom.equalToSuperview().inset(6)
            $0.height.lessThanOrEqualTo(100)
//            $0.height.equalTo(44).priority(.high)
//            $0.height.greaterThanOrEqualTo(44)
//            $0.height.equalTo(44).priority(.high)
        }
//        view.layoutIfNeeded()
        chatTableView.snp.makeConstraints {
//            $0.edges.equalTo(view.safeAreaLayoutGuide)
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(inputTextContentView.snp.top) // .priority(.high)
//            $0.height.equalTo(view.safeAreaLayoutGuide.layoutFrame.height-inputTextContentView.frame.size.h)
//            $0.height.greaterThanOrEqualTo(200)
//            $0.bottom.equalTo(inputTextContentView.snp.top)
//            $0.bottom.lessThanOrEqualTo(inputTextContentView.snp.top)
//            $0.heig
        }
    }

    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow(_:)), name: UIResponder.keyboardDidShowNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidHide(_:)), name: UIResponder.keyboardDidHideNotification, object: nil)
    }

    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }


    override func viewWillAppear(_ animated: Bool) {
       super.viewWillAppear(animated)
        print("😀appear")
       IQKeyboardManager.shared.enable = false
////        chatTextView.becomeFirstResponder()
        subscribeToKeyboardNotifications()
    }

    override func viewWillDisappear(_ animated: Bool) {
       super.viewWillDisappear(animated)
        print("🥲disappear")
        IQKeyboardManager.shared.enable = true
////        chatTextView.resignFirstResponder()
        unsubscribeFromKeyboardNotifications()
    }

    private func configureViewCompoent() {
        self.view.backgroundColor = .systemBackground
//        self.chatTableView.keyboardDismissMode = .onDragWithAccessory
//        self.inputTextContentView.di
    }

    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }

//    @objc func dismissKeyboard(_ sender: UIGestureRecognizer) {
//        print("dismissKeyboard")
////        chatTextView.reloadInputViews()
////        chatTextView.setNeedsUpdateConstraints()
//        self.view.endEditing(true)
//    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if scrollView.tag == 0 {
//            chatTextView.reloadInputViews()
//            chatTextView.setNeedsUpdateConstraints()
            self.view.endEditing(true)
        }
    }

//    func needChangeTableViewLocation() {
//        UIView.animate(withDuration: animationDuration) { [self] in
//            inputTextContentView.transform = CGAffineTransform(translationX: 0, y: -self.keyboardHeight + self.view.safeAreaInsets.bottom)
//            if chatTableView.frame.height > chatTableView.contentSize.height {
//                chatTableView.transform = CGAffineTransform(translationX: 0, y: -self.keyboardHeight + self.view.safeAreaInsets.bottom)
//            } else {
//                if gap > 0 {
//                    chatTableView.transform = CGAffineTransform(translationX: 0, y: -self.keyboardHeight + self.view.safeAreaInsets.bottom - gap)
//                } else {
//
//                }
//            }
//            inputTextContentView.layoutIfNeeded()
//            chatTableView.layoutIfNeeded()
////            view.layoutIfNeeded()
//        }
//    }

    @objc func keyboardWillShow(_ notification: Notification) {
        let userInfo = notification.userInfo!
        let animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! TimeInterval
        self.keyboardHeight = getKeyboardHeight(notification)
        print("keyboardHeight", keyboardHeight)
        
        
        let gap = (view.safeAreaInsets.top + chatTableView.contentSize.height + keyboardHeight + inputTextContentView.frame.height) - self.view.frame.height
        let tableViewY = self.chatTableView.contentSize.height + self.view.safeAreaInsets.top
        let inputViewAndKeyboardY = self.view.frame.height - (keyboardHeight + self.inputTextContentView.frame.height)
        print("keyboardWillShow")
        print("self.chatTableView.contentSize.height self.view.safeAreaInsets.top", self.chatTableView.contentSize.height, self.view.safeAreaInsets.top)
        print("tableViewY inputViewAndKeyboardY", tableViewY, inputViewAndKeyboardY)
//        let margins = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight-view.safeAreaInsets.bottom, right: 0)
//        inputContentViewBottomMargin = inputTextContentView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -margins.bottom)
//        inputContentViewBottomMargin = inputTextContentView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -margins.bottom)
//        inputContentViewBottomMargin.isActive = true

        UIView.animate(withDuration: animationDuration) { [self] in
//            chatTableView.snp.updateConstraints {
//                $0.height.equalTo(view.safeAreaLayoutGuide.layoutFrame.height-keyboardHeight) // inputTextContentView.frame.height
//            }
            self.chatTableView.transform = CGAffineTransform(translationX: 0, y: -self.keyboardHeight + self.view.safeAreaInsets.bottom)
//            inputContentViewBottomMargin.isActive = true
//            inputTextContentView.layoutMargins = margins
//            inputTextContentView.frame.origin.y -= keyboardHeight
            view.layoutIfNeeded()
        }
        // Set the view's layout margins
//        inputContentViewBottomMargin.constant = keyboardHeight
//        inputTextContentView.layoutMargins.bottom.
//        inputTextContentView.snp.makeConstraints {
//            $0.bottomMargin.equalTo(keyboardHeight)
//        }
//        view.layoutIfNeeded()
//        self.inputTextContentView.transform = CGAffineTransform(translationX: 0, y: -self.keyboardHeight + self.view.safeAreaInsets.bottom)
//        chatTableView.heightAnchor.constraint(equalToConstant: view.safeAreaLayoutGuide.layoutFrame.height-keyboardHeight-inputTextContentView.frame.height).isActive = true
//        chatTableView.layoutIfNeeded()
//        let margin = keyboardHeight + inputTextContentView.frame.height
//        inputTextContentView.layoutIfNeeded()
//        chatTableView.snp.makeConstraints {
//            $0.height.greaterThanOrEqualTo(view.frame.height-keyboardHeight-inputTextContentView.frame.height-view.safeAreaInsets.top)
//        }
//        self.chatTableView.transform = CGAffineTransform(translationX: 0, y: -self.keyboardHeight + self.view.safeAreaInsets.bottom)

//        if gap > 0 {
//            chatTableView.transform = CGAffineTransform(translationX: 0, y: -gap)
//        }

        // gap에 따라 적용
        // contentsize 레이아웃 변경후
        // contentsize에 따라 올라가야함
//        UIView.animate(withDuration: animationDuration) { [self] in
//            inputTextContentView.transform = CGAffineTransform(translationX: 0, y: -self.keyboardHeight + self.view.safeAreaInsets.bottom)
//            if chatTableView.frame.height > chatTableView.contentSize.height {
//                chatTableView.transform = CGAffineTransform(translationX: 0, y: -self.keyboardHeight + self.view.safeAreaInsets.bottom)
//            } else {
//                if gap > 0 {
//                    chatTableView.transform = CGAffineTransform(translationX: 0, y: -self.keyboardHeight + self.view.safeAreaInsets.bottom - gap)
//                } else {
//
//                }
//            }
//            inputTextContentView.layoutIfNeeded()
//            chatTableView.layoutIfNeeded()
////            view.layoutIfNeeded()
//        }
    }

//    @objc func keyboardDidShow(_ notification: Notification) {
//        let userInfo = notification.userInfo!
//        let animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! TimeInterval
//        self.keyboardHeight = getKeyboardHeight(notification)
//        let tableViewY = self.chatTableView.contentSize.height + self.view.safeAreaInsets.top
//        let inputViewAndKeyboardY = self.view.frame.height - (keyboardHeight + self.inputTextContentView.frame.height)
//        print("keyboardWillShow")
//        print("self.chatTableView.contentSize.height self.view.safeAreaInsets.top", self.chatTableView.contentSize.height, self.view.safeAreaInsets.top)
//        print("tableViewY inputViewAndKeyboardY", tableViewY, inputViewAndKeyboardY)
//        UIView.animate(withDuration: animationDuration) {
////            self.inputTextContentView.transform = .identity
////            self.chatTableView.transform = .identity
////            if tableViewY > inputViewAndKeyboardY { // 테이블뷰 콘텐츠 사이즈 y > 입력화면 y
//////                self.view.frame.origin.y = -self.keyboardHeight
////            } else {
////                self.chatTableView.snp.makeConstraints {
////                    $0.height.equalTo(inputViewAndKeyboardY - self.view.safeAreaInsets.top)
////                }
//////                self.chatTableView.bottomAnchor.constraint(equalTo: ).isActive = true
////            }
//        }

//    }

    @objc func keyboardWillHide(_ notification: Notification) {
        let userInfo = notification.userInfo!
        let animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! TimeInterval
        let tableViewY = self.chatTableView.contentSize.height + self.view.safeAreaInsets.top
        let inputViewAndKeyboardY = self.view.frame.height - (keyboardHeight + self.inputTextContentView.frame.height)
        print("keyboardWillHiden")
        print("self.chatTableView.contentSize.height self.view.safeAreaInsets.top", self.chatTableView.contentSize.height, self.view.safeAreaInsets.top)
        print("tableViewY inputViewAndKeyboardY", tableViewY, inputViewAndKeyboardY)

        let margins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//        inputContentViewBottomMargin = inputTextContentView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -margins.bottom)
//        inputContentViewBottomMargin.isActive = false
        UIView.animate(withDuration: animationDuration) { [self] in
//            self.inputTextContentView.snp.makeConstraints {
//                $0.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(0)
//            }
//            print("heiden animate")
            if inputContentViewBottomMargin != nil {
                print("inputContentViewBottomMargin != nil")
                inputContentViewBottomMargin.isActive = false
            }
//            inputTextContentView.layoutMargins = margins
            view.layoutIfNeeded()
//            chatTableView.snp.makeConstraints {
//                $0.height.equalTo(view.safeAreaLayoutGuide.layoutFrame.height-inputTextContentView.frame.height) // inputTextContentView.frame.height
//            }
//            view.layoutIfNeeded()
//            inputTextContentView.layoutMargins = margins
//            self.view.layoutIfNeeded()
//            self.inputTextContentView.transform = .identity
//            self.chatTableView.snp.makeConstraints {
//                $0.height.lessThanOrEqualTo(self.view.safeAreaLayoutGuide.layoutFrame.height-self.inputTextContentView.frame.height)
//            }
//            self.chatTableView.snp.makeConstraints {
//    //            $0.edges.equalTo(view.safeAreaLayoutGuide)
//                $0.bottom.equalTo(self.inputTextContentView.snp.top)
//    //            $0.bottom.greaterThanOrEqualTo(inputTextContentView.snp.top)
//            }
//            self.view.frame.origin.y = 0
//            self.inputTextContentView.transform = .identity
//            self.chatTableView.transform = .identity
//            self.view.frame.origin.y = 0
        }
//        view.layoutIfNeeded()
//        chatTableView.snp.makeConstraints {
//            $0.height.equalTo(view.frame.height-view.safeAreaInsets.top-view.safeAreaInsets.bottom)
//        }
//        chatTableView.layoutIfNeeded()
//        inputTextContentView.layoutIfNeeded()
//        view.layoutIfNeeded()
//        chatTableView.snp.makeConstraints {
//            $0.bottomMargin.equalTo(0)
//        }
    }

//    @objc func keyboardDidHide(_ notification: Notification) {
//        let userInfo = notification.userInfo!
//        let animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! TimeInterval
//        let tableViewY = self.chatTableView.contentSize.height + self.view.safeAreaInsets.top
//        let inputViewAndKeyboardY = self.view.frame.height - (keyboardHeight + self.inputTextContentView.frame.height)
//        print("keyboardWillHiden")
//        print("self.chatTableView.contentSize.height self.view.safeAreaInsets.top", self.chatTableView.contentSize.height, self.view.safeAreaInsets.top)
//        print("tableViewY inputViewAndKeyboardY", tableViewY, inputViewAndKeyboardY)
//
//        UIView.animate(withDuration: animationDuration) {
//            self.inputTextContentView.transform = .identity
//            self.view.frame.origin.y = 0
////            self.inputTextContentView.transform = .identity
////            self.chatTableView.transform = .identity
////            self.view.frame.origin.y = 0
//        }
//    }

    func getRequest() {
        isPaging = true
        Task {
            self.chatTableView.tableFooterView = self.createSpiner()
            let result = await fetchClipBoardData(page: pageCursor, isPaging: isPaging)
            guard let clipBoardList = result?.getClipBoardResList else { return }
            guard let totalPage = result?.totalPage else { return }
            self.totalPage = totalPage
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2 , execute: {
                self.chatTableView.tableFooterView = nil
            })
            if self.pageCursor < self.totalPage {
                print("📌pageCursor totalPage isPaging", pageCursor, totalPage, isPaging)
                let startIdx = self.lastPageDataCount%10 // 시작 인덱스
                let listCnt = clipBoardList.count // 클립보드 리스트 개수
                let insertStartIdx = self.clipBoardData.count
                print("While starteInx, listCnt ", startIdx, listCnt) // 그전 데이터개수, 현재 데이터 개수
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2 , execute: {
                    for i in insertStartIdx..<insertStartIdx+listCnt-startIdx {
                        print("Index i", i)
                        self.clipBoardData.insert(clipBoardList[i%10], at: i)
                        self.chatTableView.insertRows(at: [IndexPath(row: i, section: 0)], with: .none)
                    }
                    let lastIndexPath = IndexPath(row: self.clipBoardData.count-1, section: 0)
                    self.chatTableView.scrollToRow(at: lastIndexPath, at: .bottom, animated: true)
//                    self.clipBoardData.append(contentsOf: clipBoardList[startIdx..<listCnt]) // 2 3
//                    self.chatTableView.reloadData()
                })
                self.lastPageDataCount = listCnt // 그전 페이지 0 , 마지막 페이지 10 일때 lastpagedat = 0이 될수있다.
                if self.lastPageDataCount == 10 { self.pageCursor += 1 }
            }
            isPaging = false
         }
    }

    // 스크롤시 업데이트시 일반적인 페이지네이션
    // sendbutton 누리면 리스트 빌때까지 요청 후, 비면 중지 (sendbutton 누리면 스크롤시 요청 팬딩) >> 팬딩 변수 필요
    // 그럼 따로 스크롤을 최 하단으로 내려줄 필요가 없음


    // 현재페이지 < 토탈페이지면 개속 요청 가능

    // 현제 페이지로 불러옴
    // 현재 페이지 < 토탈 페이지면
    @objc func sendButtonTapped(_ sender: UIButton) {
        // update tableview
        print("sendButtonTapped")

        guard let boardId = self.boardId else { return }
        guard let userItem = try? KeychainManager.getUserItem() else { return }
        let myChat = CreateClipBoardReq(boardID: boardId, content: chatTextView.text, refreshToken: userItem.refresh_token, title: "", userID: userItem.userId)
        Task {
            await postClipBoardData(chatData: myChat)
            chatTextView.text = ""
            chatTextView.isScrollEnabled = false
            //        chatTextView.reloadInputViews() // keyboard 업데이트 시작
            chatTextView.setNeedsUpdateConstraints()
            sendButton.isEnabled = false
            isPaging = true
            while true { // 2 3
                print("While문 실행")
                let result = await fetchClipBoardData(page: pageCursor, isPaging: isPaging)
                guard let clipBoardList = result?.getClipBoardResList else { return }
                guard let totalPage = result?.totalPage else { return }
                self.totalPage = totalPage
                if pageCursor >= self.totalPage { break } // 현재페이지와 전체페이지가 같으면 반혼
                print("📌pageCursor totalPage isPaging", pageCursor, totalPage, isPaging)
                let startIdx = self.lastPageDataCount%10 // 시작 인덱스
                let listCnt = clipBoardList.count // 클립보드 리스트 개수
                let insertStartIdx = self.clipBoardData.count
                print("While starteInx, listCnt ", startIdx, listCnt) // 그전 데이터개수, 현재 데이터 개수
                DispatchQueue.main.async {
                    for i in insertStartIdx..<insertStartIdx+listCnt-startIdx {
                        print("Index i", i)
                        self.clipBoardData.insert(clipBoardList[i%10], at: i)
                        self.chatTableView.insertRows(at: [IndexPath(row: i, section: 0)], with: .none)
                    }
//                    self.clipBoardData.append(contentsOf: clipBoardList[startIdx..<listCnt])
//                    self.chatTableView.reloadData()
                }
                self.lastPageDataCount = listCnt // 그전 페이지 0 , 마지막 페이지 10 일때 lastpagedat = 0이 될수있다.
                if self.lastPageDataCount == 10 { self.pageCursor += 1 }
                else { break }
            }
            print("반복문 탈출")
            self.isPaging = false
            DispatchQueue.main.async {
                let lastIndexPath = IndexPath(row: self.clipBoardData.count-1, section: 0)
                self.chatTableView.scrollToRow(at: lastIndexPath, at: .bottom, animated: true)
            }
        }
    }

//    private func getClipBoardData(page: Int, isPaging: Bool,completion: @escaping ([GetAllClipBoardsRes]?)->Void) {
//        guard let userItem = try? KeychainManager.getUserItem() else { return }
//        hostId = userItem.userId
//        guard let boardId = self.boardId else { return }
//        let getAllClipBoardsReq = GetAllClipBoardsReq(boardId: boardId, cursor: page, refreshToken: userItem.refresh_token, userId: userItem.userId)
//
//        AF.request(API.BASE_URL + "clipboards/all/board/\(boardId)/user/\(userItem.userId)",
//                   method: .post,
//                   parameters: getAllClipBoardsReq,
//                   encoder: JSONParameterEncoder.default) // default set body and Content-Type HTTP header field of an encoded request is set to application/json
//        .validate(statusCode: 200..<500)
//        .response { response in // reponseData
//            switch  response.result {
//            case .success:
//                debugPrint(response)
//                if let data = response.data {
//                    do{
//                        let decodedData = try JSONDecoder().decode(APIResponse<ClipBoardResInfo>.self, from: data)
////                        guard let commentList = decodedData.data else { return }
//
//                        print("클립보드 get 성공", decodedData.data)
//                        print("클립보드 리스트", decodedData.data?.getClipBoardResList)
//                        self.totalPage = decodedData.data?.totalPage ?? 0
//                        completion(decodedData.data?.getClipBoardResList)
////                        self.pageCursor += 1
////                        self.isPaging = false
//                    }
//                    catch{
//                        print(error.localizedDescription)
//                    }
//                }
//            case .failure(let error):
//                print("클립보드 get 실패")
//                print(error)
//            }
//        }
//    }

    private func postClipBoardData(chatData: CreateClipBoardReq) async {
//        let dataTask = AF.request(API.BASE_URL + "clipboards",
//                   method: .post,
//                   parameters: chatData,
//                                  encoder: JSONParameterEncoder.default).serializingDecodable(APIResponse<GetAllClipBoardsRes>.self)
        
        let dataTask = AlamofireManager.shared.session.request(ClipBoardRouter.createBoard(parameter: chatData)).validate(statusCode: 200..<401).serializingDecodable(APIResponse<ClipBoardResInfo>.self)
        let response = await dataTask.response
        let result = await dataTask.result
        let value = response.value
//        debugPrint(result)
//        debugPrint(value)


//        .validate(statusCode: 200..<500)
//        .response { response in // reponseData
//            switch response.result {
//            case .success:
//                debugPrint(response)
//                if let data = response.data {
//                    do{
//                        let decodedData = try JSONDecoder().decode(APIResponse<GetAllClipBoardsRes>.self, from: data)
//                        print("채팅 보낸후 클립보드 등록된 데이터", decodedData.data)
//                    }
//                    catch{
//                        print("클립보드 등록 파싱 실패")
//                        print(error.localizedDescription)
//                    }
//                }
//            case .failure(let error):
//                print("클립보드 등록 실패")
//                print(error)
//            }
//        }
    }

    private func fetchClipBoardData(page: Int, isPaging: Bool) async -> ClipBoardResInfo? {
        guard let userItem = try? KeychainManager.getUserItem() else { return nil }
        guard let boardId = self.boardId else { return nil }
        hostId = userItem.userId
        let getAllClipBoardsReq = GetAllClipBoardsReq(boardId: boardId, cursor: page, refreshToken: userItem.refresh_token, userId: userItem.userId)
//        let dataTask = AF.request(API.BASE_URL + "clipboards/all/board/\(boardId)/user/\(userItem.userId)",
//                                  method: .post,
//                                  parameters: getAllClipBoardsReq,
//                                            encoder: JSONParameterEncoder.default).serializingDecodable(APIResponse<ClipBoardResInfo>.self)
//
        let dataTask = AlamofireManager.shared.session.request(ClipBoardRouter.readBoard(parameter: getAllClipBoardsReq)).validate(statusCode: 200..<401).serializingDecodable(APIResponse<ClipBoardResInfo>.self)
        
        let response = await dataTask.response
        let result = await dataTask.result
        let value = response.value
//        debugPrint(result)
//        debugPrint(value)
        return value?.data
    }

    private func createSpiner() -> UIView {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 50))
        let spiner = UIActivityIndicatorView()
        spiner.center = footerView.center
        footerView.addSubview(spiner)
        spiner.startAnimating()
        return footerView
    }

}

extension ClipBoardViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
//        if textView.tag == 0 && text == "\n" { textView.resignFirstResponder() }

        // get the current text, or use an empty string if that failed
        let currentText = textView.text ?? ""

        // attempt to read the range they are trying to change, or exit if we can't
        guard let stringRange = Range(range, in: currentText) else { return false }

        // add their new text to the existing text
        let updatedText = currentText.replacingCharacters(in: stringRange, with: text)
        if currentText.count <= 0 {
            self.sendButton.isEnabled = false
        } else {
            self.sendButton.isEnabled = true
        }
        // make sure the result is under 16 characters
        print("붙여넣기 updatedText.count", updatedText.count)

        return updatedText.count <= 500
    }

    func textViewDidChange(_ textView: UITextView) {
        print("textViewDidChange")
//        let size = CGSize(width: textView.frame.size.width, height: .infinity)
//        let estimatedSize = textView.sizeThatFits(size)
//        print("size height, estimatedSize height", size.height, estimatedSize.height)
//        textView.sizeToFit()

//        textView.isScrollEnabled = false
        if textView.text.count <= 0 {
            self.sendButton.isEnabled = false
        } else {
            self.sendButton.isEnabled = true
        }
//        view.layoutIfNeeded()

//        inputTextContentView.snp.makeConstraints {
//            $0.height.equalTo(estimatedSize.height)
//        }
//        if estimatedSize.height >= 100 { textView.isScrollEnabled = true }
//        else { textView.isScrollEnabled = false }
        
//        if textView.frame.size.height >
//        textView.frame.size.height = textView.contentSize.height
//        view.layoutIfNeeded()
        if textView.contentSize.height <= 44 {
            textView.frame.size.height = 44
        }
        else if textView.contentSize.height >= 99 {
            textView.frame.size.height = 99
        }
        else{
            textView.frame.size.height = textView.contentSize.height
        }
//        view.layoutIfNeeded()
////        textView.setNeedsUpdateConstraints()
//        if estimatedSize.height < 100 { return }
//        textView.isScrollEnabled = true
//        if textView.contentSize.height <= 35 {
//            inputTextContentView.frame.height = 36
////            inputTextViewHeight.constant = 35
//        }
//        else if textView.contentSize.height >= 102{
//            inputTextContentView.frame.height = 102
//        }
//        else{
//            inputTextContentView.frame.height = textView.contentSize.height
//        }
//
//        // chatTableview 위치 변경 필요
//        if textView.contentSize.height <= 44 {
//            print("44")
//            inputTextContentView.snp.makeConstraints {
//                $0.height.equalTo(44)
//            }
//        } else if textView.contentSize.height >= 100 {
//            print("100")
//            inputTextContentView.snp.makeConstraints {
//                $0.height.equalTo(100)
//            }
//        } else {
//            print("other")
//            inputTextContentView.snp.makeConstraints {
//                $0.height.equalTo(textView.contentSize.height)
//            }
//        }
//        textView.setNeedsUpdateConstraints()
//        textView.reloadInputViews()
//        if estimatedSize.height < 100 { return }
////        print("넘음")
//        textView.isScrollEnabled = true
//        textView.reloadInputViews()
//        textView.setNeedsUpdateConstraints()

    }
}

extension ClipBoardViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("didSelectRowAt")
    }
}

extension ClipBoardViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("clipBoardData.count", clipBoardData.count)
        return clipBoardData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if clipBoardData[indexPath.row].userID == hostId {
            guard let myCell = tableView.dequeueReusableCell(withIdentifier: MyClipBoardTableViewCell.identifier, for: indexPath) as? MyClipBoardTableViewCell else { return UITableViewCell() }
            myCell.configure(coment: clipBoardData[indexPath.row].content, updateDate: clipBoardData[indexPath.row].updatedAt)
            myCell.layoutIfNeeded()
            return myCell
        } else {
            guard let yourCell = tableView.dequeueReusableCell(withIdentifier: YourClipBoardTableViewCell.identifier, for: indexPath) as? YourClipBoardTableViewCell else { return UITableViewCell() }
            yourCell.configure(userId: clipBoardData[indexPath.row].userID, imageUrl: clipBoardData[indexPath.row].profileImgURL, coment: clipBoardData[indexPath.row].content, updateDate: clipBoardData[indexPath.row].updatedAt)
            yourCell.layoutIfNeeded()
            return yourCell
        }
//        print("clipBoardData[indexPath.row].userID, hostId", indexPath.row, clipBoardData[indexPath.row].userID, hostId)
//        cell.configure(userId: clipBoardData[indexPath.row].userID, isMe: clipBoardData[indexPath.row].userID == hostId, imageUrl: clipBoardData[indexPath.row].profileImgURL, coment: clipBoardData[indexPath.row].content, updateDate: clipBoardData[indexPath.row].updatedAt)
//        cell.configure(userId: clipBoardData[indexPath.row].userID, isMe: true, imageUrl: "", coment: clipBoardData[indexPath.row].content, updateDate: "")
//        return cell
    }

//    func numberOfSections(in tableView: UITableView) -> Int {
//        return
//    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // 셀의 데이터 세팅이 완료 된 후 실제 높이 값을
        cellHeights[indexPath] = cell.frame.size.height
        print("cell 높이", cellHeights[indexPath])
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeights[indexPath] ?? UITableView.automaticDimension
    }


//    func infinitePaginationScroll() async {
//       Task {
//            isPaging = true
//            self.chatTableView.tableFooterView = createSpiner()
//            print("isPaging", isPaging)
//            print("📌 page", pageCursor)
//            let result = await fetchClipBoardData(page: pageCursor, isPaging: isPaging)
//            print("fetchClipBoardData result", result)
//            DispatchQueue.main.async {
//                self.chatTableView.tableFooterView = nil
//                self.clipBoardData.append(contentsOf: result ?? [])
//                self.chatTableView.reloadData()
//            }
//            pageCursor += 1
//            isPaging = false
//            print("isPaging", isPaging)
//            print("📌 page", pageCursor)
//        }
//    }
}


extension ClipBoardViewController: UIScrollViewDelegate {

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView.tag == 0 {
            if (scrollView.contentOffset.y > (scrollView.contentSize.height-50-scrollView.frame.size
                .height) && isPaging == false) {
                print("End bottom in scrollview")
                // 요청은 비동기, 결과값에 대한 동기 처리 (페이지중 변수. 테이블뷰 리로드)
                getRequest()
            }
        }
    }

    // 페이징이 가능할때 시점
    // 일반 페이지네이션은 괜찮다
    // send 버튼을 누른후에 어디까지 해야되나
    // sendbutton 보낸후 리스트 개수가 0이 반환될때까지 페이지수 증가하며 요청
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        if scrollView.tag == 0 {
//            if (scrollView.contentOffset.y > (scrollView.contentSize.height-50-scrollView.frame.size
//                .height) && isPaging == false) {
//                print("End bottom in scrollview")
//                // 요청은 비동기, 결과값에 대한 동기 처리 (페이지중 변수. 테이블뷰 리로드)
//                isPaging = true
//                Task {
//                    self.chatTableView.tableFooterView = self.createSpiner()
//                    let result = await fetchClipBoardData(page: pageCursor, isPaging: isPaging)
//                    guard let clipBoardList = result?.getClipBoardResList else { return }
//                    guard let totalPage = result?.totalPage else { return }
//                    self.totalPage = totalPage
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5 , execute: {
//                        self.chatTableView.tableFooterView = nil
//                    })
//                    if self.pageCursor < self.totalPage {
//                        print("📌pageCursor totalPage isPaging", pageCursor, totalPage, isPaging)
//                        let startIdx = self.lastPageDataCount%10 // 시작 인덱스
//                        let listCnt = clipBoardList.count // 클립보드 리스트 개수
//                        print("While starteInx, listCnt ", startIdx, listCnt) // 그전 데이터개수, 현재 데이터 개수
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5 , execute: {
//                            self.clipBoardData.append(contentsOf: clipBoardList[startIdx..<listCnt])
//                            self.chatTableView.reloadData()
//                        })
//                        self.lastPageDataCount = listCnt // 그전 페이지 0 , 마지막 페이지 10 일때 lastpagedat = 0이 될수있다.
//                        if self.lastPageDataCount == 10 { self.pageCursor += 1 }
//                    }
//                    isPaging = false
//                 }
//            }
//        }
//    }
}

// cursor <= totalpage
// 보통
// cursor <= totalpage 이고 ispage == false 일때 가능

// 반복문일때
// 리스트 개수 0 혹은 일의 자리면 스탑

//extension UIViewController {
//    func hideKeyboardWhenTappedAround2() {
//        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
//        tap.cancelsTouchesInView = false
//        view.addGestureRecognizer(tap)
//    }
//
//    @objc func dismissKeyboard2() {
//        view.endEditing(true)
//    }
//}
