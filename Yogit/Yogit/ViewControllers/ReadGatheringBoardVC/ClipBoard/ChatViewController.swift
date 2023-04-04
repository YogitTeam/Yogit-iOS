//
//  ChatViewController.swift
//  Yogit
//
//  Created by Junseo Park on 2022/12/28.
//

// 내가 스트링 줌
// 스트링으로 준값은 바뀌지 않음
// date utc로 저장 >> date를 string 변환시 timezone current로 변환

import UIKit
import InputBarAccessoryView
import IQKeyboardManagerSwift
import MessageKit

struct Sender: SenderType {
    var senderId: String
    var displayName: String
}

struct Message: MessageType {
    var sender: SenderType
    var messageId: String
    var sentDate: Date
    var kind: MessageKind
}

class ChatViewController: MessagesViewController, MessagesDataSource {

    var currentUser = Sender(senderId: "me", displayName: "MyName")
    let service = Sender(senderId: "SERVICE", displayName: "Yogit")
    var boardId: Int64?
    var downPageCursor = -1
    var upPageCusor = 0
    var upPageListCount = 0
    var isPaging: Bool = false
    var isLoading: Bool = false
    var oldMessageDate: String = ""
    var currentSender: SenderType {
        currentUser
    }
    
    lazy var audioController = BasicAudioController(messageCollectionView: messagesCollectionView)

    var messages = [MessageType]()
    var avatarImages: [String:UIImage] = ["SERVICE":UIImage(named: "ServiceIcon")!]
    
    let modular = 10
    let serviceNotice = "📢" + "CLIPBOARD_SERVICE_NOTICE".localized()
    lazy var serviceMessageId = upPageCusor*modular+upPageListCount
    
    private let messageFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        if let localeIdentifier = Locale.preferredLanguages.first {
            dateFormatter.locale = Locale(identifier: localeIdentifier)
        }
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        dateFormatter.timeZone = .current//TimeZone(identifier: "UTC")
        return dateFormatter
    }()
    
//    func messageCenterFormatter: DateFormatter = {
//        let dateFormatter = DateFormatter()
//        if let localeIdentifier = Locale.preferredLanguages.first {
//            dateFormatter.locale = Locale(identifier: localeIdentifier)
//        }
//        dateFormatter.dateStyle = .none
//        dateFormatter.timeStyle = .short
//        dateFormatter.timeZone = .current
//        return dateFormatter
//    }()
    
//    func configureDateFormatter(for date: Date) {
//      switch true {
//      case Calendar.current.isDateInToday(date) || Calendar.current.isDateInYesterday(date):
//        formatter.doesRelativeDateFormatting = true
//        formatter.dateStyle = .short
//        formatter.timeStyle = .short
//      case Calendar.current.isDate(date, equalTo: Date(), toGranularity: .weekOfYear):
//        formatter.dateFormat = "EEEE h:mm a"
//      case Calendar.current.isDate(date, equalTo: Date(), toGranularity: .year):
//        formatter.dateFormat = "E, d MMM, h:mm a"
//      default:
//        formatter.dateFormat = "MMM d, yyyy, h:mm a"
//      }
//    }

    func messageDateCenterFormatter(date: Date) -> String {
        let dateFormatter = DateFormatter()
        if let localeIdentifier = Locale.preferredLanguages.first {
            dateFormatter.locale = Locale(identifier: localeIdentifier)
        } else {
        }
        if Calendar.current.isDateInToday(date) || Calendar.current.isDateInYesterday(date) {
            dateFormatter.doesRelativeDateFormatting = true
            dateFormatter.dateStyle = .short
        } else {
            dateFormatter.dateStyle = .full
            dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "EdMMM", options: 0, locale: dateFormatter.locale)
        }
        dateFormatter.timeZone = .current//TimeZone(identifier: "UTC")
        return dateFormatter.string(from: date)
    }
    
