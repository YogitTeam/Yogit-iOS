//
//  ChatViewController.swift
//  Yogit
//
//  Created by Junseo Park on 2022/12/28.
//

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
    let keyboardManager = KeyboardManager()
//    let keyboardNotification = KeyboardNotification(from: <#NSNotification#>)
    var keyboardHieght = 0
    var currentUser = Sender(senderId: "me", displayName: "MyName")
//    var otherUser = Sender(senderId: "other", displayName: "OtherUserName")
    let service = Sender(senderId: "SERVICE", displayName: "Yogit")
//    let currentUser: Sender
    var boardId: Int64?
    var downPageCursor = -1
    var upPageCusor = 0
    var upPageListCount = 0
    var isPaging: Bool = false
    var isLoading: Bool = false
    var currentSender: SenderType {
        currentUser
    }
    
    lazy var audioController = BasicAudioController(messageCollectionView: messagesCollectionView)

    var messages = [MessageType]()
    var avatarImages: [String:UIImage] = ["SERVICE":UIImage(named: "ServiceIcon")!]
    
    private let formatter: DateFormatter = {
      let formatter = DateFormatter()
      formatter.dateStyle = .medium
      return formatter
    }()
    
//    private(set) lazy var refreshControl: UIRefreshControl = {
//      let control = UIRefreshControl()
//        control.addTarget(self, action: #selector(loadClipBoardDown), for: .valueChanged)
//       control.transform = CGAffineTransformMakeScale(0.5, 0.5)
//      return control
//    }()
//
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewComponent()
        configureMessageCollectionView()
        configureMessageInputBar()
        configureCurrentUser()
//        Task(priority: .high) {
//            await loadFirstMessages()
//        }
        // Do any additional setup after loading the view.
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
    
    func configureViewComponent() {
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.title = "Chat"
    }
    
    func configureCurrentUser() {
        guard let userItem = try? KeychainManager.getUserItem() else { return }
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
//        messageInputBar.inputTextView.tintColor = UIColor(rgb: 0x3232FF, alpha: 1.0)
//        messageInputBar.sendButton.setTitleColor(UIColor(rgb: 0x3232FF, alpha: 1.0), for: .normal)
//        messageInputBar.sendButton.setTitleColor(
//            UIColor(rgb: 0x3232FF, alpha: 1.0).withAlphaComponent(0.3),
//          for: .highlighted)
        
        messageInputBar.inputTextView.tintColor = .label
        messageInputBar.inputTextView.textContainerInset = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 36)
        messageInputBar.inputTextView.placeholderLabelInsets = UIEdgeInsets(top: 8, left: 20, bottom: 8, right: 36)
//        if #available(iOS 13, *) {
//            messageInputBar.inputTextView.layer.borderColor = UIColor.systemGray2.cgColor
//        } else {
//            messageInputBar.inputTextView.layer.borderColor = UIColor.lightGray.cgColor
//        }
        messageInputBar.inputTextView.backgroundColor = .systemGray6
//        UIColor(rgb: 0xF5F5F5, alpha: 1.0)
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
        guard let userItem = try? KeychainManager.getUserItem() else { return nil }
        guard let boardId = self.boardId else { return nil }
        let getAllClipBoardsReq = GetAllClipBoardsReq(boardId: boardId, cursor: page, refreshToken: userItem.refresh_token, userId: userItem.userId)
        let dataTask = AlamofireManager.shared.session.request(ClipBoardRouter.readBoard(parameters: getAllClipBoardsReq)).validate(statusCode: 200..<501).serializingDecodable(APIResponse<ClipBoardResInfo>.self)
        let response = await dataTask.response
