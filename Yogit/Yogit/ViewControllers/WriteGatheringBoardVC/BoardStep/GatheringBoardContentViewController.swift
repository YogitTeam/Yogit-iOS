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
//    var createBoardReq = CreateBoardReq() {
//        didSet {
//            print("BoardTextDetail \(createBoardReq)")
//        }
//    }
//    var images: [UIImage] = [] {
//        didSet {
//            imagesCollectionView.reloadData()
//            print("Images reloaded")
//        }
//    }
//    var mode: Mode?
    
//    var boardWithMode = BoardWithMode(boardReq: CreateBoardReq(), boardId: nil, imageIds: [], images: []) {
//        didSet {
//            print("boardWithMode 3 \(boardWithMode)")
//        }
//    }
    
    var boardWithMode = BoardWithMode() {
        didSet {
            print("boardWithMdoe", boardWithMode)
        }
    }
    
    private var deletedImageIds: [Int64] = []
    private var newImagesIdx: Int = 0 // 기존 이미지 개수 저장, 삭제한 이미지 개수저장 >> 기존이미지(3개) - 삭제한 이미지(2개) >> post(patch) req: 1번 인덱스 부터 끝지점
    
    private var imagePicker: UIImagePickerController?

    private let stepHeaderView = StepHeaderView()
    private let step: Float = 3.0
    private var headerView: [MyHeaderView] = [MyHeaderView(), MyHeaderView(), MyHeaderView(), MyHeaderView()]
    private var textViews = [MyTextView(), MyTextView(), MyTextView()]
    private let placeholderData = ["Ex) Hangout", "Ex) Hangout", "Ex) Hangout"]
    private var textViewCount = [0, 0, 0]
    private let minChar = [10, 50, 50]
    private let maxChar = [50, 2000, 2000]
    
    private lazy var rightButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(buttonPressed(_:)))
        button.tintColor =  UIColor(rgb: 0x3232FF, alpha: 1.0)
        return button
    }()
    
//    private let textDetailTableView: UITableView = {
//        let tableView = UITableView(frame: .zero, style: .grouped)
//        tableView.separatorStyle = .none
//        tableView.backgroundColor = .systemBackground
//        tableView.isScrollEnabled = false
//        tableView.sectionHeaderTopPadding = 10
//        tableView.register(MyTextViewTableViewCell.self, forCellReuseIdentifier: MyTextViewTableViewCell.identifier)
//        tableView.register(RequirementTableViewHeader.self, forHeaderFooterViewReuseIdentifier: RequirementTableViewHeader.identifier)
//        return tableView
//    }()
    
    private let imagesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 10)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.register(MyImagesCollectionViewCell.self, forCellWithReuseIdentifier: MyImagesCollectionViewCell.identifier)
//        collectionView.layer.borderColor = UIColor.systemGray.cgColor
//        collectionView.layer.borderWidth = 1
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
    
//    private let titleTextView: UITextView = {
//        let textView = UITextView()
//        textView.backgroundColor = .systemBackground
//        textView.font = .systemFont(ofSize: 17, weight: UIFont.Weight.regular)
//        textView.layer.borderWidth = 1
//        textView.layer.borderColor = UIColor.placeholderText.cgColor
//        textView.layer.cornerRadius = 8
//        textView.textColor = .placeholderText
//        textView.textContainerInset = UIEdgeInsets(top: 6, left: 6, bottom: 6, right: 6)
//        return textView
//    }()
//
//    private let introductionTextView: UITextView = {
//        let textView = UITextView()
//        textView.backgroundColor = .systemBackground
//        textView.font = .systemFont(ofSize: 17, weight: UIFont.Weight.regular)
//        textView.layer.borderWidth = 1
//        textView.layer.borderColor = UIColor.placeholderText.cgColor
//        textView.layer.cornerRadius = 8
//        textView.textColor = .placeholderText
//        textView.textContainerInset = UIEdgeInsets(top: 6, left: 6, bottom: 6, right: 6)
//        return textView
//    }()
//
//    private let kindOfPersonTextView: UITextView = {
//        let textView = UITextView()
//        textView.backgroundColor = .systemBackground
//        textView.font = .systemFont(ofSize: 17, weight: UIFont.Weight.regular)
//        textView.layer.borderWidth = 1
//        textView.layer.borderColor = UIColor.placeholderText.cgColor
//        textView.layer.cornerRadius = 8
//        textView.textColor = .placeholderText
//        textView.textContainerInset = UIEdgeInsets(top: 6, left: 6, bottom: 6, right: 6)
//        return textView
//    }()
//
//    private let textCountLabel: UILabel = {
//        let label = UILabel()
//        label.textAlignment = .left
//        label.font = .systemFont(ofSize: 14, weight: UIFont.Weight.regular)
//        label.sizeToFit()
//        label.numberOfLines = 1
//        label.adjustsFontSizeToFitWidth = true
//        return label
//    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(stepHeaderView)
        view.addSubview(contentScrollView)
        loadImagePicker()
        imagesCollectionView.delegate = self
        imagesCollectionView.dataSource = self
        configureViewComponent()
        configureTextView()
        configureHeader()