//    private(set) lazy var refreshControl: UIRefreshControl = {
//      let control = UIRefreshControl()
//        control.addTarget(self, action: #selector(loadClipBoardDown), for: .valueChanged)
//       control.transform = CGAffineTransformMakeScale(0.5, 0.5)
//      return control
//    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewComponent()
        configureCurrentUser()
        configureMessageCollectionView()
        configureMessageInputBar()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("😀appear")
        IQKeyboardManager.shared.enable = false
    }
   
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("🥲disappear")
        IQKeyboardManager.shared.enable = true
    }
    
    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }
    
    override func collectionView(_: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        print("shouldShowMenuForItemAt", indexPath.section)
        let message = getTheMessageText(messageKind: messages[indexPath.section].kind)
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let copy = UIAlertAction(title: "Copy", style: .default) { (action) in
            UIPasteboard.general.string = message
        }
        let report = UIAlertAction(title: "Report", style: .destructive) { (action) in
            guard let clipBoardId = Int64(self.messages[indexPath.section].messageId) else { return }
            guard let reportedUserId = Int64(self.messages[indexPath.section].sender.senderId) else { return }
            self.reportClipboard(content: message, clipBoardId: clipBoardId, reportedUserId: reportedUserId)
        }
        alert.addAction(copy)
        alert.addAction(report)
        alert.addAction(cancel)
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
        return true
    }
    
    private func reportClipboard(content: String, clipBoardId: Int64, reportedUserId: Int64) {
        DispatchQueue.main.async(qos: .userInteractive, execute: {
            let RVC = ReportViewController()
            RVC.reportKind = .clipboardReport
            RVC.reportedUserId = reportedUserId
            RVC.reportedClipBoardId = clipBoardId
            RVC.reportContentString = content
            RVC.modalPresentationStyle = .fullScreen
            let navigationController = UINavigationController(rootViewController: RVC)
            navigationController.modalPresentationStyle = .fullScreen
            self.present(navigationController, animated: true, completion: nil)
        })
    }
    
    private func getTheMessageText(messageKind: MessageKind) -> String {
        var message: String = ""
        if case .text(let value) = messageKind {
            message = value
        }
        return message
    }
    
    func configureViewComponent() {
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.title = "ClipBoard"
    }
    
    func configureCurrentUser() {
        guard let identifier = UserDefaults.standard.object(forKey: SessionManager.currentServiceTypeIdentifier) as? String, let userItem = try? KeychainManager.getUserItem(serviceType: identifier) else { return }
        guard let displayName = userItem.userName else { return }
        currentUser = Sender(senderId: "\(userItem.userId)", displayName: displayName)
    }
    
    func configureMessageCollectionView() {
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messageCellDelegate = self
        scrollsToLastItemOnKeyboardBeginsEditing = true // default false
        maintainPositionOnInputBarHeightChanged = true // default false
//        messagesCollectionView.refreshControl = refreshControl
    }

    func configureMessageInputBar() {
        messageInputBar.delegate = self
        
        messageInputBar.inputTextView.textContainerInset = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 36)
        messageInputBar.inputTextView.placeholderLabelInsets = UIEdgeInsets(top: 8, left: 20, bottom: 8, right: 36)

        messageInputBar.inputTextView.backgroundColor = .systemGray6
        messageInputBar.inputTextView.placeholder = ""
        messageInputBar.inputTextView.layer.borderWidth = 0.5
        messageInputBar.inputTextView.layer.borderColor = UIColor.systemGray5.cgColor
        messageInputBar.inputTextView.layer.cornerRadius = 16.0
        messageInputBar.inputTextView.layer.masksToBounds = true
        messageInputBar.inputTextView.scrollIndicatorInsets = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        messageInputBar.setRightStackViewWidthConstant(to: 38, animated: false)
        messageInputBar.setStackViewItems([ messageInputBar.sendButton, InputBarButtonItem.fixedSpace(2)], forStack: .right, animated: false)
        messageInputBar.sendButton.imageView?.backgroundColor = UIColor(rgb: 0x3232FF, alpha: 1.0)
        messageInputBar.sendButton.configuration?.contentInsets =  NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
        messageInputBar.sendButton.setSize(CGSize(width: 36, height: 36), animated: false)
        messageInputBar.sendButton.image = UIImage(named: "chat_up")!
        messageInputBar.sendButton.title = nil
        messageInputBar.sendButton.imageView?.layer.cornerRadius = 16
