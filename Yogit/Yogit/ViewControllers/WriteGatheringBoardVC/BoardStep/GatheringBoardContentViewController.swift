//
//  GatheringTextDetailViewController.swift
//  Yogit
//
//  Created by Junseo Park on 2022/11/12.
//

import UIKit
import Alamofire
import SnapKit
import BSImagePicker
import Photos
import ProgressHUD

// 글자수 n 글자 이상 m 이하
class GatheringBoardContentViewController: UIViewController {
    
    var boardWithMode = BoardWithMode() {
        didSet {
            print("boardWithMdoe", boardWithMode)
        }
    }
    
    private var deletedImageIds: [Int64] = []
    private var newImagesIdx: Int = 0 // 기존 이미지 개수 저장, 삭제한 이미지 개수저장 >> 기존이미지(3개) - 삭제한 이미지(2개) >> post(patch) req: 1번 인덱스 부터 끝지점
    private let step: Float = 2.0
    
    private var headerView: [MyHeaderView] = [MyHeaderView(), MyHeaderView(), MyHeaderView(), MyHeaderView()]
    private var textViews = [MyTextView(), MyTextView(), MyTextView()]
    private let placeholderData = [GatheringElement.title.toHolder().localized(), GatheringElement.introduction.toHolder().localized(), GatheringElement.kindOfPerson.toHolder().localized()]
    private var textViewCount = [0, 0, 0]
    private let minChar = [10, 50, 30]
    private let maxChar = [50, 3000, 3000]
    
