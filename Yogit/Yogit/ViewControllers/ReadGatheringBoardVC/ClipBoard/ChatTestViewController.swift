//
//  ChatTestViewController.swift
//  Yogit
//
//  Created by Junseo Park on 2022/12/28.
//

import UIKit
import SnapKit
import Alamofire
import InputBarAccessoryView
import IQKeyboardManagerSwift
import Combine
//import MessageKit

class ChatTestViewController: UIViewController {
    
    // 초기값 끝 페이지 까지 불러온다.
    var totalPage = 0
    var lastPageDataCount = 0
    var pageCursor = 0
    var isPaging = false
    var boardId: Int64?
    var keyboardHeight: CGFloat?
    var chatTableViewHeight: NSLayoutConstraint?
    var clipBoardData: [GetAllClipBoardsRes] = []
    var cellHeights: [IndexPath : CGFloat] = [:]
    private var hostId: Int64?
    
    let inputBar = iMessageInputBar()
    
    override var inputAccessoryView: UIView? {
        return inputBar
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    // MARK: - View Life Cycle


    private lazy var chatTableView: UITableView = {
        let tableView = UITableView()
        tableView.isScrollEnabled = true
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.backgroundColor = .systemBackground
        tableView.layer.borderColor = UIColor.blue.cgColor
        tableView.layer.borderWidth = 1
//        tableView.sectionHeaderTopPadding = 16
        tableView.register(MyClipBoardTableViewCell.self, forCellReuseIdentifier: MyClipBoardTableViewCell.identifier)
        tableView.register(YourClipBoardTableViewCell.self, forCellReuseIdentifier: YourClipBoardTableViewCell.identifier)
//        tableView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard(_:))))
//        tableView.register(RequirementTableViewHeader.self, forHeaderFooterViewReuseIdentifier: RequirementTableViewHeader.identifier)
////        tableView.register(SetUpProfileTableViewFooter.self, forHeaderFooterViewReuseIdentifier: SetUpProfileTableViewFooter.identifier)
        return tableView
    }()


    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewCompoent()
//        view.addSubview(chatTextField)
        view.addSubview(chatTableView)
//        view.addSubview(inputTextContentView)
        chatTableView.tag = 1
//        chatTextView.tag = 1
//        view.addSubview(chatTextView)
//        view.addSubview(sendButton)
//        chatTextField.delegate = self
//        chatTextView.delegate = self
        chatTableView.delegate = self
        chatTableView.dataSource = self
        
//        chatTableView.keyboardDismissMode = .interactive
//        chatTableView.becomeFirstResponder()
//        getRequest()
        
        
        let myChat = GetAllClipBoardsRes(boardID: 0, clipBoardID: 0, commentCnt: 0, createdAt: "", profileImgURL: "", commentResList: [], content: "dfadsafasdfdsafadsfsdafdsafasdkfkdsafasdjfjsdlkfjdskljfkasdfkladsjfklasdjflkadsjflkjasdkofjadlskjflkasdjflkasdjlkfjasdlkjfalsdkflkjsdlkjfdlsakjflkadsjflkasdjflkjadsfjasdoifaosdifkasdnfklsdajfokjdaslkffjnadsknfkadsnflkadsnfkadnsfkldasnfknalkfnadsdslkfnasdlknfadslknfaldsknfldksnflksndflknasdnfasdlknfasdlknfadsknflkndsalfknasdkfaldsknfklsdnfknadslfknsdlkfndslknfldsknfasfklndsakfjnadsknfkadsnflkadsnfkadnsfkldasnfknalkfnadsklfnsdaknfadskjfudisafsadfkdsnakfnsadiofdsafndskfnsadoifasdflkdsnfoasdfdslfknsoifjndsdfadsafasdfdsafadsfsdafdsafasdkfkdsafasdjfjsdlkfjdskljfkasdfkladsjfklasdjflkadsjflkjasdkofjadlskjflkasdjflkasdjlkfjasdlkjfalsdkflkjsdlkjfdlsakjflkadsjflkasdjflkjadsfjasdoifaosdifkasdnfklsdajfokjdaslkffjnadsknfkadsnflkadsnfkadnsfkldasnfknalkfnadsdslkfnasdlknfadslknfaldsknfldksnflksndflknasdnfasdlknfasdlknfadsknflkndsalfknasdkfaldsknfklsdnfknadslfknsdlkfndslknfldsknfasfklndsakfjnadsknfkadsnflkadsnfkadnsfkldasnfknalkfnadsklfnsdaknfadskjfudisafsadfkdsnakfnsadiofdsafndskfnsadoifasdflkdsnfoasdfdslfknsoifjndsdfadsafasdfdsafadsfsdafdsafasdkfkdsafasdjfjsdlkfjdskljfkasdfkladsjfklasdjflkadsjflkjasdkofjadlskjflkasdjflkasdjlkfjasdlkjfalsdkflkjsdlkjfdlsakjflkadsjflkasdjflkjadsfjasdoifaosdifkasdnfklsdajfokjdaslkffjnadsknfkadsnflkadsnfkadnsfkldasnfknalkfnadsdslkfnasdlknfadslknfaldsknfldksnflksndflknasdnfasdlknfasdlknfadsknflkndsalfknasdkfaldsknfklsdnfknadslfknsdlkfndslknfldsknfasfklndsakfjnadsknfkadsnflkadsnfkadnsfkldasnfknalkfnadsklfnsdaknfadskjfudisafsadfkdsnakfnsadiofdsafndskfnsadoifasdflkdsnfoasdfdslfknsoifjndsdfadsafasdfdsafadsfsdafdsafasdkfkdsafasdjfjsdlkfjdskljfkasdfkladsjfklasdjflkadsjflkjasdkofjadlskjflkasdjflkasdjlkfjasdlkjfalsdkflkjsdlkjfdlsakjflkadsjflkasdjflkjadsfjasdoifaosdifkasdnfklsdajfokjdaslkffjnadsknfkadsnflkadsnfkadnsfkldasnfknalkfnadsdslkfnasdlknfadslknfaldsknfldksnflksndflknasdnfasdlknfasdlknfadsknflkndsalfknasdkfaldsknfklsdnfknadslfknsdlkfndslknfldsknfasfklndsakfjnadsknfkadsnflkadsnfkadnsfkldasnfknalkfnadsklfnsdaknfadskjfudisafsadfkdsnakfnsadiofdsafndskfnsadoifasdflkdsnfoasdfdslfknsoifjnds", status: "", updatedAt: "", title: "", userID: 0, userName: "")// CreateClipBoardReq(boardID: 0, content: chatTextView.text, refreshToken: "userItem.refresh_token", title: "", userID: 0)
        self.clipBoardData.append(myChat)
        let lastIndexPath = IndexPath(row: (self.clipBoardData.count ?? 1) - 1, section: 0)
        self.chatTableView.insertRows(at: [lastIndexPath], with: UITableView.RowAnimation.fade)
        self.chatTableView.scrollToRow(at: lastIndexPath, at: .bottom, animated: true)
        
        
        // Do any additional setup after loading the view.
    }

