//
//  ClipBoardViewController2.swift
//  Yogit
//
//  Created by Junseo Park on 2023/01/01.
//

import MapKit
import MessageKit
import InputBarAccessoryView
import UIKit

class ClipBoardViewController2: ChatViewController {
    
//    var boardId: Int64?
//    var hostId: Int64?
//    var totalPage = 0
////    var lastPageDataCount = 0
//    var pageCursor = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messagesCollectionView.tag = 1
        Task(priority: .high) {
            await loadFirstMessages()
        }
    }

    override func configureMessageCollectionView() {
        super.configureMessageCollectionView()
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        
        let layout = messagesCollectionView.collectionViewLayout as? MessagesCollectionViewFlowLayout
        layout?.sectionInset = UIEdgeInsets(top: 1, left: 8, bottom: 1, right: 8)

        // Hide the outgoing avatar and adjust the label alignment to line up with the messages
        layout?.setMessageOutgoingAvatarSize(.zero)
        layout?
          .setMessageOutgoingMessageTopLabelAlignment(LabelAlignment(
            textAlignment: .right,
            textInsets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 8)))
        layout?
          .setMessageOutgoingMessageBottomLabelAlignment(LabelAlignment(
            textAlignment: .right,
            textInsets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 8)))
    }
    
    func textCellSizeCalculator(for _: MessageType, at _: IndexPath, in _: MessagesCollectionView) -> CellSizeCalculator? {
      nil
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

extension ClipBoardViewController2: MessagesDisplayDelegate {
    

    private func createLoadingView(footerView: MessageReusableView, isPaging: Bool, isLoading: Bool, section: Int) -> MessageReusableView {
        
        // 로딩중이면, footerview 생성후 애니메이션실행
        // 로딩중이 아니면, break
        print("createLoadingView section", section)
        switch section {
        case messages.count-1:
            let spiner = UIActivityIndicatorView()
            spiner.center = footerView.center
            footerView.addSubview(spiner)
            spiner.frame = footerView.bounds
            if isLoading { spiner.startAnimating() }
            else { spiner.stopAnimating() }
        default: break
        }
        return footerView
    }
    
    // footerview 사이즈 미리 업데이트 후 footerview add
    func messageFooterView(for indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageReusableView {
//        print("Make footer")
        let footerView = messagesCollectionView.dequeueReusableFooterView(MessageReusableView.self, for: indexPath)
        footerView.subviews.forEach { $0.removeFromSuperview() }
//        print("Make footView item and section", indexPath.item, indexPath.section)
        return createLoadingView(footerView: footerView, isPaging: isPaging, isLoading: isLoading, section: indexPath.section)
    }
    
    func textColor(for message: MessageType, at _: IndexPath, in _: MessagesCollectionView) -> UIColor {
        if message.sender.senderId == "SERVICE" { return .white }
        else { return .label }
  //    isFromCurrentSender(message: message) ? .white : .label
    }

    func detectorAttributes(for detector: DetectorType, and _: MessageType, at _: IndexPath) -> [NSAttributedString.Key: Any] {
      switch detector {
      case .hashtag, .mention: return [.foregroundColor: UIColor.blue]
      default: return MessageLabel.defaultAttributes
      }
    }

    func enabledDetectors(for _: MessageType, at _: IndexPath, in _: MessagesCollectionView) -> [DetectorType] {
      [.url, .address, .phoneNumber, .date, .transitInformation, .mention, .hashtag]
    }

    // MARK: - All Messages

    func backgroundColor(for message: MessageType, at _: IndexPath, in _: MessagesCollectionView) -> UIColor {
        if message.sender.senderId == "SERVICE" { return UIColor(rgb: 0x3232FF, alpha: 1.0) }
        else { return isFromCurrentSender(message: message) ? UIColor(rgb: 0x7979FF, alpha: 1.0) : .systemGray4 }
  //      isFromCurrentSender(message: message) ? UIColor(rgb: 0x3232FF, alpha: 1.0) : .systemGray4 //UIColor(red: 230 / 255, green: 230 / 255, blue: 230 / 255, alpha: 1)
    }
      
    

    func messageStyle(for message: MessageType, at _: IndexPath, in _: MessagesCollectionView) -> MessageStyle {
      let tail: MessageStyle.TailCorner = isFromCurrentSender(message: message) ? .bottomRight : .bottomLeft
      return .bubbleTail(tail, .curved)
    }

      
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at _: IndexPath, in _: MessagesCollectionView) {
        let avatar = getAvatarFor(sender: message.sender)
        avatarView.set(avatar: avatar)
    }
      
      
      func configureAccessoryView(_ accessoryView: UIView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
          accessoryView
      }

  //  func configureMediaMessageImageView(
  //    _ imageView: UIImageView,
  //    for message: MessageType,
  //    at _: IndexPath,
  //    in _: MessagesCollectionView)
  //  {
  //    if case MessageKind.photo(let media) = message.kind, let imageURL = media.url {
  //      imageView.kf.setImage(with: imageURL)
  //    } else {
  //      imageView.kf.cancelDownloadTask()
  //    }
  //  }

    // MARK: - Location Messages

    func annotationViewForLocation(message _: MessageType, at _: IndexPath, in _: MessagesCollectionView) -> MKAnnotationView? {
      let annotationView = MKAnnotationView(annotation: nil, reuseIdentifier: nil)
      let pinImage = #imageLiteral(resourceName: "ic_map_marker")
      annotationView.image = pinImage
      annotationView.centerOffset = CGPoint(x: 0, y: -pinImage.size.height / 2)
      return annotationView
    }

    func animationBlockForLocation(
      message _: MessageType,
      at _: IndexPath,
      in _: MessagesCollectionView) -> ((UIImageView) -> Void)?
    {
      { view in
        view.layer.transform = CATransform3DMakeScale(2, 2, 2)
        UIView.animate(
          withDuration: 0.6,
          delay: 0,
          usingSpringWithDamping: 0.9,
          initialSpringVelocity: 0,
          options: [],
          animations: {
            view.layer.transform = CATransform3DIdentity
          },
          completion: nil)
      }
    }

  //  func snapshotOptionsForLocation(
  //    message _: MessageType,
  //    at _: IndexPath,
  //    in _: MessagesCollectionView)
  //    -> LocationMessageSnapshotOptions
  //  {
  //    LocationMessageSnapshotOptions(
  //      showsBuildings: true,
  //      showsPointsOfInterest: true,
  //      span: MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10))
  //  }

    // MARK: - Audio Messages

    func audioTintColor(for message: MessageType, at _: IndexPath, in _: MessagesCollectionView) -> UIColor {
      isFromCurrentSender(message: message) ? .white : UIColor(red: 15 / 255, green: 135 / 255, blue: 255 / 255, alpha: 1.0)
    }

    func configureAudioCell(_ cell: AudioMessageCell, message: MessageType) {
      audioController
        .configureAudioCell(
          cell,
          message: message) // this is needed especially when the cell is reconfigure while is playing sound
    }

}

extension ClipBoardViewController2: MessagesLayoutDelegate {
    // footerview 사이즈 미리 업데이트
    func footerViewSize(for section: Int, in messagesCollectionView: MessagesCollectionView) -> CGSize {
        print("FooterViewSize section", section)
        if section == messages.count - 1 && isLoading { // && loading
            return CGSize(width: messagesCollectionView.bounds.width, height: 50)
        } else {
            return CGSize.zero
        }
    }
    
    func avatarSize(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGSize? {
        if message.sender.senderId != currentUser.senderId  {
            return CGSize(width: 36, height: 36)
        } else {
            return CGSize.zero
        }
    }
    
    func cellTopLabelHeight(for _: MessageType, at _: IndexPath, in _: MessagesCollectionView) -> CGFloat {
        12
    }

    func cellBottomLabelHeight(for _: MessageType, at _: IndexPath, in _: MessagesCollectionView) -> CGFloat {
        10
    }

    func messageTopLabelHeight(for _: MessageType, at _: IndexPath, in _: MessagesCollectionView) -> CGFloat {
        20
    }

    func messageBottomLabelHeight(for _: MessageType, at _: IndexPath, in _: MessagesCollectionView) -> CGFloat {
        16
    }
}

extension ClipBoardViewController2 {
    
    // 마지막 페이지부터 로드
    // if upPageListCount == 10 { upPageCusor += 1 } 다음에 호출할때
    func loadFirstMessages() async {
        if isPaging { return }
        else { isPaging = true }
        print("loadFirstMessages")
        let checkLastData = await fetchClipBoardData(page: upPageCusor)
        guard let totalPage = checkLastData?.totalPage else { return }
        if upPageCusor < totalPage { // page 0부터 시작
            upPageCusor = totalPage-1 // 0 부터 시작
            downPageCursor = upPageCusor-1
            print("loadFirstMessages downpage cusor", downPageCursor)
            guard let userItem = try? KeychainManager.getUserItem() else { return }
//            guard let clipBoardListBeforeLast = checkLastData?.getClipBoardResList else { return }
            if downPageCursor >= 0 { // 페이지 개수 2개 이상일때
                let clipBoardDataBeforeLatest: ClipBoardResInfo?
                if upPageCusor == 1 { // 이미 그전에 응답받은 데이터 존재
                    clipBoardDataBeforeLatest = checkLastData
                } else { // 이미 그전에 응답받은 데이터 없다.
                    clipBoardDataBeforeLatest = await fetchClipBoardData(page: downPageCursor)
                }
                guard let clipBoardBeforeLatestList = clipBoardDataBeforeLatest?.getClipBoardResList else { return }
                let clipBoardListCountBeforeLast = clipBoardBeforeLatestList.count
                for i in 0..<clipBoardListCountBeforeLast { // 8
                    print("upPageListCount, clipBoardListCount", self.upPageListCount, clipBoardListCountBeforeLast)
                    let sender = Sender(senderId: "\(clipBoardBeforeLatestList[i].userID)", displayName: clipBoardBeforeLatestList[i].userName)
                    if self.avatarImages[sender.senderId] == nil {
    //                    let profileImage = await clipBoardList[i].profileImgURL.urlToImage()
    //                    self.avatarImages[sender.senderId] = profileImage
//                        clipBoardBeforeLatestList[i].profileImgURL.loadImage { (image) in
//                            guard let image = image else {
//                                print("Error loading image")
//                                return
//                            }
//                            print("아바타 이미지 로드")
//                            self.avatarImages[sender.senderId] = image
//                        }
                        let profileImage = clipBoardBeforeLatestList[i].profileImgURL.loadImageAsync()
                        self.avatarImages[sender.senderId] = profileImage
                    }
//                    if userItem.userId == clipBoardBeforeLatestList[i].userID {
//                        self.currentUser.senderId = "\(clipBoardBeforeLatestList[i].userID)"
//                        self.currentUser.displayName = clipBoardBeforeLatestList[i].userName
//                    }
                    guard let sendDate = clipBoardBeforeLatestList[i].createdAt.stringToDate() else { return }
                    let message = Message(sender: sender, messageId: "\(clipBoardBeforeLatestList[i].clipBoardID)", sentDate: sendDate, kind: .text(clipBoardBeforeLatestList[i].content))
                    messages.append(message)
                }
                downPageCursor -= 1
            }
            
            
            let loadLatest = await fetchClipBoardData(page: upPageCusor) // 0
            guard let clipBoardList = loadLatest?.getClipBoardResList else { return }
            let clipBoardListCount = clipBoardList.count
            
            for i in upPageListCount..<clipBoardListCount { // 8
                print("upPageListCount, clipBoardListCount", self.upPageListCount, clipBoardListCount)
                let sender = Sender(senderId: "\(clipBoardList[i].userID)", displayName:  clipBoardList[i].userName)
                if self.avatarImages[sender.senderId] == nil {
//                    let profileImage = await clipBoardList[i].profileImgURL.urlToImage()
//                    self.avatarImages[sender.senderId] = profileImage
//                    clipBoardList[i].profileImgURL.loadImage { (image) in
//                        guard let image = image else {
//                            print("Error loading image")
//                            return
//                        }
//                        print("아바타 이미지 로드")
//                        self.avatarImages[sender.senderId] = image
//                    }
                    let profileImage = clipBoardList[i].profileImgURL.loadImageAsync()
                    self.avatarImages[sender.senderId] = profileImage
                }
//                if userItem.userId == clipBoardList[i].userID {
//                    self.currentUser.senderId = "\(clipBoardList[i].userID)"
//                    self.currentUser.displayName = clipBoardList[i].userName
//                }
                guard let sendDate = clipBoardList[i].createdAt.stringToDate() else { return }
                let message = Message(sender: sender, messageId: "\(clipBoardList[i].clipBoardID)", sentDate: sendDate, kind: .text(clipBoardList[i].content))
                messages.append(message)
            }
            upPageListCount = clipBoardListCount%10
            if upPageListCount == 0 {
                upPageCusor += 1
            }
        }
        let serviceMessage = Message(sender: self.service, messageId: "\(self.upPageCusor*10+self.upPageListCount)", sentDate: Date(), kind: .text("📢 This is not realtime chatting\n      Please need scroll"))
        messages.append(serviceMessage)
        await MainActor.run {
            messagesCollectionView.reloadData()
            messagesCollectionView.scrollToLastItem()
        }
        isPaging = false
    }
    
    func loadClipBoardBottom() async {
        if isPaging { return }
        else { isPaging = true }
        isLoading = true
        await MainActor.run {
            messagesCollectionView.reloadSections([messages.count-1]) // 로딩뷰 실행
        }
        sleep(UInt32(0.7))
        let getData = await fetchClipBoardData(page: upPageCusor)
        guard let totalPage = getData?.totalPage else { return }
        print("삽입 전upPageCursor, totalPage", upPageCusor, totalPage)
        isLoading = false
        if upPageCusor < totalPage { // 현재페이지 토탈페이지-1 이고 개수 10보다 작으면 막아야함
            print("삽입 할 upPageCursor, totalPage", upPageCusor, totalPage)
            guard let clipBoardList = getData?.getClipBoardResList else { return }
            let clipBoardListCount = clipBoardList.count
            guard let userItem = try? KeychainManager.getUserItem() else { return }
            for i in upPageListCount..<clipBoardListCount { // 8
                print("upPageListCount, clipBoardListCount", upPageListCount, clipBoardListCount)
                let sender = Sender(senderId: "\(clipBoardList[i].userID)", displayName:  clipBoardList[i].userName)
                if avatarImages[sender.senderId] == nil {
                    let profileImage = clipBoardList[i].profileImgURL.loadImageAsync()
                    self.avatarImages[sender.senderId] = profileImage
//                    clipBoardList[i].profileImgURL.loadImage { (image) in
//                        guard let image = image else {
//                            print("Error loading image")
//                            return
//                        }
//                        self.avatarImages[sender.senderId] = image
//                    }
//                    let profileImage = await clipBoardList[i].profileImgURL.urlToImage()
//                    avatarImages[sender.senderId] = profileImage
                }
//                if userItem.userId == clipBoardList[i].userID {
//                    currentUser.senderId = "\(clipBoardList[i].userID)"
//                    currentUser.displayName = clipBoardList[i].userName
//                }
                guard let sendDate = clipBoardList[i].createdAt.stringToDate() else { return }
                let message = Message(sender: sender, messageId: "\(clipBoardList[i].clipBoardID)", sentDate: sendDate, kind: .text(clipBoardList[i].content))
                if i == upPageListCount {
                    insertFirst(message)
                } else {
                    insertMessage(message)
                }
            }
            if upPageListCount < clipBoardListCount {
                let serviceMessage = Message(sender: service, messageId: "\(upPageCusor*10+upPageListCount)", sentDate: Date(), kind: .text("📢 This is not realtime chatting\n      Please need scroll"))
                await MainActor.run {
                    insertMessage(serviceMessage)
                    messagesCollectionView.scrollToLastItem()
                }
            }
            upPageListCount = clipBoardListCount%10 // 0
            if upPageListCount == 0 {
                upPageCusor += 1
            }
//                upPageListCount = clipBoardListCount
//                if upPageListCount == 10 {
//                    upPageListCount = clipBoardListCount%10
//                    upPageCusor += 1
//                }
        }
        await MainActor.run {
            messagesCollectionView.reloadSections([messages.count-1])
        }
        isPaging = false
    }
    
    func loadClipBoardTop() async {
        if isPaging || downPageCursor < 0 { return }
        else { isPaging = true }
        let getData = await fetchClipBoardData(page: downPageCursor)
        guard let totalPage = getData?.totalPage else { return }
        print("삽입 전upPageCursor, totalPage", upPageCusor, totalPage)
        guard let clipBoardList = getData?.getClipBoardResList else { return }
        let clipBoardListCount = clipBoardList.count
        guard let userItem = try? KeychainManager.getUserItem() else { return }
        var insertMessages: [Message] = []
        for i in 0..<clipBoardListCount { // 8
            print("LoadTop upPageListCount, clipBoardListCount", upPageListCount, clipBoardListCount)
            let sender = Sender(senderId: "\(clipBoardList[i].userID)", displayName:  clipBoardList[i].userName)
            if avatarImages[sender.senderId] == nil {
//                let profileImage = await clipBoardList[i].profileImgURL.urlToImage()
//                avatarImages[sender.senderId] = profileImage
//                clipBoardList[i].profileImgURL.loadImage { (image) in
//                    guard let image = image else {
//                        print("Error loading image")
//                        return
//                    }
//                    self.avatarImages[sender.senderId] = image
//                }
                let profileImage = clipBoardList[i].profileImgURL.loadImageAsync()
                self.avatarImages[sender.senderId] = profileImage
            }
            
//            if userItem.userId == clipBoardList[i].userID {
//                currentUser.senderId = "\(clipBoardList[i].userID)"
//                currentUser.displayName = clipBoardList[i].userName
//            }
            guard let sendDate = clipBoardList[i].createdAt.stringToDate() else { return }
            let message = Message(sender: sender, messageId: "\(clipBoardList[i].clipBoardID)", sentDate: sendDate, kind: .text(clipBoardList[i].content))
            insertMessages.append(message)
        }
        messages.insert(contentsOf: insertMessages, at: 0)
        await MainActor.run {
            messagesCollectionView.reloadDataAndKeepOffset()
        }
        isPaging = false
        downPageCursor -= 1
    }
    
    // 마지막 메세지 삭제시, footerView 마지막 섹션에 존재함으로 에러 발생
    // 업데이후 삭제 및 업데이트
    
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//        // keyboardHeight = keyboardNotification.endFrame.height
        Task(priority: .medium) {
////            if !keyboardManager.isKeyboardHidden { print("올라옴 keyboard") }
////            else { print("안올라옴 keyboard") }
////            print("messagesCollectionView.inputAccessoryView?.frame.height", messagesCollectionView.inputAccessoryView?.frame.height)
////            print("messageInputBar.frame.height", messageInputBar.frame.height)
////            print("messagesCollectionView.contentInset.bottom", messagesCollectionView.contentInset.bottom)
////            print("messagesCollectionView.scrollIndicatorInsets.bottom", messagesCollectionView.scrollIndicatorInsets.bottom)
//
            print("scrollView.contentOffset.y", scrollView.contentOffset.y) // -253
            if scrollView.tag == 1 {
                if scrollView.contentOffset.y < 0 { // view.safeAreaInsets.top+200
                    print("Upload for  scroling")
                    await loadClipBoardTop()
                    print("End Top Load")
                }
                else if (scrollView.contentOffset.y > (scrollView.contentSize.height-scrollView.frame.size
                    .height - 50)) { // +messagesCollectionView.contentInset.bottom+messageInputBar.frame.height
                    print("Upload for up scroling")
//                    print("Upload for down scroling", scrollView.contentSize.height-scrollView.frame.size
//                        .height+messagesCollectionView.contentInset.bottom+messageInputBar.frame.height)
                    await loadClipBoardBottom()
                    print("End Bottom Load")
                }
            }
        }
    }
    
    
//    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        Task(priority: .low) {
//            if scrollView.tag == 1 {
//                if scrollView.contentOffset.y <= scrollView.contentSize.height-scrollView.frame.size
//                    .height { // view.safeAreaInsets.top+200
//                    print("Upload for Up scroling")
//                    await loadClipBoardDown()
//                    print("위")
//                }
//            }
//        }
//    }
}