//        configureDeleteCount()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        stepHeaderView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.leading.right.equalToSuperview()
            make.height.equalTo(70)
        }

        contentScrollView.snp.makeConstraints { make in
            make.top.equalTo(stepHeaderView.snp.bottom)
//            make.width.equalToSuperview()
            make.leading.trailing.bottom.equalToSuperview()
//            make.width.equalToSuperview()
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
//            make.leading.trailing.equalToSuperview()
//            make.top.equalTo(rt)
            make.width.equalToSuperview()
            make.height.equalTo(90)
        }
        headerView[1].snp.makeConstraints {
            $0.top.equalTo(imagesCollectionView.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(10)
            $0.height.equalTo(22)
        }
        textViews[0].snp.makeConstraints { make in
            make.top.equalTo(headerView[1].snp.bottom)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(78)
        }
        headerView[2].snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(10)
            $0.top.equalTo(textViews[0].snp.bottom).offset(20)
            $0.height.equalTo(22)
        }
        textViews[1].snp.makeConstraints { make in
            make.top.equalTo(headerView[2].snp.bottom)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(200)
        }
        headerView[3].snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(10)
            $0.top.equalTo(textViews[1].snp.bottom).offset(20)
            $0.height.equalTo(22)
        }
        textViews[2].snp.makeConstraints { make in
            make.top.equalTo(headerView[3].snp.bottom)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(200)
            make.bottom.equalToSuperview().inset(30)
        }

        
        
        

//        textDetailTableView.frame = view.bounds
        
//        textDetailTableView.snp.makeConstraints { make in
//            make.top.equalTo(imagesCollectionView.snp.bottom).offset(10)
////            make.leading.trailing.bottom.equalToSuperview()
//            make.width.equalToSuperview()
//            make.height.equalTo(650)
//            make.bottom.equalToSuperview()
//        }
//        uploadButton.snp.makeConstraints { make in
//            make.leading.trailing.equalToSuperview().inset(20)
//            make.bottom.equalToSuperview().inset(30)
//            make.height.equalTo(50)
//        }
    }
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        self.view.endEditing(true)
//    }
    
    private func configureViewComponent() {
        self.hideKeyboardWhenTappedAround()
        self.navigationItem.rightBarButtonItem = self.rightButton
        self.stepHeaderView.step = step
        self.stepHeaderView.titleLabel.text = "Content"
        self.view.backgroundColor = .systemBackground
        self.navigationController?.navigationBar.topItem?.backButtonTitle = ""
    }
    
    private func loadImagePicker() {
        DispatchQueue.main.async(qos: .userInteractive) {
            self.imagePicker = UIImagePickerController()
            self.imagePicker?.delegate = self
        }
    }
    
    private func configureTextView() {
//        self.textViews[0].myTextView.text = boardWithMode.boardReq?.title ?? placeholderData[0]
//        self.textViews[1].myTextView.text = boardWithMode.boardReq?.introduction ?? placeholderData[1]
//        self.textViews[2].myTextView.text = boardWithMode.boardReq?.kindOfPerson ?? placeholderData[2]
        self.textViews[0].myTextView.text = boardWithMode.title ?? placeholderData[0]
        self.textViews[1].myTextView.text = boardWithMode.introduction ?? placeholderData[1]
        self.textViews[2].myTextView.text = boardWithMode.kindOfPerson ?? placeholderData[2]
        for i in 0..<3 {
            self.textViews[i].myTextView.delegate = self
            self.textViews[i].myTextView.tag = i
            self.textViews[i].textCountLabel.text = "0 / \(maxChar[i])"
            if boardWithMode.mode == .edit {
                print("edit")
                self.textViewDidChange(textViews[i].myTextView)
                self.textViews[i].myTextView.textColor = UIColor.label
            }
        }
    }
    
    private func configureHeader() {
        self.headerView[0].contentNameLabel.text = "Photos"
        self.headerView[1].contentNameLabel.text = "Title"
        self.headerView[2].contentNameLabel.text = "Gathering introduction"
        self.headerView[3].contentNameLabel.text = "Please apply this kind of person"
    }
    