    override func viewDidLayoutSubviews() {
//        chatTableView.frame = view.bounds
//        view.layoutIfNeeded()
//        inputTextContentView.layoutIfNeeded()
//        chatTextView.layoutIfNeeded()
//        sendButton.layoutIfNeeded(
        NSLayoutConstraint.activate([
            chatTableView.topAnchor.constraint(equalTo: view.topAnchor),
            chatTableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            chatTableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            chatTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
        ])
        
        //chatTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),/
        
//        chatTableViewHeight = chatTableView.heightAnchor.constraint(equalTo: view.heightAnchor)
//
//        chatTableViewHeight?.isActive = true
        
//        view.layoutGuides
        
//        chatTableView.snp.makeConstraints {
//            $0.top.leading.trailing.bottom.equalToSuperview()
////            $0.bottom.equalTo(inputAccessoryView.snp.top)
//        }
        
        chatTableView.keyboardDismissMode = .onDrag
        inputBar.delegate = self
        inputBar.inputTextView.keyboardType = .default
    }
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidHide(_:)), name: UIResponder.keyboardDidHideNotification, object: nil)
    }

    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc func keyboardWillShow(_ notification: Notification) {
        let userInfo = notification.userInfo!
        let animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! TimeInterval
        print("willshow")
        keyboardHeight = getKeyboardHeight(notification)
    }

    @objc func keyboardDidShow(_ notification: Notification) {
        let userInfo = notification.userInfo!
        let animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! TimeInterval
        self.keyboardHeight = getKeyboardHeight(notification)
        let tableViewY = self.chatTableView.contentSize.height + self.view.safeAreaInsets.top
//        let inputViewAndKeyboardY = self.view.frame.height - (keyboardHeight + self.inputTextContentView.frame.height)
        print("keyboardWillShow")
        print("self.chatTableView.contentSize.height self.view.safeAreaInsets.top", self.chatTableView.contentSize.height, self.view.safeAreaInsets.top)
//        print("tableViewY inputViewAndKeyboardY", tableViewY, inputViewAndKeyboardY)
        UIView.animate(withDuration: animationDuration) {
//            self.inputTextContentView.transform = .identity
//            self.chatTableView.transform = .identity
//            if tableViewY > inputViewAndKeyboardY { // 테이블뷰 콘텐츠 사이즈 y > 입력화면 y
////                self.view.frame.origin.y = -self.keyboardHeight
//            } else {
//                self.chatTableView.snp.makeConstraints {
//                    $0.height.equalTo(inputViewAndKeyboardY - self.view.safeAreaInsets.top)
//                }
////                self.chatTableView.bottomAnchor.constraint(equalTo: ).isActive = true
//            }
        }

    }

    @objc func keyboardWillHide(_ notification: Notification) {
        let userInfo = notification.userInfo!
        let animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! TimeInterval
        print("keyboard Will hiden")
//        chatTableView.contentSize.height -= keyboardHeight ?? 0
//        chatTableView.contentSize.height -= 50
    }
