//
//  GatheringBoardCategoryViewController.swift
//  Yogit
//
//  Created by Junseo Park on 2022/11/10.
//

import UIKit
import Alamofire

//enum Mode {
//    case post
//    case edit
//}

class GatheringBoardCategoryViewController: UIViewController {

//    var mode: Mode? = .post {
//        didSet {
//            if self.mode == .edit {
//                // get board detail
//                getBoardDetail()
//            }
//        }
//    }
//    // 수정 타입 일때, tapIndex = createBoardReq.categoryId - 1
//    var createBoardReq = CreateBoardReq() {
//        didSet {
////            if createBoardReq.categoryId != nil { tapIndex = nil }
////            else { tapIndex = createBoardReq.categoryId! - 1 }
//            print("Category createBoardReq", createBoardReq)
//            DispatchQueue.main.async {
//                self.categoryTableView.reloadData()
//            }
//        }
//    }
    
//    var boardWithMode = BoardWithMode(boardReq: CreateBoardReq(), boardId: nil, imageIds: [], images: [])
    
    var boardWithMode = BoardWithMode() {
        didSet {
            print("BoardWithMode", boardWithMode)
        }
    }
    
    var categoryId: Int? {
        didSet {
//            if self.touchCount { return }
            DispatchQueue.main.async { [self] in
                categoryTableView.reloadData()
                if categoryId != nil {
                    nextButton.isEnabled = true
                    nextButton.backgroundColor = UIColor(rgb: 0x3232FF, alpha: 1.0)
                } else {
                    nextButton.isEnabled = false
                    nextButton.backgroundColor = .placeholderText
                }
            }
        }
    }
    
//    var touchCount = false
    
//    var imageIds: [Int]?
    
//    var tapIndex: Int? = nil {
//        didSet {
//            print("tapIndex \(tapIndex)")
//            DispatchQueue.main.async {
//                if self.tapIndex != nil {
//                    self.nextButton.isEnabled = true
//                    self.nextButton.backgroundColor = UIColor(rgb: 0x3232FF, alpha: 1.0)
//                } else {
//                    self.nextButton.isEnabled = false
//                    self.nextButton.backgroundColor = .placeholderText
//                }
//            }
//        }
//    }
    
//    var images: [UIImage] = []
    
    private let step = 1.0
    private let categoryText = ["Daily Spot", "Traditional Culture", "Nature", "Language exchange"]
    private let categoryDescription = ["example, example, example", "example, example, example", "example, example, example", "example, example, example"]
    
    private let stepHeaderView = StepHeaderView()
    