//    private func textVaildation() -> Bool {
//        guard let imagesCnt = self.boardWithMode.images?.count else { return false }
//        for i in 0..<3 {
//            print("textVaildation")
//            if imagesCnt > 0 && textViewCount[i] >= minChar[i] && textViewCount[i] <= maxChar[i] {
//                print(imagesCnt, textViewCount[i], minChar[i], textViewCount[i], maxChar[i], "true")
//            } else {
//                print(imagesCnt, textViewCount[i], minChar[i], textViewCount[i], maxChar[i], "false")
//                return false
//            }
//        }
//        return true
//    }
    
//    private func hasAllData() -> Bool {
//        if boardWithMode.downloadImages.count + boardWithMode.uploadImages.count == 0 {
//            return false
//        }
//        for i in 0..<3 {
//            if !(textViewCount[i] >= minChar[i] && textViewCount[i] <= maxChar[i]) {
//                print(textViewCount[i], minChar[i], textViewCount[i], maxChar[i], "false")
//                return false
//            } else {
//                print(textViewCount[i], minChar[i], textViewCount[i], maxChar[i], "true")
//            }
//        }
//        return true
//    }
    
    private var hasMssingData: String? {
        if boardWithMode.downloadImages.count + boardWithMode.uploadImages.count == 0 {
            return "photos"
        }
        for i in 0..<3 {
            if !(textViewCount[i] >= minChar[i] && textViewCount[i] <= maxChar[i]) {
                return self.headerView[i+1].contentNameLabel.text?.lowercased()
            }
        }
        return nil
    }
    

    @objc func buttonPressed(_ sender: UIButton) {
//        if !hasAllData() {
//            print("Not has all value")
//            let alert = UIAlertController(title: "Please enter the required information correctly", message: "Please enter the required information according to the condition", preferredStyle: UIAlertController.Style.alert)
//            let okAction = UIAlertAction(title: "OK", style: .default)
//            alert.addAction(okAction)
//            present(alert, animated: false, completion: nil)
//            return
//        }
        
        guard hasMssingData == nil else {
            print("Not has all value")
            let alert = UIAlertController(title: "", message: "Please enter the \(hasMssingData!) according to the condition", preferredStyle: UIAlertController.Style.alert)
            let okAction = UIAlertAction(title: "OK", style: .default)
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
        
        DispatchQueue.main.async {
            ProgressHUD.colorAnimation = ServiceColor.primaryColor
            ProgressHUD.animationType = .circleStrokeSpin
            ProgressHUD.show(interaction: false)
        }
        
        let updateBoard = UpdateBoard(userId: userItem.userId, refreshToken: userItem.refresh_token, boardId: boardWithMode.boardId, hostId: userItem.userId, title: title, address: address, addressDetail: boardWithMode.addressDetail, longitute: longitute, latitude: latitude, date: date, notice: boardWithMode.notice, cityName: cityName, introduction: introduction, kindOfPerson: kindOfPerson, totalMember: totoalMember, categoryId: categoryId, deleteImageIds: boardWithMode.deleteImageIds, images: boardWithMode.uploadImages)

        let urlRequestConvertible: BoardRouter
        if boardWithMode.mode == .edit {
            urlRequestConvertible = BoardRouter.updateBoard(parameters: updateBoard)
        } else {
            urlRequestConvertible = BoardRouter.createBoard(parameters: updateBoard)
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
                            ProgressHUD.dismiss()
                            NotificationCenter.default.post(name: .baordDetailRefresh, object: data) // root가 뭔지 알아야 해당 rootview refresh 가능, 따라서 boardWithMode에 VC 저장
                        }
//                        DispatchQueue.global(qos: .userInitiated).async { [self] in
////                            userImagesData.imageIds = data.userImageIds
////                            userImagesData.downloadImages = data.imageUrls
////                            userImagesData.downloadProfileImage = data.profileImageUrl
//                            DispatchQueue.main.async(qos: .userInteractive, execute: { [self] in
////                                imagesCollectionView.reloadData()
////                                guard let profileImage = userImagesData.downloadProfileImage else { return }
////                                delegate?.imagesSend(profileImage: profileImage)
////                                navigationController?.popViewController(animated: true)
//                                print("Update board반환된 값", data)
//                                NotificationCenter.default.post(name: NSNotification.Name("BoardDetailRefresh"), object: data)
//                                navigationController?.popToRootViewController(animated: true)
//                            })
//                        }
                    }
                case let .failure(error):
                    print("SetProfileImagesVC - upload response result Not return", error)
                    DispatchQueue.main.async {
                        ProgressHUD.dismiss()
                    }
                }
            }
        }

    }
}