    private lazy var stepHeaderView: StepHeaderView = {
        let view = StepHeaderView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 70), step: step)
        view.titleLabel.text = "GATHERING_CONTENT".localized()
        return view
    }()
    
    private lazy var rightButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "DONE".localized(), style: .plain, target: self, action: #selector(buttonPressed(_:)))
        button.tintColor =  ServiceColor.primaryColor
        return button
    }()
    
 
    private let loadingGuideLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.medium)
        label.sizeToFit()
        label.textAlignment = .left
        label.numberOfLines = 0
        label.textColor = .systemGray
        label.adjustsFontSizeToFitWidth = true
        label.text = "GATHERING_IMAGES_LOADING_LABEL".localized()
        return label
    }()
    
    private lazy var imageLoadingView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.2
        view.layer.shadowOffset = CGSize(width: 2, height: 2)
        view.layer.shadowRadius = 4
        view.layer.masksToBounds = false
        view.layer.cornerRadius = 10
        view.alpha = 0.0
        view.isHidden = true
        view.addSubview(activityIndicator)
        view.addSubview(loadingGuideLabel)
        return view
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    private let imagesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 10)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(MyImagesCollectionViewCell.self, forCellWithReuseIdentifier: MyImagesCollectionViewCell.identifier)
        collectionView.backgroundColor = .systemBackground
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    private lazy var contentScrollView: UIScrollView = {
       let scrollView = UIScrollView()
        scrollView.isScrollEnabled = true
        scrollView.backgroundColor = .systemBackground
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        [self.headerView[0],
         self.imagesCollectionView,
         self.headerView[1],
         self.textViews[0],
         self.headerView[2],
         self.textViews[1],
         self.headerView[3],
         self.textViews[2]].forEach { view.addSubview($0) }
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNav()
        configureView()
        configureCollectionView()
        configureTextView()
        configureHeader()
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
        
        contentScrollView.snp.makeConstraints { make in
            make.top.equalTo(stepHeaderView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.width.equalToSuperview()
            $0.centerX.bottom.equalToSuperview()
        }
        
        headerView[0].snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(10)
            $0.height.equalTo(22)
        }
        imagesCollectionView.snp.makeConstraints { make in
            make.top.equalTo(headerView[0].snp.bottom)
            make.width.equalToSuperview()
            make.height.equalTo(90)
        }
        headerView[1].snp.makeConstraints {
            $0.top.equalTo(imagesCollectionView.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(10)
            $0.height.equalTo(22)
        }
        textViews[0].snp.makeConstraints { make in
            make.top.equalTo(headerView[1].snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(78)
        }
        headerView[2].snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(10)
            $0.top.equalTo(textViews[0].snp.bottom).offset(20)
            $0.height.equalTo(22)
        }
        textViews[1].snp.makeConstraints { make in
            make.top.equalTo(headerView[2].snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(300)
        }
        headerView[3].snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(10)
            $0.top.equalTo(textViews[1].snp.bottom).offset(20)
            $0.height.equalTo(22)
        }
        textViews[2].snp.makeConstraints { make in
            make.top.equalTo(headerView[3].snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(300)
            make.bottom.equalToSuperview().inset(30)
        }
        imageLoadingView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(56)
        }
        activityIndicator.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
        }
        loadingGuideLabel.snp.makeConstraints {
            $0.leading.equalTo(activityIndicator.snp.trailing).offset(10)
            $0.top.bottom.trailing.equalToSuperview().inset(10)
        }
    }
    
    private func configureView() {
        view.addSubview(stepHeaderView)
        view.addSubview(imageLoadingView)
        view.addSubview(contentScrollView)
        view.backgroundColor = .systemBackground
        self.hideKeyboardWhenTappedAround()
    }
    
    private func configureNav() {
        self.navigationItem.rightBarButtonItem = self.rightButton
    }
    
    private func configureCollectionView() {
        imagesCollectionView.delegate = self
        imagesCollectionView.dataSource = self
    }
    
    private func configureTextView() {
        self.textViews[0].myTextView.text = boardWithMode.title ?? placeholderData[0]
        self.textViews[1].myTextView.text = boardWithMode.introduction ?? placeholderData[1]
        self.textViews[2].myTextView.text = boardWithMode.kindOfPerson ?? placeholderData[2]
        for i in 0..<3 {
            self.textViews[i].myTextView.delegate = self
            self.textViews[i].myTextView.tag = i
            self.textViews[i].textCountLabel.text = "0 / \(maxChar[i])"
            if boardWithMode.mode == .edit {
                self.textViewDidChange(textViews[i].myTextView)
                self.textViews[i].myTextView.textColor = UIColor.label
            }
        }
    }
    
    private func configureHeader() {
        self.headerView[0].contentNameLabel.text = GatheringElement.photos.toTitle().localized()
        self.headerView[1].contentNameLabel.text = GatheringElement.title.toTitle().localized()
        self.headerView[2].contentNameLabel.text = GatheringElement.introduction.toTitle().localized()
        self.headerView[3].contentNameLabel.text = GatheringElement.kindOfPerson.toTitle().localized()
    }
    
    private var hasMssingData: String? {
        if boardWithMode.downloadImages.count + boardWithMode.uploadImages.count == 0 {
            return "PHOTO".localized()
        }
        for i in 0..<3 {
            if !(textViewCount[i] >= minChar[i] && textViewCount[i] <= maxChar[i]) {
                return self.headerView[i+1].contentNameLabel.text?.lowercased()
            }
        }
        return nil
    }
    

    @objc func buttonPressed(_ sender: UIButton) {
        
        guard hasMssingData == nil else {
            print("Not has all value")
            let message = String(format: "GATHERING_CONTENT_ALERT_MESSAGE".localized(), "\(hasMssingData!)")
            let alert = UIAlertController(title: "", message: message, preferredStyle: UIAlertController.Style.alert)
            let okAction = UIAlertAction(title: "OK".localized(), style: .default)
            alert.addAction(okAction)
            present(alert, animated: false, completion: nil)
            return
        }
        
        // 통신완료 후 pop root까지
        // hostId 등록시 필요? >> userId와 hostId 같기때문 (나중에 한 클럽 모임당 host가 많을수도 있다.)
        // hostId 받아올때만 필요하다.
        print("buttonPressed buttonPressed", boardWithMode)
        
        guard let identifier = UserDefaults.standard.object(forKey: SessionManager.currentServiceTypeIdentifier) as? String, let userItem = try? KeychainManager.getUserItem(serviceType: identifier),
              let title = boardWithMode.title,
              let address = boardWithMode.address,
              let longitute = boardWithMode.longitute,
              let latitude = boardWithMode.latitude,
              let date = boardWithMode.date,
              let cityName = boardWithMode.city,
              let introduction = boardWithMode.introduction,
              let kindOfPerson = boardWithMode.kindOfPerson,
              let totoalMember = boardWithMode.totalMember,
              let categoryId = boardWithMode.categoryId
        else {
            print("edit gurad 실패")
            return
        }
        
        ProgressHUD.colorAnimation = ServiceColor.primaryColor
        ProgressHUD.animationType = .circleStrokeSpin
        ProgressHUD.show(interaction: false)
        
        let updateBoard = UpdateBoard(userId: userItem.userId, refreshToken: userItem.refresh_token, boardId: boardWithMode.boardId, hostId: userItem.userId, title: title, address: address, addressDetail: boardWithMode.addressDetail, longitute: longitute, latitude: latitude, date: date, notice: boardWithMode.notice, cityName: cityName, introduction: introduction, kindOfPerson: kindOfPerson, totalMember: totoalMember, categoryId: categoryId, deleteImageIds: boardWithMode.deleteImageIds, images: boardWithMode.uploadImages)

        let urlRequestConvertible: BoardRouter
        if boardWithMode.mode == .edit {
            urlRequestConvertible = BoardRouter.updateBoard(parameters: updateBoard)
        } else {
            urlRequestConvertible = BoardRouter.createBoard(parameters: updateBoard)
        }

        if let data = boardWithMode.introduction!.data(using: .utf8) {
            let bytes = [UInt8](data)
            print("소개글 바이트수", bytes)
        }
        
        if let parameters = urlRequestConvertible.toDictionary {
            print("Upload parameters", parameters)
            AlamofireManager.shared.session.upload(multipartFormData: { multipartFormData in
                for (key, value) in parameters {
                    if let arrayValue = value as? [Any]  {
                        if let images = arrayValue as? [UIImage] {
                            for image in images {
                                multipartFormData.append(image.toFile(format: .jpeg(0.7))!, withName: key, fileName: key + ".jpeg", mimeType: key + "/jpeg")
                            }
                        } else {
                            for element in arrayValue {
                                multipartFormData.append(Data("\(element)".utf8), withName: key)
                            }
                        }
                    } else {
                        if let image = value as? UIImage {
                            multipartFormData.append(image.toFile(format: .jpeg(0.7))!, withName: key, fileName: key + ".jpeg", mimeType: key + "/jpeg")
                        } else {
                            multipartFormData.append(Data("\(value)".utf8), withName: key)
                        }
                    }
                }
            }, with: urlRequestConvertible).validate(statusCode: 200..<501).responseDecodable(of: APIResponse<BoardDetail>.self) { response in
                switch response.result {
                case .success:
                    if let value = response.value, value.httpCode == 201 || value.httpCode == 200, let data = value.data {
                        print("Success - Upload Board")
                        DispatchQueue.main.async(qos: .userInteractive) { [self] in
                            navigationController?.popToRootViewController(animated: true)
                            NotificationCenter.default.post(name: .baordDetailRefresh, object: data) // root가 뭔지 알아야 해당 rootview refresh 가능, 따라서 boardWithMode에 VC 저장
                        }
                    }
                case let .failure(error):
                    print("SetProfileImagesVC - upload response result Not return", error)
                }
                DispatchQueue.main.async {
                    ProgressHUD.dismiss()
                }
            }
        }

    }
}

