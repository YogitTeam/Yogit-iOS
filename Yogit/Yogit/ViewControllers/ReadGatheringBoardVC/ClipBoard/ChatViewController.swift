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
    let serviceNotice = "📢 " + "CLIPBOARD_SERVICE_NOTICE".localized()
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
        IQKeyboardManager.shared.enable = false
    }
   
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        IQKeyboardManager.shared.enable = true
    }
    
    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }
    
    override func collectionView(_: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        print("shouldShowMenuForItemAt", indexPath.section)
        let message = getTheMessageText(messageKind: messages[indexPath.section].kind)
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cancel = UIAlertAction(title: "CANCEL".localized(), style: .cancel, handler: nil)
        let copy = UIAlertAction(title: "COPY".localized(), style: .default) { (action) in
            UIPasteboard.general.string = message
        }
        let report = UIAlertAction(title: "REPORT".localized(), style: .destructive) { (action) in
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
        navigationItem.title = "CLIPBOARD".localized()
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
        messageInputBar.sendButton.imageView?.backgroundColor = ServiceColor.primaryColor
        messageInputBar.sendButton.configuration?.contentInsets =  NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
        messageInputBar.sendButton.setSize(CGSize(width: 36, height: 36), animated: false)
        messageInputBar.sendButton.image = UIImage(named: "chat_up")!
        messageInputBar.sendButton.title = nil
        messageInputBar.sendButton.imageView?.layer.cornerRadius = 16

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
    
    func createClipBoardData(boardData: CreateClipBoardReq) async throws -> GetAllClipBoardsRes {
        let dataTask = AlamofireManager.shared.session.request(ClipBoardRouter.createBoard(parameters: boardData)).validate(statusCode: 200..<501).serializingDecodable(APIResponse<GetAllClipBoardsRes>.self)
        let response = await dataTask.response
        switch response.result {
        case .success:
            if let value = response.value, (value.httpCode == 200 || value.httpCode == 201), let data = value.data {
                return data
            } else {
                throw CreateError.badResponse
            }
        case let .failure(error):
            print("createClipBoardData error", error)
            throw CreateError.failureResponse
        }
    }
    
    func textCell(for _: MessageType, at _: IndexPath, in _: MessagesCollectionView) -> UICollectionViewCell? {
      nil
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
   
    func isLastSectionVisible() -> Bool {
      guard !messages.isEmpty else { return false }

      let lastIndexPath = IndexPath(item: 0, section: messages.count - 1)
    
      return messagesCollectionView.indexPathsForVisibleItems.contains(lastIndexPath)
    }
    
    
    func insertMessage(_ message: Message) {

        messages.append(message)
        messagesCollectionView.insertSections([messages.count - 1])
//        if messages.count >= 2 {
//          messagesCollectionView.reloadSections([messages.count - 2])
//        }
//        if isLastSectionVisible() == true {
//          messagesCollectionView.scrollToLastItem(animated: true)
//        }
//        print("삽입후 개수", messages.count)
    }
    
    func insertFirst(_ message: Message) {
        messagesCollectionView.performBatchUpdates({
            messages.removeLast()
            messagesCollectionView.deleteSections([messages.count])
            messages.append(message)
            messagesCollectionView.insertSections([messages.count - 1])
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
        messages.removeLast()
        messagesCollectionView.deleteSections([self.messages.count])
    }
    

    func getAvatarFor(sender: SenderType) -> Avatar {
      let firstName = sender.displayName.components(separatedBy: " ").first
      let lastName = sender.displayName.components(separatedBy: " ").first
      let initials = "\(firstName?.first ?? "A")\(lastName?.first ?? "A")"
      return Avatar(image: avatarImages[sender.senderId], initials: initials)
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
      processInputBar(messageInputBar)
    }
        
    func processInputBar(_ inputBar: InputBarAccessoryView) {
        if !isPaging {
            if inputBar.inputTextView.text.count > 500 {
                let alert = UIAlertController(title: "CLIPBOARD_TEXT_OVER_ALERT_TITLE".localized(), message: "CLIPBOARD_TEXT_OVER_ALERT_MESSAGE".localized(), preferredStyle: UIAlertController.Style.alert)
                let okAction = UIAlertAction(title: "OK".localized(), style: .default)
                alert.addAction(okAction)
                DispatchQueue.main.async(qos: .userInteractive) {
                    self.present(alert, animated: false, completion: nil)
                }
            } else {
                isPaging = true
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
                inputBar.inputTextView.placeholder = ""
                inputBar.sendButton.startAnimating()
                insertMessages(components)
            }
        }
    }
    
    func fetchClipBoardData(getAllClipBoardsReq: GetAllClipBoardsReq) async throws -> ClipBoardResInfo {
        let dataTask = AlamofireManager.shared.session.request(ClipBoardRouter.readBoard(parameters: getAllClipBoardsReq)).validate(statusCode: 200..<501).serializingDecodable(APIResponse<ClipBoardResInfo>.self)
        let response = await dataTask.response
        switch response.result {
        case .success:
            if let value = response.value, value.httpCode == 200, let data = value.data {
                return data
            } else {
                throw FetchError.badResponse
            }
        case let .failure(error):
            print("fetchClipBoardData error", error)
            throw FetchError.failureResponse
        }
    }

    private func insertMessages(_ data: [Any]) {
        for component in data {
            guard let boardId = self.boardId else { return }
            guard let identifier = UserDefaults.standard.object(forKey: SessionManager.currentServiceTypeIdentifier) as? String, let userItem = try? KeychainManager.getUserItem(serviceType: identifier) else { return }
            Task(priority: .high) {
                if let str = component as? String {
                    do {
                        let createClipBoardReq = CreateClipBoardReq(boardID: boardId, content: str, refreshToken: userItem.refresh_token, title: "", userID: userItem.userId)
                        let createClipBoardRes = try await createClipBoardData(boardData: createClipBoardReq) // 등록
                        var totalPage = 0
                        repeat {
                            let getAllClipBoardsReq = GetAllClipBoardsReq(boardId: boardId, cursor: upPageCusor, refreshToken: userItem.refresh_token, userId: userItem.userId)
                            do {
                                let getData = try await fetchClipBoardData(getAllClipBoardsReq: getAllClipBoardsReq)
                                totalPage = getData.totalPage
                                if upPageCusor < totalPage { // 현재페이지 토탈페이지-1 이고 개수 10보다 작으면 막아야함
                                    let clipBoardList = getData.getClipBoardResList
                                    var clipBoardListCount = clipBoardList.count
                                    for i in upPageListCount..<clipBoardListCount { // 9  10
                                        let sender = Sender(senderId: "\(clipBoardList[i].userID)", displayName: clipBoardList[i].userName ?? "UNKNOWN".localized())
                                        if avatarImages[sender.senderId] == nil {
                                            if !clipBoardList[i].profileImgURL.contains("null") {
                                                let profileImage = clipBoardList[i].profileImgURL.loadImageAsync()
                                                self.avatarImages[sender.senderId] = profileImage
                                            } else {
                                                self.avatarImages[sender.senderId] = UIImage(named: "PROFILE_IMAGE_NULL")
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
                                            clipBoardListCount = i + 1 // i로 모듈러 맞춰줌
                                            break
                                        }
                                    }
                                    upPageListCount = clipBoardListCount%modular // 0 1 2
                                    if upPageListCount == 0 {
                                        upPageCusor += 1
                                    }
                                    let serviceMessage = Message(sender: service, messageId: "\(serviceMessageId)", sentDate: Date(), kind: .text(serviceNotice))
                                    await MainActor.run {
                                        insertMessage(serviceMessage)
                                    }
                                }
                            } catch {
                                print("fetchClipBoardData error \(error.localizedDescription)")
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