//extension GatheringBoardContentViewController: UITableViewDataSource {
//    // Reporting the number of sections and rows in the table.
//
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 3
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        switch section {
//        case 0: return 1
//        case 1: return 1
//        case 2: return 1
//        default: fatalError("GatheringBoardSelectDetailVC out of section")
//        }
//    }
//
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 22
//    }
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        switch indexPath.section {
//        case 0: return 54
//        case 1: return 200
//        case 2: return 200
//        default: fatalError("GatheringBoardContentViewController out of section index")
//        }
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: MyTextViewTableViewCell.identifier, for: indexPath) as? MyTextViewTableViewCell else { return UITableViewCell() }
//        cell.myTextView.tag = indexPath.section
//        cell.myTextView.delegate = self
//        cell.myTextView.text = placeholderData[indexPath.section]
//        switch indexPath.section {
//        case 0: createBoardReq.title = cell.myTextView.text
//        case 1: createBoardReq.introduction = cell.myTextView.text
//        case 2: createBoardReq.kindOfPerson = cell.myTextView.text
//        default: fatalError("Textdetail out of index error")
//        }
//        cell.textCountLabel.text = "0 / \(maxChar[indexPath.section])"
//        cell.selectionStyle = .none
//        return cell
//    }
//
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//
//        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: RequirementTableViewHeader.identifier) as? RequirementTableViewHeader else { return UITableViewHeaderFooterView() }
//
//        // userName, age, lanages, gender, nationality
//        switch section {
//        case 0: headerView.configure(text: "Title")
//        case 1: headerView.configure(text: "Gathering introduction")
//        case 2: headerView.configure(text: "Please apply this kind of person")
//        default: fatalError("Out of header RequirementTableViewHeader section index")
//        }
//        return headerView
//    }
//
//
//}

extension GatheringBoardContentViewController: UICollectionViewDelegate {
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        collectionView.deselectItem(at: indexPath, animated: true)
//        print("Tapped gatherging board collectionview image")
//        guard let images = boardWithMode.images else { return }
//        guard let mode = self.boardWithMode.mode else { return }
//        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
//        let cancel = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
//        if indexPath.row < images.count {
//            let delete = UIAlertAction(title: "Delete", style: .destructive) { (action) in self.deleteImage(indexPath.row, mode: mode)}
//            alert.addAction(delete)
//        } else {
//            guard let imagePicker = self.imagePicker else { return }
//            let library = UIAlertAction(title: "Upload photo", style: .default) { (action) in
//                self.openLibrary(imagePicker) }
//            let camera = UIAlertAction(title: "Take photo", style: .default) { (action) in self.openCamera(imagePicker) }
//            alert.addAction(library)
//            alert.addAction(camera)
//        }
//        alert.view.tintColor = UIColor.label
//        alert.addAction(cancel)
//        self.present(alert, animated: true, completion: nil)
//    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cancel = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
        if indexPath.row < boardWithMode.downloadImages.count + boardWithMode.uploadImages.count {
            let delete = UIAlertAction(title: "Delete", style: .destructive) { (action) in self.deleteImage(indexPath.row)}
            alert.addAction(delete)
            alert.addAction(cancel)
        } else {
            let library = UIAlertAction(title: "Upload photo", style: .default) { (action) in self.openLibrary() }
            let camera = UIAlertAction(title: "Take photo", style: .default) { (action) in self.openCamera() }
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
//        let imagesCnt = boardWithMode.images?.count ?? 0
//        return imagesCnt < 5 ? (imagesCnt + 1) : 5
        
        let imagesCnt = boardWithMode.downloadImages.count + boardWithMode.uploadImages.count
        return imagesCnt < 5 ? (imagesCnt + 1) : 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("ProfileImages indexpath update \(indexPath)")
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier:  MyImagesCollectionViewCell.identifier, for: indexPath) as? MyImagesCollectionViewCell else { return UICollectionViewCell() }
        if indexPath.row < boardWithMode.downloadImages.count {
            cell.configureDownload(imageString: boardWithMode.downloadImages[indexPath.row], sequence: indexPath.row + 1, kind: Kind.boardSelectDetail)
        } else if indexPath.row < boardWithMode.downloadImages.count + boardWithMode.uploadImages.count {
            cell.configureUpload(image: boardWithMode.uploadImages[indexPath.row - boardWithMode.downloadImages.count], sequence: indexPath.row + 1, kind: Kind.boardSelectDetail)
        } else {
            cell.configureNull(image: UIImage(named: "ImageNULL")?.withRenderingMode(.alwaysTemplate), sequence: indexPath.row + 1, kind: Kind.boardSelectDetail)
        }
        return cell
    }
    
    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
////        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyImagesCollectionViewCell.identifier, for: indexPath)
//        print("ProfileImages indexpath update \(indexPath)")
//        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyImagesCollectionViewCell.identifier, for: indexPath) as? MyImagesCollectionViewCell else { return UICollectionViewCell() }
//        
//        //
//        if indexPath.row < self.boardWithMode.images?.count ?? 0 {
////            print("🏞Id", self.boardWithMode.imageIds?[indexPath.row])
//            print("boardWithMode", boardWithMode)
//            print("indexPath.row", indexPath.row)
////            print("🏞Id", self.boardWithMode.images?[indexPath.row]) // 1
//            
//            // imageId 삭제함
//            cell.configure(image: self.boardWithMode.images?[indexPath.row], imageId: self.boardWithMode.imageIds?[indexPath.row], sequence: indexPath.row + 1, kind: Kind.boardSelectDetail)
//        } else {
//            cell.configure(image: UIImage(named: "imageNULL")?.withRenderingMode(.alwaysTemplate), imageId: nil, sequence: indexPath.row + 1, kind: Kind.boardSelectDetail)
//        }
//        return cell
//    }
}