extension GatheringBoardContentViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cancel = UIAlertAction(title: "CANCEL".localized(), style: .cancel, handler: nil)
        if indexPath.row < boardWithMode.downloadImages.count + boardWithMode.uploadImages.count {
            let delete = UIAlertAction(title: "DELETE".localized(), style: .destructive) { (action) in self.deleteImage(indexPath.row)}
            alert.addAction(delete)
            alert.addAction(cancel)
        } else {
            let library = UIAlertAction(title: "UPLOAD_PHOTO".localized(), style: .default) { (action) in self.openLibrary() }
            let camera = UIAlertAction(title: "TAKE_PHOTO".localized(), style: .default) { (action) in self.openCamera() }
            alert.addAction(library)
            alert.addAction(camera)
            alert.addAction(cancel)
        }
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
}

extension GatheringBoardContentViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let imagesCnt = boardWithMode.downloadImages.count + boardWithMode.uploadImages.count
        return imagesCnt < 5 ? (imagesCnt + 1) : 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier:  MyImagesCollectionViewCell.identifier, for: indexPath) as? MyImagesCollectionViewCell else { return UICollectionViewCell() }
        if indexPath.row < boardWithMode.downloadImages.count {
            cell.configureDownload(imageString: boardWithMode.downloadImages[indexPath.row], sequence: indexPath.row + 1, kind: Kind.boardSelectDetail)
        } else if indexPath.row < boardWithMode.downloadImages.count + boardWithMode.uploadImages.count {
            cell.configureUpload(image: boardWithMode.uploadImages[indexPath.row - boardWithMode.downloadImages.count], sequence: indexPath.row + 1, kind: Kind.boardSelectDetail)
        } else {
            cell.configureNull(image: UIImage(named: "IMAGE_NULL")?.withRenderingMode(.alwaysTemplate), sequence: indexPath.row + 1, kind: Kind.boardSelectDetail)
        }
        return cell
    }
}

extension GatheringBoardContentViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.frame.height - 20, height: collectionView.frame.height - 20)
    }
}