//
    @objc func keyboardDidHide(_ notification: Notification) {
        let userInfo = notification.userInfo!
        let animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! TimeInterval
        print("keyboard Did hiden")
//        if chatTableView.frame.height < chatTableView.contentSize.height {
//            chatTableView.contentSize.height = chatTableView.frame.height + keyboardHeight!//view.safeAreaInsets.bottom
//        }
//        chatTableView.contentSize.height -= keyboardHeight ?? 0
//        chatTableView.contentSize.height -= 50
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
//
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if scrollView.tag == 1 {
            print("scrol bigin dragg")
//            chatTextView.reloadInputViews()
//            chatTextView.setNeedsUpdateConstraints()
//            self.view.endEditing(true)
        }
    }

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
//    @objc func sendButtonTapped(_ sender: UIButton) {
//        // update tableview
//        print("sendButtonTapped")
//
////        let myChat = GetAllClipBoardsRes(boardID: 0, clipBoardID: 0, commentCnt: 0, createdAt: "", profileImgURL: "", commentResList: [], content: chatTextView.text, status: "", updatedAt: "", title: "", userID: 0, userName: "")// CreateClipBoardReq(boardID: 0, content: chatTextView.text, refreshToken: "userItem.refresh_token", title: "", userID: 0)
////        clipBoardData.append(myChat)
////        let lastindexPath = IndexPath(row: self.clipBoardData.count - 1, section: 0)
////        chatTableView.insertRows(at: [lastindexPath], with: UITableView.RowAnimation.fade)
////        chatTextView.text = ""
////        chatTextView.isScrollEnabled = false
////        sendButton.isEnabled = false
////        let lastIndexPath = IndexPath(row: self.clipBoardData.count-1, section: 0)
////        self.chatTableView.scrollToRow(at: lastIndexPath, at: .bottom, animated: true)
////        chatTextView.reloadInputViews()
//
//
////        guard let boardId = self.boardId else { return }
////        guard let userItem = try? KeychainManager.getUserItem() else { return }
////        let myChat = CreateClipBoardReq(boardID: boardId, content: chatTextView.text, refreshToken: userItem.refresh_token, title: "", userID: userItem.userId)
////        Task {
////            await postClipBoardData(chatData: myChat)
////            chatTextView.text = ""
////            chatTextView.isScrollEnabled = false
////            //        chatTextView.reloadInputViews() // keyboard 업데이트 시작
////            chatTextView.setNeedsUpdateConstraints()
////            sendButton.isEnabled = false
////            isPaging = true
////            while true { // 2 3
////                print("While문 실행")
////                let result = await fetchClipBoardData(page: pageCursor, isPaging: isPaging)
////                guard let clipBoardList = result?.getClipBoardResList else { return }
////                guard let totalPage = result?.totalPage else { return }
////                self.totalPage = totalPage
////                if pageCursor >= self.totalPage { break } // 현재페이지와 전체페이지가 같으면 반혼
////                print("📌pageCursor totalPage isPaging", pageCursor, totalPage, isPaging)
////                let startIdx = self.lastPageDataCount%10 // 시작 인덱스
////                let listCnt = clipBoardList.count // 클립보드 리스트 개수
////                let insertStartIdx = self.clipBoardData.count
////                print("While starteInx, listCnt ", startIdx, listCnt) // 그전 데이터개수, 현재 데이터 개수
////                DispatchQueue.main.async {
////                    for i in insertStartIdx..<insertStartIdx+listCnt-startIdx {
////                        print("Index i", i)
////                        self.clipBoardData.insert(clipBoardList[i%10], at: i)
////                        self.chatTableView.insertRows(at: [IndexPath(row: i, section: 0)], with: .none)
////                    }
//////                    self.clipBoardData.append(contentsOf: clipBoardList[startIdx..<listCnt])
//////                    self.chatTableView.reloadData()
////                }
////                self.lastPageDataCount = listCnt // 그전 페이지 0 , 마지막 페이지 10 일때 lastpagedat = 0이 될수있다.
////                if self.lastPageDataCount == 10 { self.pageCursor += 1 }
////                else { break }
////            }
////            print("반복문 탈출")
////            self.isPaging = false
////            DispatchQueue.main.async {
////                let lastIndexPath = IndexPath(row: self.clipBoardData.count-1, section: 0)
////                self.chatTableView.scrollToRow(at: lastIndexPath, at: .bottom, animated: true)
////            }
////        }
//    }

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
        let dataTask = AF.request(API.BASE_URL + "clipboards",
                   method: .post,
                   parameters: chatData,
                                  encoder: JSONParameterEncoder.default).serializingDecodable(APIResponse<GetAllClipBoardsRes>.self)
        let response = await dataTask.response
        let result = await dataTask.result
        let value = response.value
        debugPrint(result)
        debugPrint(value)


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
        let dataTask = AF.request(API.BASE_URL + "clipboards/all/board/\(boardId)/user/\(userItem.userId)",
                                  method: .post,
                                  parameters: getAllClipBoardsReq,
                                            encoder: JSONParameterEncoder.default).serializingDecodable(APIResponse<ClipBoardResInfo>.self)
        let response = await dataTask.response
        let result = await dataTask.result
        let value = response.value
        debugPrint(result)
        debugPrint(value)
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