    private let categoryTableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.backgroundColor = .systemBackground
        tableView.register(GatheringBoardCategoryTableViewCell.self, forCellReuseIdentifier: GatheringBoardCategoryTableViewCell.identifier)
        return tableView
    }()
    
    private lazy var nextButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(rgb: 0x3232FF, alpha: 1.0)
        button.setTitle("Next", for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 8
        button.isEnabled = false
        button.backgroundColor = .placeholderText
        button.addTarget(self, action: #selector(self.nextButtonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(stepHeaderView)
        view.addSubview(categoryTableView)
        view.addSubview(nextButton)
        categoryTableView.delegate = self
        categoryTableView.dataSource = self
        configureViewComponent()
//        getBoardDetail(mode: boardWithMode.mode) // 원상 복귀 시키자
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        stepHeaderView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.leading.right.equalToSuperview()
            make.height.equalTo(40)
        }
        categoryTableView.snp.makeConstraints { make in
            make.top.equalTo(stepHeaderView.snp.bottom).offset(0)
            make.leading.trailing.bottom.equalToSuperview()
        }
        nextButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(view.snp.bottom).inset(30)
            make.height.equalTo(50)
        }
    }
    
    private func configureViewComponent() {
//        self.navigationItem.title = "Category"
//        self.tabBarController?.tabBar.isHidden = true

        view.backgroundColor = .systemBackground
        stepHeaderView.step = self.step
        stepHeaderView.titleLabel.text = "Category"
    }

    
    @objc func categoryContentViewTapped(sender: UITapGestureRecognizer) {
        // 3 state toggle 값
        self.categoryId == sender.view?.tag ? (self.categoryId = nil) : (self.categoryId = sender.view?.tag)
//        boardWithMode.boardReq?.categoryId == sender.view?.tag ? (boardWithMode.boardReq?.categoryId = nil) : (boardWithMode.boardReq?.categoryId = sender.view?.tag)
//        touchOpCount = 0
        
//        tapIndex == sender.view?.tag ? (tapIndex = nil) : (tapIndex = sender.view?.tag)
//        tapIndex == nil ? (createBoardReq.categoryId = nil) : (createBoardReq.categoryId = tapIndex! + 1)
////        createBoardReq.categoryId = (sender.view?.tag ?? 0) + 1 // nil 아니면 1
//        print("Set category createBoardReq.categoryId \(createBoardReq.categoryId)")
    }
    
    @objc func nextButtonTapped(_ sender: UIButton) {
        guard let apiCategoryId = categoryId else { return }
        DispatchQueue.main.async {
            let GBSDVC = TestBoardViewController() // GatheringBoardOptionViewController()
//            self.touchCount = true
//            guard let apiCategoryId = self.categoryId else { return }
//            self.boardWithMode.boardReq?.categoryId = apiCategoryId + 1
            self.boardWithMode.categoryId = apiCategoryId + 1
            GBSDVC.boardWithMode = self.boardWithMode
            self.navigationController?.pushViewController(GBSDVC, animated: true)
        }
//        DispatchQueue.main.async {
//            let GBSDVC = GatheringBoardOptionViewController()
//            GBSDVC.createBoardReq = self.createBoardReq
//            self.navigationController?.pushViewController(GBSDVC, animated: true)
//        }
    }
    
    func getBoardDetail(mode: Mode?) {

        // api 요청 할 필요없이 ReadGBVC에서 데이터 넘겨주자
        if boardWithMode.mode != .edit {
            print("board Create Mode")
            return
        }
        guard let userItem = try? KeychainManager.getUserItem() else { return }
        guard let boardId = boardWithMode.boardId else {
            print("getBoardDetail - boardId is nil")
            return
        }
        let getBoardDetailReq = GetBoardDetail(boardId: boardId, refreshToken: userItem.refresh_token, userId: userItem.userId)
        AlamofireManager.shared.session
            .request(BoardRouter.readBoardDetail(parameters: getBoardDetailReq))
            .validate(statusCode: 200..<401)
            .responseDecodable(of: APIResponse<BoardDetail>.self) { response in
                switch response.result {
                case .success:
                    guard let value = response.value else { return }
                    if value.httpCode == 200 {
                        guard let data = value.data else { return }
                        DispatchQueue.global(qos: .userInteractive).async { [self] in
                            categoryId = data.categoryId - 1
                            boardWithMode.categoryId = data.categoryId
                            boardWithMode.hostId = data.hostId
                            boardWithMode.title = data.title
                            boardWithMode.address = data.address
                            boardWithMode.addressDetail = data.addressDetail
                            boardWithMode.longitute = data.longitute
                            boardWithMode.latitude = data.latitude
                            boardWithMode.notice = data.notice
                            boardWithMode.date = data.date.stringToDate()?.dateToStringAPI() // ?.dateToString() // 보여줄 데이터
                            boardWithMode.cityName = data.cityName
                            boardWithMode.introduction = data.introduction
                            boardWithMode.kindOfPerson = data.kindOfPerson
                            boardWithMode.totalMember = data.totalMember
                            boardWithMode.boardId = data.boardId
                            boardWithMode.imageIds = data.imageIds
                            boardWithMode.downloadImages = data.imageUrls
                        }
                }
                case let .failure(error):
                    print(error)
                }
            }
        
//        AF.request(API.BASE_URL + "boards/get/detail",
//                   method: .post,
//                   parameters: getBoardDetailReq,
//                   encoder: JSONParameterEncoder.default) // default set body and Content-Type HTTP header field of an encoded request is set to application/json
//        .validate(statusCode: 200..<500)
//        .responseData { response in
//            switch response.result {
//            case .success:
//                debugPrint(response)
//                guard let data = response.value else { return }
//                do{
//                    let decodedData = try JSONDecoder().decode(APIResponse<BoardDetail>.self, from: data)
//                    guard let myData = decodedData.data else { return }
//                    DispatchQueue.global(qos: .userInteractive).async { [self] in
////                        var images: [UIImage] = []
////                        for imageUrl in myData.imageUrls {
////                            imageUrl.urlToImage { (image) in
////                                guard let image = image else {
////                                    print("imageUrls can't read")
////                                    return
////                                }
////                                images.append(image)
////                            }
////                        }
////                        var createBoardReq = CreateBoardReq()
//////                        createBoardReq.categoryId = myData.categoryId - 1
////                        createBoardReq.categoryId = myData.categoryId
////                        self.categoryId = myData.categoryId - 1
////                        createBoardReq.hostId = myData.hostId
////                        createBoardReq.title = myData.title
////                        createBoardReq.address = myData.address
////                        createBoardReq.addressDetail = myData.addressDetail
////                        createBoardReq.longitute = myData.longitute
////                        createBoardReq.latitude = myData.latitude
////                        createBoardReq.notice = myData.notice
////                        createBoardReq.date = myData.date.stringToDate()?.dateToStringAPI() // ?.dateToString() // 보여줄 데이터
////                        createBoardReq.cityName = myData.cityName
////                        createBoardReq.introduction = myData.introduction
////                        createBoardReq.kindOfPerson = myData.kindOfPerson
////                        createBoardReq.totalMember = myData.totalMember
////                        self.boardWithMode.boardReq = createBoardReq
////                        self.boardWithMode.boardId = myData.boardId
////                        self.boardWithMode.imageIds = myData.imageIds
////                        self.boardWithMode.images = images
//
//
////                        boardWithMode.categoryId = myData.categoryId
//                        categoryId = myData.categoryId - 1
//                        boardWithMode.hostId = myData.hostId
//                        boardWithMode.title = myData.title
//                        boardWithMode.address = myData.address
//                        boardWithMode.addressDetail = myData.addressDetail
//                        boardWithMode.longitute = myData.longitute
//                        boardWithMode.latitude = myData.latitude
//                        boardWithMode.notice = myData.notice
//                        boardWithMode.date = myData.date.stringToDate()?.dateToStringAPI() // ?.dateToString() // 보여줄 데이터
//                        boardWithMode.cityName = myData.cityName
//                        boardWithMode.introduction = myData.introduction
//                        boardWithMode.kindOfPerson = myData.kindOfPerson
//                        boardWithMode.totalMember = myData.totalMember
//                        boardWithMode.boardId = myData.boardId
//                        boardWithMode.imageIds = myData.imageIds
//                        boardWithMode.downloadImages = myData.imageUrls
//                    }
//                }
//                catch{
//                    print("catch can't read")
//                    print(error.localizedDescription)
//                }
//            case let .failure(error):
//                print(error)
//            }
//        }
    }
    