extension GatheringBoardContentViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
//    private func convertAssetsToImages(asstes: [PHAsset]) -> [UIImage] {
//        var images = [UIImage]()
//        let imageManager = PHImageManager.default()
//        let option = PHImageRequestOptions()
////        option.deliveryMode = .fastFormat//.highQualityFormat
////        option.resizeMode = .exact
//        option.isSynchronous = true
//        option.isNetworkAccessAllowed = true
//
//        // CGSize(width: view.frame.size.width, height: view.frame.size.height)
//        let newSize = CGSize(width: view.frame.size.width*2, height: view.frame.size.height*2)
//        for i in 0..<asstes.count {
//
//            imageManager.requestImage(for: asstes[i],
//                                      targetSize: newSize,
//                                      contentMode: .aspectFit,
//                                      options: option) { (result, info) in
//                if let image = result {
//                    images.append(image)
//                    print("image and image size", image, image.size)
////                    print("이미지 크기", image.toFile(format: .jpeg(1.0))!)
////                    let resized = image.resize(targetSize: CGSize(width: self.view.frame.size.width, height: self.view.frame.size.height))
////                    print("resized and resized size", resized, resized.size)
////                    print("이미지 크기", resized.toFile(format: .jpeg(1.0))!)
//                }
//            }
//        }
//        return images
//    }
    
    private func showImageLoading() {
        DispatchQueue.main.async { [weak self] in
            self?.imageLoadingView.isHidden = false
            self?.activityIndicator.startAnimating()
            UIView.animate(withDuration: 1.0, animations: {
                // 뷰의 alpha 속성을 1로 설정하여 서서히 나타나도록 함
                self?.imageLoadingView.alpha = 1.0
            })
        }
    }
    
    private func dismissImageLoading() {
        DispatchQueue.main.async { [weak self] in
            UIView.animate(withDuration: 1.0, animations: {
                // 뷰의 alpha 속성을 0으로 설정하여 서서히 사라지도록 함
                self?.imageLoadingView.alpha = 0.0
            }) { (completed) in
                self?.imageLoadingView.isHidden = true
            }
            self?.activityIndicator.stopAnimating()
        }
    }
    
    private func convertAssetsToImages(asstes: [PHAsset]) async -> [UIImage] {
        
        let imageManager = PHImageManager.default()
        let option = PHImageRequestOptions()
//        option.deliveryMode = .fastFormat//.highQualityFormat
//        option.resizeMode = .exact
        option.isSynchronous = true
        option.isNetworkAccessAllowed = true
        
        showImageLoading()
        
        let newSize = CGSize(width: view.frame.size.width*2, height: view.frame.size.height*2)

        var images = [UIImage?](repeating: nil, count: asstes.count)
        await withTaskGroup(of: Void.self, body: { taskGroup in
            for i in 0..<asstes.count {
                taskGroup.addTask { [i] in
                    imageManager.requestImage(for: asstes[i],
                                              targetSize: newSize,
                                              contentMode: .aspectFit,
                                              options: option) { (result, info) in
                        if let image = result {
                            DispatchQueue.main.sync {
                                images[i] = image
                            }
                        }
                    }
                }
            }
        })
        let orderedImages = images.compactMap { $0 } // nil을 제거하고 순서를 보장한 배열을 생성
        
        dismissImageLoading()
        
        return orderedImages
    }
    
    private func convertAssetsToImagesGCD(asstes: [PHAsset], newSize: CGSize) -> [UIImage] {
        
        let imageManager = PHImageManager.default()
        let option = PHImageRequestOptions()
//        option.deliveryMode = .fastFormat//.highQualityFormat
//        option.resizeMode = .exact
        option.isSynchronous = true
        option.isNetworkAccessAllowed = true
        
        showImageLoading()
        
        let dispatchGroup = DispatchGroup()
        let dispatchQueue = DispatchQueue(label: "Downloading_Image")

        var images = [UIImage?](repeating: nil, count: asstes.count)
        for i in 0..<asstes.count {
            dispatchGroup.enter()
            dispatchQueue.async { [i] in
                imageManager.requestImage(for: asstes[i],
                                          targetSize: newSize,
                                          contentMode: .aspectFit,
                                          options: option) { (result, info) in
                    if let image = result {
                        images[i] = image
                    }
                    dispatchGroup.leave()
                }
            }
        }
        
        dispatchGroup.wait()
           
        let orderedImages = images.compactMap { $0 } // nil을 제거하고 순서를 보장한 배열을 생성
        
        dismissImageLoading()
     
        return orderedImages
    }
    
    private func openLibrary() {
        let imagePicker = ImagePickerController()
        imagePicker.settings.selection.max = 5 - boardWithMode.downloadImages.count - boardWithMode.uploadImages.count
        imagePicker.settings.theme.selectionStyle = .numbered
        imagePicker.settings.fetch.assets.supportedMediaTypes = [.image]
        ImageManager.shared.requestPHPhotoLibraryAuthorization { (Auth) in
            if Auth {
                self.presentImagePicker(imagePicker, select: { (asset) in
                    print("Selected: \(asset)")
                }, deselect: { (asset) in
                    print("Deselected: \(asset)")
                }, cancel: { (assets) in
                    print("Canceled with selections: \(assets)")
                }, finish: { (assets) in
//                    Task.detached(priority: .background) {
//                        let appendImages = await self.convertAssetsToImages(asstes: assets)
//                        await MainActor.run {
//                            self.boardWithMode.uploadImages.append(contentsOf: appendImages)
//                            self.imagesCollectionView.reloadData()
//                        }
//                    }
                    let newSize = CGSize(width: self.view.frame.size.width*2, height: self.view.frame.size.height*2)
                    DispatchQueue.global().async { [weak self] in
                        guard let appendImages = self?.convertAssetsToImagesGCD(asstes: assets, newSize: newSize) else { return }
                        DispatchQueue.main.async {
                            self?.boardWithMode.uploadImages.append(contentsOf: appendImages)
                            self?.imagesCollectionView.reloadData()
                        }
                    }
                    
                    
                }, completion: {
                    
                })
            } else {
                DispatchQueue.main.async {
                    self.setAuthAlertAction("PHOTO".localized())
                }
            }
        }
    }

    private func openCamera() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        ImageManager.shared.checkCameraAuthorization { (Auth) in
            DispatchQueue.main.async(qos: .userInteractive) {
                if Auth {
                    self.present(imagePicker, animated: true, completion: nil)
                } else {
                    self.setAuthAlertAction("CAMERA".localized())
                }
            }
        }
    }

    private func deleteImage(_ index: Int) {
        if boardWithMode.imageIds.count - 1 >= index { // download된 이미지만 삭제
            boardWithMode.deleteImageIds =  boardWithMode.deleteImageIds ?? []
            let deletedImageId =  boardWithMode.imageIds.remove(at: index)
            boardWithMode.deleteImageIds?.append(deletedImageId)
            boardWithMode.downloadImages.remove(at: index)
        } else {
            boardWithMode.uploadImages.remove(at: index - boardWithMode.downloadImages.count)
        }
        DispatchQueue.main.async {
            self.imagesCollectionView.reloadData()
        }
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            let resizeImage = image.resize(targetSize: CGSize(width: self.view.frame.size.width, height: self.view.frame.size.width))
            boardWithMode.uploadImages.append(resizeImage)
        }
        DispatchQueue.main.async {
            self.imagesCollectionView.reloadData()
            self.dismiss(animated: true, completion: nil)
        }
    }
}