extension ChatTestViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("didSelectRowAt")
    }
}

extension ChatTestViewController: UITableViewDataSource {
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


    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cellHeights[indexPath] = cell.frame.size.height
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeights[indexPath] ?? UITableView.automaticDimension
    }
}
//

extension ChatTestViewController: UIScrollViewDelegate {

//    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//        if scrollView.tag == 1 {
//            if (scrollView.contentOffset.y > (scrollView.contentSize.height-50-scrollView.frame.size
//                .height) && isPaging == false) {
//                print("End bottom in scrollview")
//                // 요청은 비동기, 결과값에 대한 동기 처리 (페이지중 변수. 테이블뷰 리로드)
//                getRequest()
//            }
//        }
//    }

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


extension ChatTestViewController: InputBarAccessoryViewDelegate {
    
    // MARK: - InputBarAccessoryViewDelegate
    
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        
        // Here we can parse for which substrings were autocompleted
        let attributedText = inputBar.inputTextView.attributedText!
        let range = NSRange(location: 0, length: attributedText.length)
        attributedText.enumerateAttribute(.autocompleted, in: range, options: []) { (attributes, range, stop) in
            
            let substring = attributedText.attributedSubstring(from: range)
            let context = substring.attribute(.autocompletedContext, at: 0, effectiveRange: nil)
            print("Autocompleted: `", substring, "` with context: ", context ?? [])
        }