//        messageInputBar.backgroundView.backgroundColor 
        messageInputBar.sendButton.backgroundColor = .clear
        messageInputBar.sendButton.setTitleColor(
        UIColor.systemBlue.withAlphaComponent(0.3),
        for: .highlighted)
    }
    
    
    func fetchClipBoardData(page: Int) async -> ClipBoardResInfo? {
        guard let identifier = UserDefaults.standard.object(forKey: SessionManager.currentServiceTypeIdentifier) as? String, let userItem = try? KeychainManager.getUserItem(serviceType: identifier) else { return nil }
        guard let boardId = self.boardId else { return nil }
        let getAllClipBoardsReq = GetAllClipBoardsReq(boardId: boardId, cursor: page, refreshToken: userItem.refresh_token, userId: userItem.userId)
        let dataTask = AlamofireManager.shared.session.request(ClipBoardRouter.readBoard(parameters: getAllClipBoardsReq)).validate(statusCode: 200..<501).serializingDecodable(APIResponse<ClipBoardResInfo>.self)
        let response = await dataTask.response
        let value = response.value
        return value?.data
    }
    
//    func fetchClipBoardData(getAllClipBoardsReq: GetAllClipBoardsReq) async throws -> ClipBoardResInfo {
////        guard let userItem = try? KeychainManager.getUserItem() else { throw FetchError.notFoundKeyChain }
////        guard let boardId = self.boardId else { throw FetchError.notFoundBoardId }
////        let getAllClipBoardsReq = GetAllClipBoardsReq(boardId: boardId, cursor: page, refreshToken: userItem.refresh_token, userId: userItem.userId)
//        let dataTask = AlamofireManager.shared.session.request(ClipBoardRouter.readBoard(parameters: getAllClipBoardsReq)).validate(statusCode: 200..<501).serializingDecodable(APIResponse<ClipBoardResInfo>.self)
//        let response = await dataTask.response
//        switch response.result {
//        case .success:
//        if let value = response.value, value.httpCode == 200, let data = value.data {
//            return data
//        } else {
//            throw FetchError.badResponse
//        }
//        case .failure: throw FetchError.failureResponse
//        }
////        let value = response.value
////        guard let data = value?.data else { throw FetchError.notFoundBoardId }
////        return value?.data
//    }
//    
//    func createClipBoardData(boardData: CreateClipBoardReq) async -> GetAllClipBoardsRes? {
//        let dataTask = AlamofireManager.shared.session.request(ClipBoardRouter.createBoard(parameters: boardData)).validate(statusCode: 200..<501).serializingDecodable(APIResponse<GetAllClipBoardsRes>.self)
//        let response = await dataTask.response
////        let result = await dataTask.result
//        let value = response.value
//        return value?.data
//    }
    
    func createClipBoardData2(boardData: CreateClipBoardReq) async throws -> GetAllClipBoardsRes {
        let dataTask = AlamofireManager.shared.session.request(ClipBoardRouter.createBoard(parameters: boardData)).validate(statusCode: 200..<501).serializingDecodable(APIResponse<GetAllClipBoardsRes>.self)
        let response = await dataTask.response
        switch response.result {
        case .success:
            print("createClipBoardData2 success")
        if let value = response.value, (value.httpCode == 200 || value.httpCode == 201), let data = value.data {
            return data
        } else {
            throw CreateError.badResponse
        }
        case let .failure(error):
            print("createClipBoardData2 error", error)
            throw CreateError.failureResponse
        }
    }
    
    // totalpage는 마지막 페이지+1
    // totalpage 전 페이지 load, 개수 10개보다 작으면 그전 페이지까지 load
    // 상하 페이징 로드 해서 메모리 최적화
    // 상
    // 하
    
