//
//  GatheringTextDetailViewController.swift
//  Yogit
//
//  Created by Junseo Park on 2022/11/12.
//

import UIKit
import Alamofire
import SnapKit

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
    
    var boardWithMode = BoardWithMode(boardReq: CreateBoardReq(), boardId: nil, imageIds: [], images: []) {
        didSet {
            print("boardWithMode 3 \(boardWithMode)")
//            newImagesLastIdx = boardWithMode.images?.count ?? 0
        }
    }
    private var deletedImageIds: [Int64] = []
    private var newImagesIdx: Int = 0 // 기존 이미지 개수 저장, 삭제한 이미지 개수저장 >> 기존이미지(3개) - 삭제한 이미지(2개) >> post(patch) req: 1번 인덱스 부터 끝지점
    
//    private var imagePicker: UIImagePickerController?
    
    private let rtvh = RequirementTableViewHeader()
    let stepHeaderView = StepHeaderView()
    let step = 3.0
    var headerView: [MyHeaderView] = [MyHeaderView(), MyHeaderView(), MyHeaderView()]
    var textViews = [MyTextView(), MyTextView(), MyTextView()]
    let placeholderData = ["Ex) Hangout", "Ex) Hangout", "Ex) Hangout"]
    var textViewCount = [0, 0, 0]
    let minChar = [10, 50, 50]
    let maxChar = [30, 500, 500]
    
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
        [self.rtvh,
         self.imagesCollectionView,
         self.headerView[0],
         self.textViews[0],
         self.headerView[1],
         self.textViews[1],
         self.headerView[2],
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
        imagesCollectionView.delegate = self
        imagesCollectionView.dataSource = self
        configureViewComponent()
        configureTextView()
        configureHeader()
        configureDeleteCount()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        stepHeaderView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(10)
//            make.leading.trailing.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(30)
        }

        contentScrollView.snp.makeConstraints { make in
            make.top.equalTo(stepHeaderView.snp.bottom).offset(10)
//            make.width.equalToSuperview()
            make.leading.trailing.bottom.equalToSuperview()
//            make.width.equalToSuperview()
        }

        contentView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.width.equalToSuperview()
            $0.centerX.bottom.equalToSuperview()
        }

        rtvh.snp.makeConstraints { make in
//            make.top.equalTo(stepHeaderView.snp.bottom).offset(20)
            make.top.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(22)
        }


        imagesCollectionView.snp.makeConstraints { make in
            make.top.equalTo(rtvh.snp.bottom)
//            make.leading.trailing.equalToSuperview()
//            make.top.equalTo(rt)
            make.width.equalToSuperview()
            make.height.equalTo(90)
        }
        headerView[0].snp.makeConstraints {
            $0.top.equalTo(imagesCollectionView.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(10)
            $0.height.equalTo(22)
        }
        textViews[0].snp.makeConstraints { make in
            make.top.equalTo(headerView[0].snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(54)
        }
        headerView[1].snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(10)
            $0.top.equalTo(textViews[0].snp.bottom).offset(20)
            $0.height.equalTo(22)
        }
        textViews[1].snp.makeConstraints { make in
            make.top.equalTo(headerView[1].snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(200)
        }
        headerView[2].snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(10)
            $0.top.equalTo(textViews[1].snp.bottom).offset(20)
            $0.height.equalTo(22)
        }
        textViews[2].snp.makeConstraints { make in
            make.top.equalTo(headerView[2].snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview()
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
    
    private func configureViewComponent() {
//        self.navigationItem.title = "Profile"
        self.hideKeyboardWhenTappedAround()
        self.navigationItem.rightBarButtonItem = self.rightButton
        self.stepHeaderView.step = step
        self.stepHeaderView.titleLabel.text = "Content"
        self.view.backgroundColor = .systemBackground
        self.rtvh.contentNameLabel.text = "Photos"
    }
    
    private func configureTextView() {
        self.textViews[0].myTextView.text = boardWithMode.boardReq?.title ?? placeholderData[0]
        self.textViews[1].myTextView.text = boardWithMode.boardReq?.introduction ?? placeholderData[1]
        self.textViews[2].myTextView.text = boardWithMode.boardReq?.kindOfPerson ?? placeholderData[2]
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
        self.headerView[0].contentNameLabel.text = "Title"
        self.headerView[1].contentNameLabel.text = "Gathering introduction"
        self.headerView[2].contentNameLabel.text = "Please apply this kind of person"
    }
    
    private func configureDeleteCount() {
        self.newImagesIdx = self.boardWithMode.images?.count ?? 0 // 기존 이미지 개수
    }
    
    private func textVaildation() -> Bool {
        guard let imagesCnt = self.boardWithMode.images?.count else { return false }
        for i in 0..<3 {
            print("textVaildation")
            if imagesCnt > 0 && textViewCount[i] >= minChar[i] && textViewCount[i] <= maxChar[i] {
                print(imagesCnt, textViewCount[i], minChar[i], textViewCount[i], maxChar[i], "true")
            } else {
                print(imagesCnt, textViewCount[i], minChar[i], textViewCount[i], maxChar[i], "false")
                return false
            }
        }
        return true
    }
    
//    func viewGetValues() {
//        print("viewGetValues",createBoardReq)
//        textViews[0].myTextView.text = createBoardReq.title
//        textViews[1].myTextView.text = createBoardReq.introduction
//        textViews[2].myTextView.text = createBoardReq.kindOfPerson
//        for i in 0..<3 {
//            textViewDidChange(textViews[i].myTextView)
//        }
//    }

    @objc func buttonPressed(_ sender: UIButton) {
        
        if textVaildation() {
            // 통신완료 후 pop root까지
            guard let userItem = try? KeychainManager.getUserItem() else { return }
            boardWithMode.boardReq?.hostId = userItem.userId  // 아이디 받으면 아이디로
            boardWithMode.boardReq?.refreshToken = userItem.refresh_token
        
//            let parameters: [String: Any] = [
//                "cityName": createBoardReq.cityName!,
//                "hostId": createBoardReq.hostId!,
//                "title": createBoardReq.title!,
//                "address": createBoardReq.address!,
//                "addressDetail": createBoardReq.addressDetail ?? "",
//                "longitute": createBoardReq.longitute!,
//                "latitude": createBoardReq.latitude!,
//                "date": createBoardReq.date!,
//                "notice": "",
//                "introduction": createBoardReq.introduction!,
//                "kindOfPerson": createBoardReq.kindOfPerson!,
//                "totalMember": createBoardReq.totalMember!,
//                "categoryId": createBoardReq.categoryId!,
//                "refreshToken": userItem.refresh_token
//            ]
            guard let parameters = boardWithMode.boardReq?.toDictionary else { return }
            guard let images = boardWithMode.images else { return }
            if boardWithMode.mode == .edit {
                print("edit", parameters)
                // 삭제한 받아온 imageIds, 추가한 이미지 imageIds = -1
                guard let boardId = boardWithMode.boardId else { return }
//                guard let imageIds = boardWithMode.imageIds else { return }
                AF.upload(multipartFormData: { multipartFormData in
                    multipartFormData.append(Data("\(boardId)".utf8), withName: "boardId")
                    for (key, value) in parameters {
                        multipartFormData.append(Data("\(value)".utf8), withName: key)
                    }
                    for i in self.newImagesIdx..<images.count {
                        multipartFormData.append(images[i].toFile(format: .jpeg(0.5))!, withName: "images", fileName: "images.jpeg", mimeType: "images/jpeg")
                    }
//                    multipartFormData.append(Data("\(deletedIdsParam.values)".utf8), withName: deletedIdsParam.keys)
                    if self.deletedImageIds != [] {
                        let deletedIdsParam: [String: [Any]] = ["deleteImageIds": self.deletedImageIds]
                        print(deletedIdsParam)
                        for (key, value) in deletedIdsParam {
                            multipartFormData.append(Data("\(value)".utf8), withName: key)
                        }
                    }
                }, to: API.BASE_URL + "boards", method: .patch) // post
                .validate(statusCode: 200..<500)
                .responseData { response in
                    switch response.result {
                    case .success:
                        debugPrint(response)
                        DispatchQueue.main.async {
                            self.navigationController?.popToRootViewController(animated: true)
                            // notification 메인게시글 페이지로 쏴줌 >>  get 요청해서 업데이트
                        }
                    case let .failure(error):
                        print(error)
                    }
                }
            }
            else {
                print("post Board", parameters)
                print("post image", images)
                AF.upload(multipartFormData: { multipartFormData in
                    for (key, value) in parameters {
                        multipartFormData.append(Data("\(value)".utf8), withName: key)
                    }
                    for i in self.newImagesIdx..<images.count {
                        multipartFormData.append(images[i].toFile(format: .jpeg(0.5))!, withName: "images", fileName: "images.jpeg", mimeType: "images/jpeg")
                    }
                    print(multipartFormData)
                }, to: API.BASE_URL + "boards", method: .post) // post
                .validate(statusCode: 200..<500)
                .responseData { response in
                    switch response.result {
                    case .success:
                        debugPrint(response)
                        DispatchQueue.main.async {
                            self.navigationController?.popToRootViewController(animated: true)
                            // notification 메인게시글 페이지로 쏴줌 >>  get 요청해서 업데이트
                        }
                    case let .failure(error):
                        print(error)
                    }
                }
            }
            
        } else {
            print("Not has all value")
            let alert = UIAlertController(title: "Please enter the required information correctly", message: "Please enter the required information according to the condition", preferredStyle: UIAlertController.Style.alert)
            let okAction = UIAlertAction(title: "OK", style: .default)
            alert.addAction(okAction)
            present(alert, animated: false, completion: nil)
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
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        print("Tapped gatherging board collectionview image")
        guard let images = boardWithMode.images else { return }
        guard let mode = self.boardWithMode.mode else { return }
        DispatchQueue.main.async {
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            let cancel = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
            if indexPath.row < images.count {
                let delete = UIAlertAction(title: "Delete", style: .destructive) { (action) in self.deleteImage(indexPath.row, mode: mode)}
                alert.addAction(delete)
            } else {
                let imgPicker = UIImagePickerController()
                imgPicker.delegate = self
                let library = UIAlertAction(title: "Upload photo", style: .default) { (action) in
                    self.openLibrary(imgPicker)}
                let camera = UIAlertAction(title: "Take photo", style: .default) { (action) in self.openCamera(imgPicker)}
                alert.addAction(library)
                alert.addAction(camera)
            }
            alert.view.tintColor = UIColor.label
            alert.addAction(cancel)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
}

extension GatheringBoardContentViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return 10
        let imagesCnt = boardWithMode.images?.count ?? 0
        return imagesCnt < 5 ? (imagesCnt + 1) : 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyImagesCollectionViewCell.identifier, for: indexPath)
        print("ProfileImages indexpath update \(indexPath)")
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyImagesCollectionViewCell.identifier, for: indexPath) as? MyImagesCollectionViewCell else { return UICollectionViewCell() }
        if indexPath.row < self.boardWithMode.images?.count ?? 0 {
//            print("🏞Id", self.boardWithMode.imageIds?[indexPath.row])
            print("boardWithMode", boardWithMode)
            print("indexPath.row", indexPath.row)
//            print("🏞Id", self.boardWithMode.images?[indexPath.row]) // 1
            cell.configure(image: self.boardWithMode.images?[indexPath.row], imageId: self.boardWithMode.imageIds?[indexPath.row], sequence: indexPath.row + 1, kind: Kind.boardSelectDetail)
        } else {
            cell.configure(image: UIImage(named: "imageNULL")?.withRenderingMode(.alwaysTemplate), imageId: nil, sequence: indexPath.row + 1, kind: Kind.boardSelectDetail)
        }
        return cell
    }
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
    func openLibrary(_ picker: UIImagePickerController) {
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
//        if boardWithMode.images?.count ?? 0 == 0 {
//            picker.allowsEditing = true
//        } else {
//            picker.allowsEditing = false
//        }
        DispatchQueue.main.async {
            self.present(picker, animated: true, completion: nil)
        }
    }

    func openCamera(_ picker: UIImagePickerController) {
        picker.sourceType = .camera
        picker.allowsEditing = true
//        if boardWithMode.images?.count ?? 0 == 0 {
//            picker.allowsEditing = true
//        } else {
//            picker.allowsEditing = false
//        }
        DispatchQueue.main.async {
            self.present(picker, animated: true, completion: nil)
        }
    }

    func deleteImage(_ index: Int, mode: Mode) {
        if mode != .edit {
            self.boardWithMode.images?.remove(at: index)
            self.imagesCollectionView.reloadData()
            return
        }
        guard let userItem = try? KeychainManager.getUserItem() else { return }
        guard let boardId = boardWithMode.boardId else { return }
        guard let cell = imagesCollectionView.cellForItem(at: IndexPath(row: index, section: 0)) as? MyImagesCollectionViewCell else {
            print("Casting Failed imagesCollectionView.cellForItem ")
            return
        }
        guard let imageId = cell.getImageID() else {
            print("Get failed imageID of imagesCollectionView cell")
            return
        }
        print("Deleted imageID", imageId)
        self.deletedImageIds.append(imageId)
        self.boardWithMode.imageIds?.remove(at: index)
        self.boardWithMode.images?.remove(at: index)
        self.newImagesIdx -= 1 // 기존 이미지에 삭제한 개수 카운트
        self.imagesCollectionView.reloadData()
//        let deleteBoardImageReq = DeleteBoardImageReq(boardId: boardId, boardImageId: imageId, refreshToken: userItem.refresh_token, userId: userItem.userId)
//        AF.request(API.BASE_URL + "boards/boardimage",
//                   method: .patch,
//                   parameters: deleteBoardImageReq,
//                   encoder: JSONParameterEncoder.default) // default set body and Content-Type HTTP header field of an encoded request is set to application/json
//        .validate(statusCode: 200..<500)
//        .response { response in // reponseData
//            switch response.result {
//            case .success:
//                debugPrint(response)
//                if let data = response.data {
//                    do{
//                        self.boardWithMode.images?.remove(at: index)
//                        self.boardWithMode.imageIds?.remove(at: index)
//                        self.newImagesIdx -= 1 // 기존 이미지에 삭제한 개수 카운트
//                        self.imagesCollectionView.reloadData()
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
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // action 각기 다르게
//        if let img = info[UIImagePickerController.InfoKey.originalImage] {
//            print("image pick")
//            if let image = img as? UIImage {
//                images.append(image)
//            }
//        }
        
        DispatchQueue.global(qos: .userInteractive).async {
            var newImage: UIImage? = nil // update 할 이미지

            if let img = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
                newImage = img // 수정된 이미지
                print("수정된 이미지", newImage)
            }
//            else if let img = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
//                newImage = img // 원본 이미지
//                print("원본 이미지", newImage)
//            }
            guard let image = newImage else { return }
            DispatchQueue.main.async(qos: .userInteractive) {
                let resizeImage = image.resize(targetSize: CGSize(width: self.view.frame.size.width, height: self.view.frame.size.width))
                print("resize size", resizeImage.size)
                self.boardWithMode.images?.append(resizeImage)
                self.boardWithMode.imageIds?.append(-1)
                self.dismiss(animated: true, completion: nil)
                self.imagesCollectionView.reloadData()
            }
        }
//        var newImage: UIImage? = nil // update 할 이미지
//
//        if let img = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
//            newImage = img // 수정된 이미지
//            print(newImage)
//        } else if let img = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
//            newImage = img // 원본 이미지
//            print(newImage)
//        }
//        guard let image = newImage else { return }
//        let resizeImage = image.resize(targetSize: CGSize(width: view.frame.size.width, height: view.frame.size.width))
//        boardWithMode.images?.append(resizeImage)
//        boardWithMode.imageIds?.append(-1)
//        print("Add 🌅", boardWithMode.images)
//        print("boardWithMode.images?.append", boardWithMode.images)
//        // tabbar notification get 요청
//        DispatchQueue.main.async {
//            self.imagesCollectionView.reloadData()
//            self.dismiss(animated: true, completion: nil)
//        }
    }
}


extension GatheringBoardContentViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        print(" shouldChangeTextIn",textView.tag)
        if textView.tag == 0 && text == "\n" { textView.resignFirstResponder() }
        
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
            textView.textColor = .black
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
        switch textView.tag {
        case 0: boardWithMode.boardReq?.title = textView.text
        case 1: boardWithMode.boardReq?.introduction = textView.text
        case 2: boardWithMode.boardReq?.kindOfPerson = textView.text
        default: fatalError("Gathering board textview error")
        }
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}