        inputBar.inputTextView.text = String()
        inputBar.invalidatePlugins()
        

        // Send button activity animation
        inputBar.sendButton.startAnimating()
        inputBar.inputTextView.placeholder = "Sending..."
        DispatchQueue.global(qos: .default).async {
            // fake send request task
            sleep(1)
            DispatchQueue.main.async { [weak self] in
                inputBar.sendButton.stopAnimating()
                inputBar.inputTextView.placeholder = "Aa"
                let myChat = GetAllClipBoardsRes(boardID: 0, clipBoardID: 0, commentCnt: 0, createdAt: "", profileImgURL: "", commentResList: [], content: text, status: "", updatedAt: "", title: "", userID: 0, userName: "")// CreateClipBoardReq(boardID: 0, content: chatTextView.text, refreshToken: "userItem.refresh_token", title: "", userID: 0)
                self?.clipBoardData.append(myChat)
                let lastIndexPath = IndexPath(row: (self?.clipBoardData.count ?? 1) - 1, section: 0)
                self?.chatTableView.insertRows(at: [lastIndexPath], with: UITableView.RowAnimation.fade)
                self?.chatTableView.scrollToRow(at: lastIndexPath, at: .bottom, animated: true)
                
                
                
//                self?.conversation.messages.append(SampleData.Message(user: SampleData.shared.currentUser, text: text))
//                let indexPath = IndexPath(row: (self?.conversation.messages.count ?? 1) - 1, section: 0)
//                self?.tableView.insertRows(at: [indexPath], with: .automatic)
//                self?.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
            }
        }
    }
    
    func inputBar(_ inputBar: InputBarAccessoryView, didChangeIntrinsicContentTo size: CGSize) {
        // Adjust content insets
        print(size)
        chatTableView.contentInset.bottom = size.height + 300 // keyboard size estimate
    }
    
    @objc func inputBar(_ inputBar: InputBarAccessoryView, textViewTextDidChangeTo text: String) {
        
//        guard autocompleteManager.currentSession != nil, autocompleteManager.currentSession?.prefix == "#" else { return }
        // Load some data asyncronously for the given session.prefix
//        DispatchQueue.global(qos: .default).async {
//            // fake background loading task
//            var array: [AutocompleteCompletion] = []
//            for _ in 1...10 {
//                array.append(AutocompleteCompletion(text: Lorem.word()))
//            }
//            sleep(1)
//            DispatchQueue.main.async { [weak self] in
//                self?.asyncCompletions = array
//                self?.autocompleteManager.reloadData()
//            }
//        }
    }
    
}