//    // 마지막 페이지부터 로드
//    // if upPageListCount == 10 { upPageCusor += 1 } 다음에 호출할때
//    func loadFirstMessages() async {
//        if isPaging { return }
//        else { isPaging = true }
//        print("loadFirstMessages")
//        let checkLastData = await fetchClipBoardData(page: upPageCusor)
//        guard let totalPage = checkLastData?.totalPage else { return }
//        if upPageCusor < totalPage { // page 0부터 시작
//            upPageCusor = totalPage-1 // 0 부터 시작
//            downPageCursor = upPageCusor-1
//            let loadFirst = await fetchClipBoardData(page: upPageCusor) // 0
//            guard let clipBoardList = loadFirst?.getClipBoardResList else { return }
//            let clipBoardListCount = clipBoardList.count
//            guard let userItem = try? KeychainManager.getUserItem() else { return }
//            for i in upPageListCount..<clipBoardListCount { // 8
//                print("upPageListCount, clipBoardListCount", self.upPageListCount, clipBoardListCount)
//                let sender = Sender(senderId: "\(clipBoardList[i].userID)", displayName:  clipBoardList[i].userName)
//                if self.avatarImages[sender.senderId] == nil {
////                    let profileImage = await clipBoardList[i].profileImgURL.urlToImage()
////                    self.avatarImages[sender.senderId] = profileImage
//                    clipBoardList[i].profileImgURL.loadImage { (image) in
//                        guard let image = image else {
//                            print("Error loading image")
//                            return
//                        }
//                        print("아바타 이미지 로드")
//                        self.avatarImages[sender.senderId] = image
//                    }
//                }
//                if userItem.userId == clipBoardList[i].userID {
//                    self.currentUser.senderId = "\(clipBoardList[i].userID)"
//                    self.currentUser.displayName = clipBoardList[i].userName
//                }
//                guard let sendDate = clipBoardList[i].createdAt.stringToDate() else { return }
//                let message = Message(sender: sender, messageId: "\(clipBoardList[i].clipBoardID)", sentDate: sendDate, kind: .text(clipBoardList[i].content))
//                messages.append(message)
//            }
//            upPageListCount = clipBoardListCount%10
//            if upPageListCount == 0 {
//                upPageCusor += 1
//            }
//        }
//        let serviceMessage = Message(sender: self.service, messageId: "\(self.upPageCusor*10+self.upPageListCount)", sentDate: Date(), kind: .text("📢 This is not realtime chatting\n      Please need scroll"))
//        messages.append(serviceMessage)
//        messagesCollectionView.reloadData()
//        messagesCollectionView.scrollToLastItem()
//        isPaging = false
//    }
    
    func textCell(for _: MessageType, at _: IndexPath, in _: MessagesCollectionView) -> UICollectionViewCell? {
      nil
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        print("messages[indexPath.section]", indexPath.section)
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        print("messages.count", messages.count)
        return messages.count
    }
    
   
    func isLastSectionVisible() -> Bool {
      guard !messages.isEmpty else { return false }

      let lastIndexPath = IndexPath(item: 0, section: messages.count - 1)
    
      return messagesCollectionView.indexPathsForVisibleItems.contains(lastIndexPath)
    }
    
    
    func insertMessage(_ message: Message) {
        print("삽입전 개수", messages.count)
        
        messages.append(message)
        messagesCollectionView.insertSections([messages.count - 1])
        
//        messagesCollectionView.performBatchUpdates({
//            messages.append(message)
//            messagesCollectionView.insertSections([messages.count - 1])
//            if messages.count >= 2 {
//                messagesCollectionView.reloadSections([messages.count - 2])
//            }
//        })
        print("삽입후 개수", messages.count)
//        if messages.count >= 2 {
//          messagesCollectionView.reloadSections([messages.count - 2])
//        }
//        if isLastSectionVisible() == true {
//          messagesCollectionView.scrollToLastItem(animated: true)
//        }
//        print("삽입후 개수", messages.count)
        
        
        
//      messagesCollectionView.performBatchUpdates({
//        messagesCollectionView.insertSections([messages.count - 1])
//          print("삽입후 개수", messages.count)
//      })
    }
    
    func insertFirst(_ message: Message) {
        messagesCollectionView.performBatchUpdates({
            messages.removeLast()
            messagesCollectionView.deleteSections([messages.count])
//            if messages.count >= 1 {
//              messagesCollectionView.reloadSections([messages.count - 1])
//            }
            messages.append(message)
            messagesCollectionView.insertSections([messages.count - 1])
//            if messages.count >= 2 {
//              messagesCollectionView.reloadSections([messages.count - 2])
//            }
        })
//        messagesCollectionView.performBatchUpdates({
//            // service data 삭제
//            messages.removeLast()
//            messagesCollectionView.deleteSections([messages.count - 1])
//
//            // insert first message
//            messages.append(message)
//            messagesCollectionView.insertSections([messages.count - 1])
//          if messages.count >= 2 {
//            messagesCollectionView.reloadSections([messages.count - 2])
//          }
//        }, completion: { [weak self] _ in
//          if self?.isLastSectionVisible() == true {
//            self?.messagesCollectionView.scrollToLastItem(animated: true)
//          }
//        })
    }
    
    
    func deleteMessage() {
        print("삭제전 개수", messages.count)
        messages.removeLast()
        messagesCollectionView.deleteSections([self.messages.count])
        
//        if messages.count >= 1 {
//            messagesCollectionView.reloadSections([messages.count - 1])
//        }
        print("삭제후 개수", messages.count)
//        if messages.count >= 1 {
//          messagesCollectionView.reloadSections([messages.count - 1])
//        }
//        if isLastSectionVisible() == true {
//          messagesCollectionView.scrollToLastItem(animated: true)
//        }
//        print("삭제후 개수", messages.count)
        
        
//        print("삭제후 개수", messages.count)
//        if messages.count >= 1 {
//          messagesCollectionView.reloadSections([messages.count - 1])
//        }
//        if isLastSectionVisible() == true {
//          messagesCollectionView.scrollToLastItem(animated: true)
//        }
//         Reload last section to update header/footer labels and insert a new one
//        messagesCollectionView.performBatchUpdates({
//        messagesCollectionView.deleteSections([messages.count])
//        print("삭제후 개수", messages.count)
//        })
      }
    

    func getAvatarFor(sender: SenderType) -> Avatar {
      let firstName = sender.displayName.components(separatedBy: " ").first
      let lastName = sender.displayName.components(separatedBy: " ").first
      let initials = "\(firstName?.first ?? "A")\(lastName?.first ?? "A")"
      return Avatar(image: avatarImages[sender.senderId], initials: initials) // sender.profileImage // #imageLiteral(resourceName: "Nathan-Tannar")
//      switch sender.senderId {
//      case "self":
//          return Avatar(image: sender.profileImage, initials: initials) // #imageLiteral(resourceName: "Nathan-Tannar")
//      case "other":
//        return Avatar(image: nil, initials: initials)
//      default:
//        return Avatar(image: nil, initials: initials)
//      }
    }
    
    func messageTopLabelAttributedText(for message: MessageType, at _: IndexPath) -> NSAttributedString? {
      let name = message.sender.displayName
      return NSAttributedString(
        string: name,
        attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .caption1)])
    }
    
    // message date 중에 요일 날짜가 바뀌면 표시
    func cellTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
      let newMessageDate = messageDateCenterFormatter(date: message.sentDate)
      if indexPath.section % 3 == 0 || oldMessageDate != newMessageDate {
          oldMessageDate = newMessageDate
        return NSAttributedString(
          string: newMessageDate,
          attributes: [
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 10),
            NSAttributedString.Key.foregroundColor: UIColor.darkGray,
          ])
      }
      return nil
    }
    
    func messageBottomLabelAttributedText(for message: MessageType, at _: IndexPath) -> NSAttributedString? {
      return NSAttributedString(
        string: messageFormatter.string(from: message.sentDate),
        attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .caption2)])
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}