extension GatheringBoardContentViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        print(" shouldChangeTextIn",textView.tag)
//        if textView.tag == 0 && text == "\n" { textView.resignFirstResponder() }
        
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
        print("textViewDidBeginEditing",textView.tag)
        if textView.text == placeholderData[textView.tag] {
            textView.text = nil
            textView.text = nil
            textView.textColor = .label
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        print("textViewDidEndEditing",textView.tag)
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text =  placeholderData[textView.tag]
            textView.textColor = .placeholderText
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        
        print("textViewDidChange", textView.text.count)
        if textView.text.count == 0 {
            textViews[textView.tag].textCountLabel.textColor = .placeholderText
        }
        else if textView.text.count >= minChar[textView.tag] {
            textViews[textView.tag].textCountLabel.textColor = ServiceColor.primaryColor
        } else {
            textViews[textView.tag].textCountLabel.textColor = .red
        }
        textViews[textView.tag].textCountLabel.text = "\(textView.text.count) / \(maxChar[textView.tag])"
        textViewCount[textView.tag] = textView.text.count

        switch textView.tag {
        case 0: boardWithMode.title = textView.text
        case 1: boardWithMode.introduction = textView.text
        case 2: boardWithMode.kindOfPerson = textView.text
        default: fatalError("Gathering board textview error")
        }
    }
}

extension GatheringBoardContentViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false // 해당 뷰컨의 뷰안에는 터치 못하게
        view.addGestureRecognizer(tap)
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}

