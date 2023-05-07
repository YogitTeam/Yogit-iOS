//
//  ClipBoardViewController.swift
//  Yogit
//
//  Created by Junseo Park on 2023/01/01.
//

import MapKit
import MessageKit
import InputBarAccessoryView
import UIKit
import ProgressHUD

class ClipBoardViewController: ChatViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureInit()
    }
    
    func configureInit() {
        self.navigationController?.navigationBar.topItem?.backButtonTitle = ""
        let serviceMessage = Message(sender: self.service, messageId: "\(serviceMessageId)", sentDate: Date(), kind: .text(serviceNotice))
        messages.append(serviceMessage)
        messagesCollectionView.reloadData()
        ProgressHUD.colorAnimation = ServiceColor.primaryColor
        ProgressHUD.animationType = .circleStrokeSpin
        ProgressHUD.show(interaction: true)
        loadFirstMessages()
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

extension ClipBoardViewController: MessagesDisplayDelegate {

    private func createLoadingView(footerView: MessageReusableView, isLoading: Bool, section: Int) -> MessageReusableView {
        
        // 로딩중이면, footerview 생성후 애니메이션실행
        // 로딩중이 아니면, break
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
        let footerView = messagesCollectionView.dequeueReusableFooterView(MessageReusableView.self, for: indexPath)
        footerView.subviews.forEach { $0.removeFromSuperview() }
        return createLoadingView(footerView: footerView,isLoading: isLoading, section: indexPath.section)
    }
    
    func textColor(for message: MessageType, at _: IndexPath, in _: MessagesCollectionView) -> UIColor {
        if message.sender.senderId == "SERVICE" { return .white }
        else { return .label }
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
        if message.sender.senderId == "SERVICE" { return ServiceColor.primaryColor }
        else { return isFromCurrentSender(message: message) ? UIColor(rgb: 0x7979FF, alpha: 1.0) : .systemGray5 }
  //      isFromCurrentSender(message: message) ? ServiceColor.primaryColor : .systemGray4 //UIColor(red: 230 / 255, green: 230 / 255, blue: 230 / 255, alpha: 1)
    }
      
    

    func messageStyle(for message: MessageType, at _: IndexPath, in _: MessagesCollectionView) -> MessageStyle {
      let tail: MessageStyle.TailCorner = isFromCurrentSender(message: message) ? .bottomRight : .bottomLeft
      return .bubbleTail(tail, .curved)
    }
    
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at _: IndexPath, in _: MessagesCollectionView) {
        let avatar = getAvatarFor(sender: message.sender)
        avatarView.set(avatar: avatar)
    }
      
      
//      func configureAccessoryView(_ accessoryView: UIView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
//          accessoryView
//      }

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

extension ClipBoardViewController: MessagesLayoutDelegate {
    // footerview 사이즈 미리 업데이트
    func footerViewSize(for section: Int, in messagesCollectionView: MessagesCollectionView) -> CGSize {
        if section == messages.count - 1 && isLoading { // && isPaging
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

extension ClipBoardViewController {
    
    func loadClipBoardTop(userId: Int64, refreshToken: String, boardId: Int64) async {
        do {
            let getAllClipBoardsReq = GetAllClipBoardsReq(boardId: boardId, cursor: downPageCursor, refreshToken: refreshToken, userId: userId)
            let getData = try await fetchClipBoardData(getAllClipBoardsReq: getAllClipBoardsReq)
            let clipBoardList = getData.getClipBoardResList
            let clipBoardListCount = clipBoardList.count
            var insertMessages: [Message] = []
            for i in 0..<clipBoardListCount { // 8
                let sender = Sender(senderId: "\(clipBoardList[i].userID)", displayName: clipBoardList[i].userName ?? "UNKNOWN".localized())
                if avatarImages[sender.senderId] == nil {
                    if !clipBoardList[i].profileImgURL.contains("null") {
//                        let profileImage = clipBoardList[i].profileImgURL.loadImageAsync()
                        let profileImage = ImageManager.downloadImageWait(with: clipBoardList[i].profileImgURL)
                        self.avatarImages[sender.senderId] = profileImage
                    } else {
                        self.avatarImages[sender.senderId] = UIImage(named: "PROFILE_IMAGE_NULL")
                    }
                }
                guard let sendDate = clipBoardList[i].createdAt.stringToDate() else { return }
                let message = Message(sender: sender, messageId: "\(clipBoardList[i].clipBoardID)", sentDate: sendDate, kind: .text(clipBoardList[i].content))
                insertMessages.append(message)
            }
            messages.insert(contentsOf: insertMessages, at: 0)
            await MainActor.run {
                messagesCollectionView.reloadDataAndKeepOffset()
            }
            downPageCursor -= 1
        } catch {
            print("fetchClipBoardData error \(error.localizedDescription)")
        }
        isPaging = false
    }
    
    func loadClipBoardBottom(isInit: Bool,userId: Int64, refreshToken: String, boardId: Int64) async {
        isLoading = false
        let startTime = DispatchTime.now().uptimeNanoseconds
        do {
            let getAllClipBoardsReq = GetAllClipBoardsReq(boardId: boardId, cursor: upPageCusor, refreshToken: refreshToken, userId: userId)
            let getData = try await fetchClipBoardData(getAllClipBoardsReq: getAllClipBoardsReq)
            // 네트워크 속도가 빠른경우에, 로딩화면 렌더링 시간이 거의 없음
            // 만약 0.5초 이내이면 지연하고 실행해야함
            let endTime = DispatchTime.now().uptimeNanoseconds
            let elapsedTime = endTime - startTime
            if elapsedTime <= 500_000_000 && !isInit {
                try await Task.sleep(nanoseconds: 500_000_000 - elapsedTime)
            }
            let totalPage = getData.totalPage
            if upPageCusor < totalPage { // 현재페이지 토탈페이지-1 이고 개수 10보다 작으면 막아야함
                let clipBoardList = getData.getClipBoardResList
                let clipBoardListCount = clipBoardList.count
                for i in upPageListCount..<clipBoardListCount { // 8
                    let sender = Sender(senderId: "\(clipBoardList[i].userID)", displayName: clipBoardList[i].userName ?? "UNKNOWN".localized())
                    if avatarImages[sender.senderId] == nil {
                        if !clipBoardList[i].profileImgURL.contains("null") {
//                            let profileImage = clipBoardList[i].profileImgURL.loadImageAsync()
                            let profileImage = ImageManager.downloadImageWait(with: clipBoardList[i].profileImgURL)
                            self.avatarImages[sender.senderId] = profileImage
                        } else {
                            self.avatarImages[sender.senderId] = UIImage(named: "PROFILE_IMAGE_NULL")
                        }
                    }
                    guard let sendDate = clipBoardList[i].createdAt.stringToDate() else { return }
                    let message = Message(sender: sender, messageId: "\(clipBoardList[i].clipBoardID)", sentDate: sendDate, kind: .text(clipBoardList[i].content))
                    await MainActor.run {
                        if i != upPageListCount {
                            insertMessage(message)
                        } else {
                            insertFirst(message)
                        }
                    }
                }
                if upPageListCount < clipBoardListCount {
                    let serviceMessage = Message(sender: service, messageId: "\(serviceMessageId)", sentDate: Date(), kind: .text(serviceNotice))
                    await MainActor.run {
                        insertMessage(serviceMessage)
                        messagesCollectionView.scrollToLastItem()
                    }
                }
                upPageListCount = clipBoardListCount%modular
                if upPageListCount == 0 {
                    upPageCusor += 1
                }
            }
        } catch {
            print("fetchClipBoardData error \(error.localizedDescription)")
        }
        await MainActor.run {
            messagesCollectionView.reloadSections([messages.count-1])
        }
        isPaging = false
    }
    
    func loadFirstMessages() {
        guard let identifier = UserDefaults.standard.object(forKey: SessionManager.currentServiceTypeIdentifier) as? String else { return }
        guard let userItem = try? KeychainManager.getUserItem(serviceType: identifier) else { return }
        guard let boardId = self.boardId else { return }
        Task(priority: .high) {
            let getAllClipBoardsReq = GetAllClipBoardsReq(boardId: boardId, cursor: upPageCusor, refreshToken: userItem.refresh_token, userId: userItem.userId)
            let checkGetData = try await fetchClipBoardData(getAllClipBoardsReq: getAllClipBoardsReq)
            let totalPage = checkGetData.totalPage
            // totalpage == 1이면 그대로 사용
            // totalpage > 1이상이면 마지막 두개 페이지 로드
            if upPageCusor < totalPage {
                upPageCusor = totalPage-1 // 0 부터 시작
                downPageCursor = upPageCusor-1
                Task {
                    if totalPage == 1 { // 한페이지만 존재
                        await loadClipBoardBottom(isInit: true, userId: userItem.userId, refreshToken: userItem.refresh_token, boardId: boardId)
                    } else {
                        await loadClipBoardTop(userId: userItem.userId, refreshToken: userItem.refresh_token, boardId: boardId)
                        await loadClipBoardBottom(isInit: true,userId: userItem.userId, refreshToken: userItem.refresh_token, boardId: boardId)
                    }
                }
            }
            await MainActor.run {
                ProgressHUD.dismiss()
            }
        }
    }
    
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let contentOffSetY = scrollView.contentOffset.y
        let contentInsetTop = scrollView.contentInset.top
        let contentSizeHeight = scrollView.contentSize.height
        let frameSizeHeight = scrollView.frame.size.height
        if scrollView == messagesCollectionView && !isPaging {
            guard let identifier = UserDefaults.standard.object(forKey: SessionManager.currentServiceTypeIdentifier) as? String,
                  let userItem = try? KeychainManager.getUserItem(serviceType: identifier),
                  let boardId = self.boardId
            else { return }
            isPaging = true
            if contentOffSetY <= -contentInsetTop && downPageCursor >= 0 { // top scroll
                Task(priority: .low) {
                    await loadClipBoardTop(userId: userItem.userId, refreshToken: userItem.refresh_token, boardId: boardId)
                }
            }
            else if (contentOffSetY > (contentSizeHeight-frameSizeHeight)) { // bottom scroll
                isLoading = true
                messagesCollectionView.reloadSections([messages.count-1])
                Task(priority: .medium) {
                    await loadClipBoardBottom(isInit: false, userId: userItem.userId, refreshToken: userItem.refresh_token, boardId: boardId)
                }
            } else {
                isPaging = false
            }
        }
    }
}