extension ChatViewController: InputBarAccessoryViewDelegate {
    @objc
    func inputBar(_: InputBarAccessoryView, didPressSendButtonWith _: String) {
        print("버튼 누름")
      processInputBar(messageInputBar)
    }
    
//    func processInputBar(_ inputBar: InputBarAccessoryView) {
//
//        // Here we can parse for which substrings were autocompleted
//        let attributedText = inputBar.inputTextView.attributedText!
//        let range = NSRange(location: 0, length: attributedText.length)
//        attributedText.enumerateAttribute(.autocompleted, in: range, options: []) { _, range, _ in
//
//            let substring = attributedText.attributedSubstring(from: range)
//            let context = substring.attribute(.autocompletedContext, at: 0, effectiveRange: nil)
//            print("Autocompleted: `", substring, "` with context: ", context ?? [])
//        }
//
//        let components = inputBar.inputTextView.components
//        inputBar.inputTextView.text = String()
//        inputBar.invalidatePlugins()
//        inputBar.inputTextView.placeholder = "Sending..."
//        inputBar.sendButton.startAnimating()
//        Task(priority: .high)  {
//            await MainActor.run {
//                inputBar.inputTextView.placeholder = "Sending..."
//                inputBar.sendButton.startAnimating()
//            }
//            await insertMessages(components)
//            await MainActor.run {
//                inputBar.sendButton.stopAnimating()
//                inputBar.inputTextView.placeholder = ""
//            }
//        }
//    }
        