extension GatheringBoardContentViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
//        let size: CGFloat = imagesCollectionView.frame.size.width/2
////        CGSize(width: size, height: size)
//
//        CGSize(width: view.frame.width / 5, height: view.frame.width / 5)
        
        return CGSize(width: collectionView.frame.height - 20, height: collectionView.frame.height - 20)
    }
}

extension GatheringBoardContentViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private func convertAssetsToImages(asstes: [PHAsset]) -> [UIImage] {
        var images = [UIImage]()
        let imageManager = PHImageManager.default()
        let option = PHImageRequestOptions()
//        option.deliveryMode = .fastFormat//.highQualityFormat
//        option.resizeMode = .exact
        option.isSynchronous = true
        option.isNetworkAccessAllowed = true
        // CGSize(width: view.frame.size.width, height: view.frame.size.height)
        let newSize = CGSize(width: view.frame.size.width*2, height: view.frame.size.height*2)
        for i in 0..<asstes.count {

            imageManager.requestImage(for: asstes[i],
                                      targetSize: newSize,
                                      contentMode: .aspectFit,
                                      options: option) { (result, info) in
                if let image = result {
                    images.append(image)
//                    print("image and image size", image, image.size)
//                    print("이미지 크기", image.toFile(format: .jpeg(1.0))!)
//                    let resized = image.resize(targetSize: CGSize(width: self.view.frame.size.width, height: self.view.frame.size.height))
//                    print("resized and resized size", resized, resized.size)
//                    print("이미지 크기", resized.toFile(format: .jpeg(1.0))!)
                }
            }
        }
        return images
    }
    
    private func openLibrary() {
        let imagePicker = ImagePickerController()
        imagePicker.settings.selection.max = 5 - boardWithMode.downloadImages.count - boardWithMode.uploadImages.count
        imagePicker.settings.theme.selectionStyle = .numbered
        imagePicker.settings.fetch.assets.supportedMediaTypes = [.image]
        ImageManager.shared.requestPHPhotoLibraryAuthorization { (Auth) in
            print("Auth", Auth)
            if Auth {
                self.presentImagePicker(imagePicker, select: { (asset) in
                    print("Selected: \(asset)")
                }, deselect: { (asset) in
                    print("Deselected: \(asset)")
                }, cancel: { (assets) in
                    print("Canceled with selections: \(assets)")
                }, finish: { (assets) in
                    print("Finished with selections: \(assets)")
                    let appendImages = self.convertAssetsToImages(asstes: assets)
                    self.boardWithMode.uploadImages.append(contentsOf: appendImages)
                    self.imagesCollectionView.reloadData()
                }, completion: {
                    
                })
            } else {
                DispatchQueue.main.async {
                    self.setAuthAlertAction("Photo")
                }
            }
        }
    }

    private func openCamera() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        DispatchQueue.main.async {
            self.present(imagePicker, animated: true, completion: nil)
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
    
//    func openLibrary(_ picker: UIImagePickerController) {
//        picker.sourceType = .photoLibrary
//        picker.allowsEditing = true
////        if boardWithMode.images?.count ?? 0 == 0 {
////            picker.allowsEditing = true
////        } else {
////            picker.allowsEditing = false
////        }
//        DispatchQueue.main.async {
//            self.present(picker, animated: true, completion: nil)
//        }
//    }
//
//    func openCamera(_ picker: UIImagePickerController) {
//        picker.sourceType = .camera
//        picker.allowsEditing = true
////        if boardWithMode.images?.count ?? 0 == 0 {
////            picker.allowsEditing = true
////        } else {
////            picker.allowsEditing = false
////        }
//        DispatchQueue.main.async {
//            self.present(picker, animated: true, completion: nil)
//        }
//    }

//    func deleteImage(_ index: Int, mode: Mode) {
////        if mode != .edit {
////            self.boardWithMode.images?.remove(at: index)
////            self.imagesCollectionView.reloadData()
////            return
////        }
////        guard let userItem = try? KeychainManager.getUserItem() else { return }
////        guard let boardId = boardWithMode.boardId else { return }
////        guard let cell = imagesCollectionView.cellForItem(at: IndexPath(row: index, section: 0)) as? MyImagesCollectionViewCell else {
////            print("Casting Failed imagesCollectionView.cellForItem ")
////            return
////        }
////        guard let imageId = cell.getImageID() else {
////            print("Get failed imageID of imagesCollectionView cell")
////            return
////        }
////        print("Deleted imageID", imageId)
////        self.deletedImageIds.append(imageId)
////        self.boardWithMode.imageIds?.remove(at: index)
////        self.boardWithMode.images?.remove(at: index)
////        self.newImagesIdx -= 1 // 기존 이미지에 삭제한 개수 카운트
////        self.imagesCollectionView.reloadData()
//
//
//
////        let deleteBoardImageReq = DeleteBoardImageReq(boardId: boardId, boardImageId: imageId, refreshToken: userItem.refresh_token, userId: userItem.userId)
////        AF.request(API.BASE_URL + "boards/boardimage",
////                   method: .patch,
////                   parameters: deleteBoardImageReq,
////                   encoder: JSONParameterEncoder.default) // default set body and Content-Type HTTP header field of an encoded request is set to application/json
////        .validate(statusCode: 200..<500)
////        .response { response in // reponseData
////            switch response.result {
////            case .success:
////                debugPrint(response)
////                if let data = response.data {
////                    do{
////                        self.boardWithMode.images?.remove(at: index)
////                        self.boardWithMode.imageIds?.remove(at: index)
////                        self.newImagesIdx -= 1 // 기존 이미지에 삭제한 개수 카운트
////                        self.imagesCollectionView.reloadData()
////                    }
////                    catch{
////                        print(error.localizedDescription)
////                    }
////                }
////            case .failure(let error):
////                debugPrint(response)
////                print(error)
////            }
////        }
//    }

//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        // action 각기 다르게
////        if let img = info[UIImagePickerController.InfoKey.originalImage] {
////            print("image pick")
////            if let image = img as? UIImage {
////                images.append(image)
////            }
////        }
//
//        DispatchQueue.global(qos: .userInteractive).async {
//            var newImage: UIImage? = nil // update 할 이미지
//
//            if let img = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
//                newImage = img // 수정된 이미지
//                print("수정된 이미지", newImage)
//            }
////            else if let img = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
////                newImage = img // 원본 이미지
////                print("원본 이미지", newImage)
////            }
//            guard let image = newImage else { return }
//            DispatchQueue.main.async(qos: .userInteractive) {
//                let resizeImage = image.resize(targetSize: CGSize(width: self.view.frame.size.width, height: self.view.frame.size.width))
//                print("resize size", resizeImage.size)
//                self.boardWithMode.images?.append(resizeImage)
//                self.boardWithMode.imageIds?.append(-1)
//                self.dismiss(animated: true, completion: nil)
//                self.imagesCollectionView.reloadData()
//            }
//        }
////        var newImage: UIImage? = nil // update 할 이미지
////
////        if let img = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
////            newImage = img // 수정된 이미지
////            print(newImage)
////        } else if let img = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
////            newImage = img // 원본 이미지
////            print(newImage)
////        }
////        guard let image = newImage else { return }
////        let resizeImage = image.resize(targetSize: CGSize(width: view.frame.size.width, height: view.frame.size.width))
////        boardWithMode.images?.append(resizeImage)
////        boardWithMode.imageIds?.append(-1)
////        print("Add 🌅", boardWithMode.images)
////        print("boardWithMode.images?.append", boardWithMode.images)
////        // tabbar notification get 요청
////        DispatchQueue.main.async {
////            self.imagesCollectionView.reloadData()
////            self.dismiss(animated: true, completion: nil)
////        }
//    }
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
        // textfield count
        // 개수 표시
//        let indexPath = IndexPath(row: 0, section: textView.tag)
//        guard let cell = textDetailTableView.cellForRow(at: indexPath) as?  MyTextViewTableViewCell else { return }
        
        print("textViewDidChange", textView.text.count)
        if textView.text.count == 0 {
            textViews[textView.tag].textCountLabel.textColor = .placeholderText
        }
        else if textView.text.count >= minChar[textView.tag] {
            textViews[textView.tag].textCountLabel.textColor = UIColor(rgb: 0x3232FF, alpha: 1.0)
        } else {
            textViews[textView.tag].textCountLabel.textColor = .red
        }
        textViews[textView.tag].textCountLabel.text = "\(textView.text.count) / \(maxChar[textView.tag])"
        textViewCount[textView.tag] = textView.text.count
//        switch textView.tag {
//        case 0: boardWithMode.boardReq?.title = textView.text
//        case 1: boardWithMode.boardReq?.introduction = textView.text
//        case 2: boardWithMode.boardReq?.kindOfPerson = textView.text
//        default: fatalError("Gathering board textview error")
//        }
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


//extension UIViewController {
//    func hideKeyboardWhenTappedAround(tableView: UITableView) {
//        let tap = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard(tableView: tableView)))
//        tap.cancelsTouchesInView = false
//        tableView.addGestureRecognizer(tap)
//    }
//
//    @objc private func dismissKeyboard(tableView: UITableView) {
//        tableView.endEditing(true)
//    }
//}