//        let result = await dataTask.result
        let value = response.value
        return value?.data
    }
    
    func createClipBoardData(boardData: CreateClipBoardReq) async -> GetAllClipBoardsRes? {
        let dataTask = AlamofireManager.shared.session.request(ClipBoardRouter.createBoard(parameters: boardData)).validate(statusCode: 200..<501).serializingDecodable(APIResponse<GetAllClipBoardsRes>.self)
        let response = await dataTask.response
//        let result = await dataTask.result
        let value = response.value
        return value?.data
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
//        if messages.count >= 2 {
//          messagesCollectionView.reloadSections([messages.count - 2])
//        }
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
            if messages.count >= 1 {
              messagesCollectionView.reloadSections([messages.count - 1])
            }
            messages.append(message)
            messagesCollectionView.insertSections([messages.count - 1])
            if messages.count >= 2 {
              messagesCollectionView.reloadSections([messages.count - 2])
            }
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
    
    func cellTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
      if indexPath.section % 3 == 0 {
        return NSAttributedString(
          string: MessageKitDateFormatter.shared.string(from: message.sentDate),
          attributes: [
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 10),
            NSAttributedString.Key.foregroundColor: UIColor.darkGray,
          ])
      }
      return nil
    }
    
    func messageBottomLabelAttributedText(for message: MessageType, at _: IndexPath) -> NSAttributedString? {
      let dateString = formatter.string(from: message.sentDate)
      return NSAttributedString(
        string: dateString,
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
        Task(priority: .high)  {
            await MainActor.run {
                inputBar.inputTextView.placeholder = "Sending..."
                inputBar.sendButton.startAnimating()
            }
//            inputBar.inputTextView.isEditable = false
            await insertMessages(components)
            await MainActor.run {
                inputBar.sendButton.stopAnimating()
                inputBar.inputTextView.placeholder = ""
            }
//            inputBar.inputTextView.isEditable = true
        }
//        task.cancel()
    }
    
    // 유저 로그인 정보에
    // 유저 닉네임도 저장 필요
    
    // 해당 section 존재 없음
    private func insertMessages(_ data: [Any]) async {
        //        messages.removeLast()
        //        messagesCollectionView.deleteSections([messages.count])
        if isPaging {
            print("페이징 중입니다.")
            return
        }
        else { isPaging = true }
        for component in data {
            //        let user = SampleData.shared.currentSender

            guard let boardId = self.boardId else { return }
            guard let userItem = try? KeychainManager.getUserItem() else { return }
            //          let user = Sender(senderId: "\(userItem.userId)", displayName: "Jun") // 첫번째로 보내면 이름값이 없다 따라서 닉네임 키체인에 저장 필요
            if let str = component as? String {
                let createClipBoardReq = CreateClipBoardReq(boardID: boardId, content: str, refreshToken: userItem.refresh_token, title: "", userID: userItem.userId)
                let createClipBoardRes = await createClipBoardData(boardData: createClipBoardReq) // 등록
                var totalPage = 0
                repeat {
                    let getData = await fetchClipBoardData(page: upPageCusor)
                    if (getData?.totalPage) != nil {
                        totalPage = getData!.totalPage
                    }
                    print("삽입 하지 않은 upPageCursor, totalPage", upPageCusor, totalPage)
                    if upPageCusor < totalPage { // 현재페이지 토탈페이지-1 이고 개수 10보다 작으면 막아야함
                        print("삽입 할 upPageCursor, totalPage", upPageCusor, totalPage)
                        guard let clipBoardList = getData?.getClipBoardResList else { return }
                        var clipBoardListCount = clipBoardList.count
                        for i in upPageListCount..<clipBoardListCount { // 9  10
                            print("upPageListCount, clipBoardListCount", self.upPageListCount, clipBoardListCount)
                            let sender = Sender(senderId: "\(clipBoardList[i].userID)", displayName:  clipBoardList[i].userName)
                            if avatarImages[sender.senderId] == nil {
//                                let profileImage = await clipBoardList[i].profileImgURL.urlToImage()
//                                self.avatarImages[sender.senderId] = profileImage
                                let profileImage = clipBoardList[i].profileImgURL.loadImageAsync()
                                self.avatarImages[sender.senderId] = profileImage
//                                clipBoardList[i].profileImgURL.loadImage { (image) in
//                                    guard let image = image else {
//                                        print("Error loading image")
//                                        return
//                                    }
//                                    self.avatarImages[sender.senderId] = image
//                                }
                            }
//                            if userItem.userId == clipBoardList[i].userID {
//                                currentUser.senderId = "\(clipBoardList[i].userID)"
//                                currentUser.displayName = clipBoardList[i].userName
//                            }
                            guard let sendDate = clipBoardList[i].createdAt.stringToDate() else { return }
                            let message = Message(sender: sender, messageId: "\(clipBoardList[i].clipBoardID)", sentDate: sendDate, kind: .text(clipBoardList[i].content))
                            await MainActor.run {
                                if i == upPageListCount {
                                    insertFirst(message)
                                } else {
                                    insertMessage(message)
                                }
                            }
                            // 보낸 메시지와 동일하면
                            if createClipBoardRes?.clipBoardID == clipBoardList[i].clipBoardID {
                                print("clipBoardListCount, i", clipBoardListCount, i) // 10 9
                                clipBoardListCount = i + 1
                                break
                            }
                        }
                        upPageListCount = clipBoardListCount%10 // 0
                        if upPageListCount == 0 {
                            upPageCusor += 1
                        }
                    }
                } while upPageCusor < totalPage && upPageListCount == 0
                let serviceMessage = Message(sender: service, messageId: "\(upPageCusor*10+upPageListCount)", sentDate: Date(), kind: .text("📢 This is not realtime chatting\n      Please need scroll"))
                await MainActor.run {
                    insertMessage(serviceMessage)
                    messagesCollectionView.scrollToLastItem()
                }
                isPaging = false
                print("페이징 끝")
            } else if let img = component as? UIImage {
                //            let message = Message(sender: user, messageId: "1", sentDate: Date(), kind: .photo(img as! MediaItem))
                //          insertMessage(message)
            }
        }
    }

}

extension ChatViewController: MessageCellDelegate {
    func didTapAvatar(in _: MessageCollectionViewCell) {
        print("Avatar tapped")
    }

    func didTapMessage(in _: MessageCollectionViewCell) {
        print("Message tapped")
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