    func processInputBar(_ inputBar: InputBarAccessoryView) {
        print("버튼 누름")
        if !isPaging {
            isPaging = true
            // Here we can parse for which substrings were autocompleted
            let attributedText = inputBar.inputTextView.attributedText!
            let range = NSRange(location: 0, length: attributedText.length)
            attributedText.enumerateAttribute(.autocompleted, in: range, options: []) { _, range, _ in
                
                let substring = attributedText.attributedSubstring(from: range)
                let context = substring.attribute(.autocompletedContext, at: 0, effectiveRange: nil)
                print("Autocompleted: `", substring, "` with context: ", context ?? [])
            }
            
            let components = inputBar.inputTextView.components
            inputBar.inputTextView.text = String()
            inputBar.invalidatePlugins()
            inputBar.inputTextView.placeholder = "Sending..."
            inputBar.sendButton.startAnimating()
            insertMessages(components)
        }
    }
    
    // 유저 로그인 정보에
    // 유저 닉네임도 저장 필요
    
    // 해당 section 존재 없음
//    private func insertMessages(_ data: [Any]) async {
//        //        messages.removeLast()
//        //        messagesCollectionView.deleteSections([messages.count])
//        if isPaging {
//            print("페이징 중입니다.")
//            return
//        }
//        else { isPaging = true }
//        for component in data {
//            //        let user = SampleData.shared.currentSender
//
//            guard let boardId = self.boardId else { return }
//            guard let userItem = try? KeychainManager.getUserItem() else { return }
//            //          let user = Sender(senderId: "\(userItem.userId)", displayName: "Jun") // 첫번째로 보내면 이름값이 없다 따라서 닉네임 키체인에 저장 필요
//            if let str = component as? String {
//                let createClipBoardReq = CreateClipBoardReq(boardID: boardId, content: str, refreshToken: userItem.refresh_token, title: "", userID: userItem.userId)
//                let createClipBoardRes = await createClipBoardData(boardData: createClipBoardReq) // 등록
//                var totalPage = 0
//                repeat {
//                    let getData = await fetchClipBoardData(page: upPageCusor)
//                    if (getData?.totalPage) != nil {
//                        totalPage = getData!.totalPage
//                    }
//                    print("삽입 하지 않은 upPageCursor, totalPage", upPageCusor, totalPage)
//                    if upPageCusor < totalPage { // 현재페이지 토탈페이지-1 이고 개수 10보다 작으면 막아야함
//                        print("삽입 할 upPageCursor, totalPage", upPageCusor, totalPage)
//                        guard let clipBoardList = getData?.getClipBoardResList else { return }
//                        var clipBoardListCount = clipBoardList.count
//                        for i in upPageListCount..<clipBoardListCount { // 9  10
//                            print("upPageListCount, clipBoardListCount", self.upPageListCount, clipBoardListCount)
//                            let sender = Sender(senderId: "\(clipBoardList[i].userID)", displayName:  clipBoardList[i].userName)
//                            if avatarImages[sender.senderId] == nil {
////                                let profileImage = await clipBoardList[i].profileImgURL.urlToImage()
////                                self.avatarImages[sender.senderId] = profileImage
//                                let profileImage = clipBoardList[i].profileImgURL.loadImageAsync()
//                                self.avatarImages[sender.senderId] = profileImage
////                                clipBoardList[i].profileImgURL.loadImage { (image) in
////                                    guard let image = image else {
////                                        print("Error loading image")
////                                        return
////                                    }
////                                    self.avatarImages[sender.senderId] = image
////                                }
//                            }
////                            if userItem.userId == clipBoardList[i].userID {
////                                currentUser.senderId = "\(clipBoardList[i].userID)"
////                                currentUser.displayName = clipBoardList[i].userName
////                            }
//                            guard let sendDate = clipBoardList[i].createdAt.stringToDate() else { return }
//                            let message = Message(sender: sender, messageId: "\(clipBoardList[i].clipBoardID)", sentDate: sendDate, kind: .text(clipBoardList[i].content))
//                            await MainActor.run {
//                                if i == upPageListCount {
//                                    insertFirst(message)
//                                } else {
//                                    insertMessage(message)
//                                }
//                            }
//                            // 보낸 메시지와 동일하면
//                            if createClipBoardRes?.clipBoardID == clipBoardList[i].clipBoardID {
//                                print("clipBoardListCount, i", clipBoardListCount, i) // 10 9
//                                clipBoardListCount = i + 1
//                                break
//                            }
//                        }
//                        upPageListCount = clipBoardListCount%10 // 0
//                        if upPageListCount == 0 {
//                            upPageCusor += 1
//                        }
//                    }
//                } while upPageCusor < totalPage && upPageListCount == 0
//                let serviceMessage = Message(sender: service, messageId: "\(upPageCusor*10+upPageListCount)", sentDate: Date(), kind: .text("📢 This is not realtime chatting\n      Please need scroll"))
//                await MainActor.run {
//                    insertMessage(serviceMessage)
//                    messagesCollectionView.scrollToLastItem()
//                }
//                isPaging = false
//                print("페이징 끝")
//            } else if let img = component as? UIImage {
//                //            let message = Message(sender: user, messageId: "1", sentDate: Date(), kind: .photo(img as! MediaItem))
//                //          insertMessage(message)
//            }
//        }
//    }
    