//    func getBoardDetail(mode: Mode?) {
//        if mode != .edit {
//            print("board Create Mode")
//            return
//        }
//        guard let userItem = try? KeychainManager.getUserItem() else { return }
//        guard let boardId = boardWithMode.boardId else {
//            print("getBoardDetail - boardId is nil")
//            return
//        }
//        let getBoardDetailReq = GetBoardDetail(boardId: boardId, refreshToken: userItem.refresh_token, userId: userItem.userId)
//        AF.request(API.BASE_URL + "boards/get/detail",
//                   method: .post,
//                   parameters: getBoardDetailReq,
//                   encoder: JSONParameterEncoder.default) // default set body and Content-Type HTTP header field of an encoded request is set to application/json
//        .validate(statusCode: 200..<500)
//        .responseData { response in
//            switch response.result {
//            case .success:
//                debugPrint(response)
//                guard let data = response.value else { return }
//                do{
//                    let decodedData = try JSONDecoder().decode(APIResponse<BoardDetail>.self, from: data)
//                    guard let myData = decodedData.data else { return }
//                    DispatchQueue.global(qos: .userInteractive).async {
//                        var images: [UIImage] = []
//                        for imageUrl in myData.imageUrls {
//                            imageUrl.urlToImage { (image) in
//                                guard let image = image else {
//                                    print("imageUrls can't read")
//                                    return
//                                }
//                                images.append(image)
//                            }
//                        }
//                        var createBoardReq = CreateBoardReq()
////                        createBoardReq.categoryId = myData.categoryId - 1
//                        createBoardReq.categoryId = myData.categoryId
//                        self.categoryId = myData.categoryId - 1
//                        createBoardReq.hostId = myData.hostId
//                        createBoardReq.title = myData.title
//                        createBoardReq.address = myData.address
//                        createBoardReq.addressDetail = myData.addressDetail
//                        createBoardReq.longitute = myData.longitute
//                        createBoardReq.latitude = myData.latitude
//                        createBoardReq.notice = myData.notice
//                        createBoardReq.date = myData.date.stringToDate()?.dateToStringAPI() // ?.dateToString() // 보여줄 데이터
//                        createBoardReq.cityName = myData.cityName
//                        createBoardReq.introduction = myData.introduction
//                        createBoardReq.kindOfPerson = myData.kindOfPerson
//                        createBoardReq.totalMember = myData.totalMember
////                        self.boardWithMode.boardId = myData.boardId
////                        self.boardWithMode.imageIds = myData.imageIds
////                        self.boardWithMode.images = images
////                        self.tapIndex = myData.categoryId - 1
////                        self.boardWithMode = BoardWithMode(boardReq: createBoardReq, boardId: myData.boardId, imageIds: myData.imageIds, images: images)
//                        self.boardWithMode.boardReq = createBoardReq
//                        self.boardWithMode.boardId = myData.boardId
//                        self.boardWithMode.imageIds = myData.imageIds
//                        self.boardWithMode.images = images
//                    }
//                }
//                catch{
//                    print("catch can't read")
//                    print(error.localizedDescription)
//                }
//            case let .failure(error):
//                print(error)
//            }
//        }
//    }
    
    // MARK: - Table view data source object
    
    // Providing cells for each row of the table.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: GatheringBoardCategoryTableViewCell.identifier, for: indexPath) as? GatheringBoardCategoryTableViewCell else { return UITableViewCell() }
        cell.categoryImageView.image = UIImage(named: categoryText[indexPath.row])?.withRenderingMode(.alwaysTemplate)
        cell.categoryTitleLabel.text = categoryText[indexPath.row]
        cell.categoryDescriptionLabel.text = categoryDescription[indexPath.row]
        cell.categoryContentView.tag = indexPath.row
        cell.categoryContentView.removeGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.categoryContentViewTapped(sender:))))
        cell.categoryContentView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.categoryContentViewTapped(sender:))))
        
        // 기존 탭한 값 있으면 istapped false로 바꿈
//        tapIndex == indexPath.row ? (cell.isTapped = true) : (cell.isTapped = false) // 현재
        
//        if tapIndex == nil {
//            cell.isTapped = nil
//        } else if tapIndex == indexPath.row {
//            cell.isTapped = true
//        } else {
//            cell.isTapped = false
//        }
//
//        if boardWithMode.boardReq?.categoryId == nil {
//            cell.isTapped = nil
//        } else if boardWithMode.boardReq?.categoryId == indexPath.row {
//            cell.isTapped = true
//        } else {
//            cell.isTapped = false
//        }
        if categoryId == nil {
            cell.isTapped = nil
        } else if categoryId == indexPath.row {
            cell.isTapped = true
        } else {
            cell.isTapped = false
        }
        
        cell.selectionStyle = .none
        return cell
    }
}

extension GatheringBoardCategoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//
//        let headerView = StepHeaderView()
//        headerView.step = self.step
//        headerView.titleLabel.text = "Category"
////        headerView.layoutIfNeeded()
//
//        return headerView
//    }
}

extension GatheringBoardCategoryViewController: UITableViewDataSource {
    // Reporting the number of sections and rows in the table.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryText.count
    }
}