//extension ChatTestViewController {
//  // MARK: Internal
//
//  // MARK: - Register Observers
//
//  internal func addKeyboardObservers() {
//    KeyboardManager().bind(inputAccessoryView: inputBar)
//    KeyboardManager().bind(to: chatTableView)
//
//    /// Observe didBeginEditing to scroll content to last item if necessary
//    NotificationCenter.default
//      .publisher(for: UITextView.textDidBeginEditingNotification)
//      .subscribe(on: DispatchQueue.global())
//      /// Wait for inputBar frame change animation to end
//      .delay(for: .milliseconds(200), scheduler: DispatchQueue.main)
//      .receive(on: DispatchQueue.main)
//      .sink { [weak self] notification in
//        self?.handleTextViewDidBeginEditing(notification)
//      }
//      .store(in: &disposeBag)
//
//    NotificationCenter.default
//      .publisher(for: UITextView.textDidChangeNotification)
//      .subscribe(on: DispatchQueue.global())
//      .receive(on: DispatchQueue.main)
//      .compactMap { $0.object as? InputTextView }
//      .filter { [weak self] textView in
//          textView == self?.inputBar.inputTextView
//      }
//      .map(\.text)
//      .removeDuplicates()
//      .delay(for: .milliseconds(50), scheduler: DispatchQueue.main) /// Wait for next runloop to lay out inputView properly
//      .sink { [weak self] _ in
//        self?.updateMessageCollectionViewBottomInset()
//
//        if !(self?.maintainPositionOnInputBarHeightChanged ?? false) {
//          self?.messagesCollectionView.scrollToLastItem()
//        }
//      }
//      .store(in: &disposeBag)
//
//    /// Observe frame change of the input bar container to update collectioView bottom inset
//    inputBar.publisher(for: \.center)
//      .receive(on: DispatchQueue.main)
//      .removeDuplicates()
//      .sink(receiveValue: { [weak self] _ in
//        self?.updateMessageCollectionViewBottomInset()
//      })
//      .store(in: &disposeBag)
//  }
//
//  // MARK: - Updating insets
//
//  /// Updates bottom messagesCollectionView inset based on the position of inputContainerView
//  internal func updateMessageCollectionViewBottomInset() {
//    let collectionViewHeight = messagesCollectionView.frame.maxY
//    let newBottomInset = collectionViewHeight - (inputContainerView.frame.minY - additionalBottomInset) -
//      automaticallyAddedBottomInset
//    let normalizedNewBottomInset = max(0, newBottomInset)
//    let differenceOfBottomInset = newBottomInset - messageCollectionViewBottomInset
//
//    UIView.performWithoutAnimation {
//      guard differenceOfBottomInset != 0 else { return }
//      messagesCollectionView.contentInset.bottom = normalizedNewBottomInset
//      messagesCollectionView.verticalScrollIndicatorInsets.bottom = newBottomInset
//    }
//  }
//
//  // MARK: Private
//
//  /// UIScrollView can automatically add safe area insets to its contentInset,
//  /// which needs to be accounted for when setting the contentInset based on screen coordinates.
//  ///
//  /// - Returns: The distance automatically added to contentInset.bottom, if any.
//  private var automaticallyAddedBottomInset: CGFloat {
//    messagesCollectionView.adjustedContentInset.bottom - messageCollectionViewBottomInset
//  }
//
//  private var messageCollectionViewBottomInset: CGFloat {
//    messagesCollectionView.contentInset.bottom
//  }
//
//  /// UIScrollView can automatically add safe area insets to its contentInset,
//  /// which needs to be accounted for when setting the contentInset based on screen coordinates.
//  ///
//  /// - Returns: The distance automatically added to contentInset.top, if any.
//  private var automaticallyAddedTopInset: CGFloat {
//    messagesCollectionView.adjustedContentInset.top - messageCollectionViewTopInset
//  }
//
//  private var messageCollectionViewTopInset: CGFloat {
//    messagesCollectionView.contentInset.top
//  }
//
//  // MARK: - Private methods
//
//  private func handleTextViewDidBeginEditing(_ notification: Notification) {
//    guard
//      scrollsToLastItemOnKeyboardBeginsEditing,
//      let inputTextView = notification.object as? InputTextView,
//      inputTextView === messageInputBar.inputTextView
//    else {
//      return
//    }
//    messagesCollectionView.scrollToLastItem()
//  }
//}
//
//
////extension ChatTestViewController {
//  final class State {
//    /// Pan gesture for display the date of message by swiping left.
//    var panGesture: UIPanGestureRecognizer?
//    var maintainPositionOnInputBarHeightChanged = false
//    var scrollsToLastItemOnKeyboardBeginsEditing = false
//
//    let inputContainerView: MessagesInputContainerView = .init()
//    @Published var inputBarType: MessageInputBarKind = .messageInputBar
//    let keyboardManager = KeyboardManager()
//    var disposeBag: Set<AnyCancellable> = .init()
//  }
//
//  // MARK: - Getters
//
//  var keyboardManager: KeyboardManager { state.keyboardManager }
//
//  var panGesture: UIPanGestureRecognizer? {
//    get { state.panGesture }
//    set { state.panGesture = newValue }
//  }
//
//  var disposeBag: Set<AnyCancellable> {
//    get { state.disposeBag }
//    set { state.disposeBag = newValue }
//  }
//}