    func fetchClipBoardData2(getAllClipBoardsReq: GetAllClipBoardsReq) async throws -> ClipBoardResInfo {
//        guard let userItem = try? KeychainManager.getUserItem() else { throw FetchError.notFoundKeyChain }
//        guard let boardId = self.boardId else { throw FetchError.notFoundBoardId }
//        let getAllClipBoardsReq = GetAllClipBoardsReq(boardId: boardId, cursor: page, refreshToken: userItem.refresh_token, userId: userItem.userId)
        let dataTask = AlamofireManager.shared.session.request(ClipBoardRouter.readBoard(parameters: getAllClipBoardsReq)).validate(statusCode: 200..<501).serializingDecodable(APIResponse<ClipBoardResInfo>.self)
        let response = await dataTask.response
        switch response.result {
        case .success:
            print("fetchClipBoardData2 success")
        if let value = response.value, value.httpCode == 200, let data = value.data {
            return data
        } else {
            throw FetchError.badResponse
        }
        case let .failure(error):
            print("fetchClipBoardData2 error", error)
            throw FetchError.failureResponse
        }
//        let value = response.value
//        guard let data = value?.data else { throw FetchError.notFoundBoardId }
//        return value?.data
    }

    private func insertMessages(_ data: [Any]) {
        for component in data {
            guard let boardId = self.boardId else { return }
            guard let identifier = UserDefaults.standard.object(forKey: SessionManager.currentServiceTypeIdentifier) as? String, let userItem = try? KeychainManager.getUserItem(serviceType: identifier) else { return }
            Task(priority: .high) {
                if let str = component as? String {
                    do {
                        let createClipBoardReq = CreateClipBoardReq(boardID: boardId, content: str, refreshToken: userItem.refresh_token, title: "", userID: userItem.userId)
                        let createClipBoardRes = try await createClipBoardData2(boardData: createClipBoardReq) // 등록
                        var totalPage = 0
                        repeat {
                            let getAllClipBoardsReq = GetAllClipBoardsReq(boardId: boardId, cursor: upPageCusor, refreshToken: userItem.refresh_token, userId: userItem.userId)
                            do {
                                let getData = try await fetchClipBoardData2(getAllClipBoardsReq: getAllClipBoardsReq)
                                totalPage = getData.totalPage
                                if upPageCusor < totalPage { // 현재페이지 토탈페이지-1 이고 개수 10보다 작으면 막아야함
                                    let clipBoardList = getData.getClipBoardResList
                                    var clipBoardListCount = clipBoardList.count
                                    for i in upPageListCount..<clipBoardListCount { // 9  10
                                        let sender = Sender(senderId: "\(clipBoardList[i].userID)", displayName: clipBoardList[i].userName ?? "")
                                        if avatarImages[sender.senderId] == nil {
                                            if clipBoardList[i].profileImgURL.contains("null") {
                                                self.avatarImages[sender.senderId] = UIImage(named: "PROFILE_IMAGE_NULL")
                                            } else {
                                                let profileImage = clipBoardList[i].profileImgURL.loadImageAsync()
                                                self.avatarImages[sender.senderId] = profileImage
                                            }
                                        }
                                        guard let sendDate = clipBoardList[i].createdAt.stringToDate() else { return }
                                        let message = Message(sender: sender, messageId: "\(clipBoardList[i].clipBoardID)", sentDate: sendDate, kind: .text(clipBoardList[i].content))
                                        await MainActor.run {
                                            if i == upPageListCount {
                                                insertFirst(message)
                                            } else {
                                                insertMessage(message)
                                            }
                                        }
                                        if createClipBoardRes.clipBoardID == clipBoardList[i].clipBoardID { // 보낸 메시지와 동일하면
                                            print("clipBoardListCount, i", clipBoardListCount, i) // 10 9
                                            clipBoardListCount = i + 1
                                            break
                                        }
                                    }
                                    upPageListCount = clipBoardListCount%modular // 0
                                    if upPageListCount == 0 {
                                        upPageCusor += 1
                                    }
                                    let serviceMessage = Message(sender: service, messageId: "\(serviceMessageId)", sentDate: Date(), kind: .text(serviceNotice))
                                    await MainActor.run {
                                        insertMessage(serviceMessage)
                                    }
                                }
                            } catch {
                                print("fetchClipBoardData2 error \(error.localizedDescription)")
                                break
                            }
                        } while upPageCusor < totalPage && upPageListCount == 0
                    } catch {
                        print("createClipBoardData error \(error.localizedDescription)")
                    }
                } else if let img = component as? UIImage {
  
                }
                await MainActor.run {
                    messageInputBar.sendButton.stopAnimating()
                    messagesCollectionView.scrollToLastItem()
                }
                isPaging = false
            }
        }
    }
}

extension ChatViewController: MessageCellDelegate {
    
    func didTapAvatar(in _: MessageCollectionViewCell) {
        print("Avatar tapped")
    }

    func didTapMessage(in cell: MessageCollectionViewCell) {
        print("Message tapped")
//        guard
//          let indexPath = messagesCollectionView.indexPath(for: cell),
//          let message = messagesCollectionView.messagesDataSource?.messageForItem(at: indexPath, in: messagesCollectionView)
//        else {
//          print("Failed to identify message when audio cell receive tap gesture")
//          return
//        }
        // message.sender.senderId
    }

    func didTapImage(in _: MessageCollectionViewCell) {
        print("Image tapped")
    }

    func didTapCellTopLabel(in _: MessageCollectionViewCell) {
        print("Top cell label tapped")
    }

    func didTapCellBottomLabel(in _: MessageCollectionViewCell) {
        print("Bottom cell label tapped")
    }

    func didTapMessageTopLabel(in _: MessageCollectionViewCell) {
        print("Top message label tapped")
    }

    func didTapMessageBottomLabel(in _: MessageCollectionViewCell) {
        print("Bottom label tapped")
    }

    func didTapPlayButton(in cell: AudioMessageCell) {
        guard
          let indexPath = messagesCollectionView.indexPath(for: cell),
          let message = messagesCollectionView.messagesDataSource?.messageForItem(at: indexPath, in: messagesCollectionView)
        else {
          print("Failed to identify message when audio cell receive tap gesture")
          return
        }
        guard audioController.state != .stopped else {
          // There is no audio sound playing - prepare to start playing for given audio message
          audioController.playSound(for: message, in: cell)
          return
        }
        if audioController.playingMessage?.messageId == message.messageId {
          // tap occur in the current cell that is playing audio sound
          if audioController.state == .playing {
            audioController.pauseSound(for: message, in: cell)
          } else {
            audioController.resumeSound()
          }
        } else {
          // tap occur in a difference cell that the one is currently playing sound. First stop currently playing and start the sound for given message
          audioController.stopAnyOngoingPlaying()
          audioController.playSound(for: message, in: cell)
        }
  }

    func didStartAudio(in _: AudioMessageCell) {
        print("Did start playing audio sound")
    }

    func didPauseAudio(in _: AudioMessageCell) {
        print("Did pause audio sound")
    }

    func didStopAudio(in _: AudioMessageCell) {
        print("Did stop audio sound")
    }

    func didTapAccessoryView(in _: MessageCollectionViewCell) {
        print("Accessory view tapped")
    }
}

