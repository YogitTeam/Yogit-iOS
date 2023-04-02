////
////  ViewAllGatheringBoardsViewController.swift
////  Yogit
////
////  Created by Junseo Park on 2023/02/06.
////
//
//import UIKit
//import SnapKit
//// 테이블뷰 헤더 콜렉션뷰 카테고리
//// 각 카테고리마다 페이지네이션 필요
//class ViewAllGatheringBoardsViewController: UIViewController {
////    let categories: [Int] = [0,1,2,3,4,5]
//    
//    // 전체 카테고리 페이지
//    // 카테고리별 페이지
//    
//    // 페이지네이션: 각 페이지마다 끝점 전체 카테고리 페이지 페이지 네이션 >> 카테고리별로 필터링
////    private let categoryImages: [UIImage] = [UIImage(named: "Language exchange")!,UIImage(named: "Language exchange")!,UIImage(named: "Language exchange")!, UIImage(named: "Language exchange")!,UIImage(named: "Language exchange")!]
//    private var gatheringBoards = [[Board]]()
//    private lazy var pagesCursor = [Int](repeating: 0, count: CategoryId.allCases.count)
//    private lazy var pagesListCount = [Int](repeating: 0, count: CategoryId.allCases.count)
//    private var isPaging: Bool = false
//    private var categoryId = 1 {
//        didSet {
////            DispatchQueue.main.async(qos: .background, execute: { [self] in
////                categoryImageViewCollectionView.reloadData()
////            })
//        }
//    }
//    var cellHeights: [IndexPath: CGFloat] = [:]
//    var selectedCell: CategoryImageViewCollectionViewCell? {
//        didSet {
//            selectedCell?.imageView.tintColor = ServiceColor.primaryColor//.label//UIColor(rgb: 0x3232FF, alpha: 1.0) //.white // .white
//            selectedCell?.titleLabel.textColor = ServiceColor.primaryColor //.label//UIColor(rgb: 0x3232FF, alpha: 1.0)
//            selectedCell?.backView.backgroundColor = .systemGray6//UIColor(rgb: 0xEFEFEF, alpha: 1.0) // .withAlphaComponent(0.8)
//            selectedCell?.backView.layer.borderWidth = 1
//            selectedCell?.backView.layer.borderColor = ServiceColor.primaryColor.cgColor// UIColor.systemGray4.cgColor//UIColor(rgb:
//        }
//    }
//    private lazy var gatheringBoardTableView: UITableView = {
//        let tableView = UITableView()
////        tableView.separatorStyle = .none
//        tableView.translatesAutoresizingMaskIntoConstraints = false
//        tableView.backgroundColor = .systemBackground
////        tableView.tableHeaderView = categoryImageViewCollectionView
//        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 124)
////        tableView.estimatedRowHeight = 120
//        // register new cell
//        // self: reference the type object
//        tableView.register(SmallGatheringBoardTableViewCell.self, forCellReuseIdentifier: SmallGatheringBoardTableViewCell.identifier)
//        return tableView
//    }()
//    
//    // category view
//    private lazy var categoryImageViewCollectionView: UICollectionView = {
//        let layout = UICollectionViewFlowLayout()
//        layout.scrollDirection = .horizontal
//        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
//        layout.estimatedItemSize = CGSize(width: 100, height: 100)
//        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
//        collectionView.translatesAutoresizingMaskIntoConstraints = false
//        collectionView.register(CategoryImageViewCollectionViewCell.self, forCellWithReuseIdentifier: CategoryImageViewCollectionViewCell.identifier)
//        collectionView.layer.borderColor = UIColor.red.cgColor
////        collectionView.layer.borderWidth = 0.3
////        collectionView.backgroundColor = .systemBackground
//        collectionView.showsHorizontalScrollIndicator = false
////        collectionView.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: 100)// CGRect(origin: .zero, size: CGSize(width: view.frame.size.width, height: 100))
//        return collectionView
//    }()
//    
//    private let lineView: UIView = {
//        let view = UIView()
//        view.translatesAutoresizingMaskIntoConstraints = false
//        view.backgroundColor = .systemGray3
//        return view
//    }()
//    
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
////        let board = [Board]()
////        gatheringBoards[0].append(contentsOf: board)
//        initBoardsData()
//        gatheringBoardTableView.tag = 1
//        gatheringBoardTableView.delegate = self
//        gatheringBoardTableView.dataSource = self
//        categoryImageViewCollectionView.delegate = self
//        categoryImageViewCollectionView.dataSource = self
////        categoryImageViewCollectionView.reloadData()
////        let indexPath = IndexPath(item: 0, section: 0)
////        categoryImageViewCollectionView.deselectItem(at: indexPath, animated: true) //selectItem(at: indexPath, animated: true, scrollPosition: .centeredVertically)
//        getBoardByCategory(categoryId: categoryId, isPaging: isPaging)
//        configureViewComponent()
//        // Do any additional setup after loading the view.
//    }
//    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        gatheringBoardTableView.frame = view.bounds
////        gatheringBoardTableView.tableHeaderView?.frame.size = categoryImageViewCollectionView.frame.size
//        gatheringBoardTableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: gatheringBoardTableView.bounds.size.width, height: 100.2))
//        gatheringBoardTableView.tableHeaderView?.addSubview(categoryImageViewCollectionView)
//        gatheringBoardTableView.tableHeaderView?.addSubview(lineView)
//        categoryImageViewCollectionView.snp.makeConstraints {
//            $0.top.leading.trailing.equalToSuperview()
//            $0.height.equalTo(100)
//        }
//        lineView.snp.makeConstraints {
//            $0.bottom.leading.trailing.equalToSuperview()
//            $0.height.equalTo(0.2)
//        }
//    }
//    override func viewDidAppear(_ animated: Bool) {
//        let indexPath = IndexPath(item: 0, section: 0)
//        guard let cell = categoryImageViewCollectionView.cellForItem(at: indexPath) as? CategoryImageViewCollectionViewCell else { return }
//        selectedCell = cell
//    }
//
//    private func initBoardsData() {
//        for _ in 0..<CategoryId.allCases.count {
//            gatheringBoards.append([])
//        }
//    }
//    
//    private func configureViewComponent() {
//        view.addSubview(gatheringBoardTableView)
//        view.addSubview(lineView)
//        view.backgroundColor = .systemBackground
//    }
//    
//    private func getBoardByCategory(categoryId: Int, isPaging: Bool) {
//        if isPaging {
//            return
//        } else {
//            self.isPaging = true
//        }
//        guard let userItem = try? KeychainManager.getUserItem() else { return }
//        pagesCursor[categoryId-1] = 0
//        let getAllBoardsByCategoryReq = GetAllBoardsByCategoryReq(categoryId: categoryId, cursor: pagesCursor[categoryId-1], refreshToken: userItem.refresh_token, userId: userItem.userId)
//        AlamofireManager.shared.session
//            .request(BoardRouter.readCategoryBoards(parameters: getAllBoardsByCategoryReq))
//            .validate(statusCode: 200..<501)
//            .responseDecodable(of: APIResponse<[Board]>.self) { response in
//                switch response.result {
//                case .success:
//                    guard let value = response.value else { return }
//                    if value.httpCode == 200 {
//                        guard let datas = value.data else { return }
//                        DispatchQueue.global().async(qos: .userInteractive, execute: { [self] in
//                            
//                            gatheringBoards[categoryId-1].append(contentsOf: datas)
////                            gatheringBoards[categoryId-1] = data // 데이터 추가 해댜함
//                            DispatchQueue.main.async(qos: .userInteractive, execute: { [self] in
//                                gatheringBoardTableView.reloadData()
//                            })
//                            pagesListCount[categoryId-1] = datas.count%10 // 0
//                            if pagesListCount[categoryId-1] == 0 {
//                                pagesCursor[categoryId-1] += 1
//                            }
//                            self.isPaging = false
//                        })
//                        
////                        for board in boards {
////                            gatheringBoards[categoryId].append(board)
////                            DispatchQueue.main.async(qos: .userInteractive, execute: { [self] in
////                                gatheringBoardTableView.insertSections([gatheringBoards.count - 1], with: .bottom)
////                            })
////                        }
//                    }
//                case let .failure(error):
//                    self.isPaging = false
//                    print(error)
//                }
//            }
//    }
//    
//    
//    func fetchGatheringBoardsByCategory(page: Int) async -> [Board]? {
//        guard let userItem = try? KeychainManager.getUserItem() else { return nil }
//        let getBoardsByCategoryReq = GetBoardsByCategoryReq(categoryId: categoryId, cursor: pagesCursor[categoryId-1], refreshToken: userItem.refresh_token, userId: userItem.userId)
//        let dataTask = AlamofireManager.shared.session.request(BoardRouter.readCategoryBoards(parameters: getBoardsByCategoryReq)).validate(statusCode: 200..<501).serializingDecodable(APIResponse<[Board]>.self)
//        let response = await dataTask.response
//        let value = response.value
//        return value?.data
//    }
//    
//    private func pagingBoardsByCategory(categoryId: Int, isPaging: Bool) {
//        if isPaging { return }
//        else { self.isPaging = true }
//        guard let userItem = try? KeychainManager.getUserItem() else { return }
////        let getAllBoardsByCategoryReq = GetAllBoardsByCategoryReq(categoryId: categoryId, cursor: pagesCursor[categoryId-1], refreshToken: userItem.refresh_token, userId: userItem.userId)
//        AlamofireManager.shared.session
//            .request(BoardRouter.readCategoryBoards(parameters: getAllBoardsByCategoryReq))
//            .validate(statusCode: 200..<501)
//            .responseDecodable(of: APIResponse<[Board]>.self) { response in
//                switch response.result {
//                case .success:
//                    guard let value = response.value else { return }
//                    if value.httpCode == 200 {
//                        guard let datas = value.data else { return }
//                        DispatchQueue.global().async(qos: .userInteractive, execute: { [self] in
//                            
////                            gatheringBoards[categoryId-1].append(contentsOf: data)
////                            let boards = datas
//                            for data in datas {
//                                gatheringBoards[categoryId-1].append(data)
//                                DispatchQueue.main.async(qos: .userInteractive, execute: { [self] in
//                                    gatheringBoardTableView.insertRows(at: [IndexPath(row: gatheringBoards.count-1, section: 0)], with: .bottom)
////                                    gatheringBoardTableView.reloadRows(at: <#T##[IndexPath]#>, with: <#T##UITableView.RowAnimation#>)
////                                    gatheringBoardTableView.insertRows(at: , with: .bottom)
////                                    gatheringBoardTableView.insertSections([gatheringBoards.count-1], with: .bottom)
//                                })
//                            }
//                            
//                            pagesListCount[categoryId-1] = datas.count%10 // 0
//                            if pagesListCount[categoryId-1] == 0 {
//                                pagesCursor[categoryId-1] += 1
//                            }
//                            self.isPaging = false
////                            gatheringBoards[categoryId-1] = data // 데이터 추가 해댜함
////                            DispatchQueue.main.async(qos: .userInteractive, execute: { [self] in
////                                gatheringBoardTableView.reloadData()
////                            })
//                        })
//                        
////                        for board in boards {
////                            gatheringBoards[categoryId].append(board)
////                            DispatchQueue.main.async(qos: .userInteractive, execute: { [self] in
////                                gatheringBoardTableView.insertSections([gatheringBoards.count - 1], with: .bottom)
////                            })
////                        }
//                    }
//                case let .failure(error):
//                    self.isPaging = false
//                    print(error)
//                }
//        }
//        
////        func loadClipBoardBottom() async {
////            if isPaging { return }
////            else { isPaging = true }
////            isLoading = true
////            await MainActor.run {
////                messagesCollectionView.reloadSections([messages.count-1]) // 로딩뷰 실행
////            }
////            sleep(UInt32(0.7))
////            let getData = await fetchClipBoardData(page: upPageCusor)
////            guard let totalPage = getData?.totalPage else { return }
////            print("삽입 전upPageCursor, totalPage", upPageCusor, totalPage)
////            isLoading = false
////            if upPageCusor < totalPage { // 현재페이지 토탈페이지-1 이고 개수 10보다 작으면 막아야함
////                print("삽입 할 upPageCursor, totalPage", upPageCusor, totalPage)
////                guard let clipBoardList = getData?.getClipBoardResList else { return }
////                let clipBoardListCount = clipBoardList.count
////                guard let userItem = try? KeychainManager.getUserItem() else { return }
////                for i in upPageListCount..<clipBoardListCount { // 8
////                    print("upPageListCount, clipBoardListCount", upPageListCount, clipBoardListCount)
////                    let sender = Sender(senderId: "\(clipBoardList[i].userID)", displayName:  clipBoardList[i].userName)
////                    if avatarImages[sender.senderId] == nil {
////                        let profileImage = clipBoardList[i].profileImgURL.loadImageAsync()
////                        self.avatarImages[sender.senderId] = profileImage
////    //                    clipBoardList[i].profileImgURL.loadImage { (image) in
////    //                        guard let image = image else {
////    //                            print("Error loading image")
////    //                            return
////    //                        }
////    //                        self.avatarImages[sender.senderId] = image
////    //                    }
////    //                    let profileImage = await clipBoardList[i].profileImgURL.urlToImage()
////    //                    avatarImages[sender.senderId] = profileImage
////                    }
////    //                if userItem.userId == clipBoardList[i].userID {
////    //                    currentUser.senderId = "\(clipBoardList[i].userID)"
////    //                    currentUser.displayName = clipBoardList[i].userName
////    //                }
////                    guard let sendDate = clipBoardList[i].createdAt.stringToDate() else { return }
////                    let message = Message(sender: sender, messageId: "\(clipBoardList[i].clipBoardID)", sentDate: sendDate, kind: .text(clipBoardList[i].content))
////                    if i == upPageListCount {
////                        insertFirst(message)
////                    } else {
////                        insertMessage(message)
////                    }
////                }
////                if upPageListCount < clipBoardListCount {
////                    let serviceMessage = Message(sender: service, messageId: "\(upPageCusor*10+upPageListCount)", sentDate: Date(), kind: .text("📢 This is not realtime chatting\n      Please need scroll"))
////                    await MainActor.run {
////                        insertMessage(serviceMessage)
////                        messagesCollectionView.scrollToLastItem()
////                    }
////                }
////                upPageListCount = clipBoardListCount%10 // 0
////                if upPageListCount == 0 {
////                    upPageCusor += 1
////                }
////    //                upPageListCount = clipBoardListCount
////    //                if upPageListCount == 10 {
////    //                    upPageListCount = clipBoardListCount%10
////    //                    upPageCusor += 1
////    //                }
////            }
////            await MainActor.run {
////                messagesCollectionView.reloadSections([messages.count-1])
////            }
////            isPaging = false
////        }
//    }
//
//}
//
//extension ViewAllGatheringBoardsViewController: UITableViewDataSource {
//    // Reporting the number of sections and rows in the table.
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if gatheringBoards.count == 0 {
//            return 0
//        } else {
//            return gatheringBoards[categoryId - 1].count
//        }
//    }
//    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//
//    
//    // Providing cells for each row of the table.
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: SmallGatheringBoardTableViewCell.identifier, for: indexPath) as? SmallGatheringBoardTableViewCell else { return UITableViewCell() }
////        if gatheringBoards.count != 0 {
////            cell.configure(with: gatheringBoards[categoryId - 1][indexPath.row])
////        }
////        cell.configure(with: gatheringBoards[categoryId][indexPath.row])
//        cell.selectionStyle = .none
//        cell.configure(with: gatheringBoards[categoryId - 1][indexPath.row])
//        cell.layoutIfNeeded()
//        return cell
//        
//    }
//    
//    
//}
//
//extension ViewAllGatheringBoardsViewController: UITableViewDelegate {
//    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//        // board detail 요청
//    }
//
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        // 셀의 데이터 세팅이 완료 된 후 실제 높이 값을
//        cellHeights[indexPath] = cell.frame.size.height
//        print("cell 높이", cellHeights[indexPath])
//    }
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 120 // UITableView.automaticDimension
//    }
//
//    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 120 //cellHeights[indexPath] ?? UITableView.automaticDimension
//    }
//}
//
//extension ViewAllGatheringBoardsViewController: UIScrollViewDelegate {
//    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//        Task(priority: .high) {
//            if scrollView.tag == 1 {
//                if (scrollView.contentOffset.y > (scrollView.contentSize.height-scrollView.frame.size
//                    .height)) {
//                    print("Upload for up scroling")
////                    await loadClipBoardBottom()
//                    pagingBoardsByCategory(categoryId: categoryId, isPaging: isPaging)
//                    print("End Bottom Load")
//                }
//            }
//        }
//    }
//}
//
//extension ViewAllGatheringBoardsViewController: UICollectionViewDelegate {
//    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        
//        collectionView.deselectItem(at: indexPath, animated: true)
////        let indexPath = IndexPath(item: 0, section: 0)
//        guard let cell = collectionView.cellForItem(at: indexPath) as? CategoryImageViewCollectionViewCell else { return }
//        selectedCell?.imageView.tintColor = .label
//        selectedCell?.titleLabel.textColor = .label
//        selectedCell?.backView.backgroundColor = .systemGray6 //.systemBackground
//        selectedCell?.backView.layer.borderWidth = 1
//        selectedCell?.backView.layer.borderColor = UIColor.systemGray6.cgColor
//        
////                backView.layer.borderColor = UIColor.label.cgColor
//        
////        selectedCell?.backView.layer.shadowColor = nil//UIColor.black.cgColor
////        selectedCell?.backView.layer.shadowOffset = CGSize(width: 0, height: 0)//CGSize(width: 1, height: 1)
////        selectedCell?.backView.layer.shadowRadius = 0
////        selectedCell?.backView.layer.shadowOpacity = 0//0.2
//        
//        selectedCell = cell
//        
////        selectedCell?.imageView.tintColor = .label//UIColor(rgb: 0x3232FF, alpha: 1.0) //.white // .white
////        selectedCell?.titleLabel.textColor = .label//UIColor(rgb: 0x3232FF, alpha: 1.0)
////        selectedCell?.backView.backgroundColor = .systemGray6//UIColor(rgb: 0xEFEFEF, alpha: 1.0) // .withAlphaComponent(0.8)
////        selectedCell?.backView.layer.borderWidth = 1
////        selectedCell?.backView.layer.borderColor = UIColor.systemGray4.cgColor//UIColor(rgb: 0xDDDDDD, alpha: 1.0).cgColor
////
//       
//        // 그라데이션
////        let gradientLayer = CAGradientLayer()
////        gradientLayer.frame = (selectedCell?.backView.bounds.integral)!
////        gradientLayer.colors = [UIColor(red: 177, green: 50, blue: 255, alpha: 1.0).cgColor, ServiceColor.primaryColor.cgColor]
//////        gradientLayer.locations = [0.7] // <- 추가
////        selectedCell?.backView.layer.addSublayer(gradientLayer)
//        
////        selectedCell?.backView.layer.shadowColor = ServiceColor.primaryColor.cgColor
////        selectedCell?.backView.layer.shadowOffset = CGSize(width: 3, height: 3)
////        selectedCell?.backView.layer.shadowRadius = 3
////        selectedCell?.backView.layer.shadowOpacity = 0.25
//        
//        if categoryId != indexPath.row + 1 {
//            categoryId = indexPath.row + 1
//            print("Tapped gatherging board collectionview", categoryId)
//            getBoardByCategory(categoryId: categoryId, isPaging: isPaging)
//        }
//    }
//}
//
//extension ViewAllGatheringBoardsViewController: UICollectionViewDataSource {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
////        return 10
//        return CategoryId.allCases.count
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        print("ProfileImages indexpath update \(indexPath)")
//        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryImageViewCollectionViewCell.identifier, for: indexPath) as? CategoryImageViewCollectionViewCell else { return UICollectionViewCell() }
////        if categoryId == indexPath.row+1 {
////            cell.isTapped = true
////        } else {
////            cell.isTapped = false
////        }
//        cell.configure(at: indexPath.row)
//        return cell
//    }
//}
//
//extension ViewAllGatheringBoardsViewController: UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//////        let size: CGFloat = imagesCollectionView.frame.size.width/2
////////        CGSize(width: size, height: size)
//////
//////        CGSize(width: view.frame.width / 5, height: view.frame.width / 5)
////        print("Sizing collectionView")
//        return CGSize(width: collectionView.frame.height - 44, height: collectionView.frame.height - 20)
////       let layoutAttributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
////       let size = CategoryImageViewCollectionViewCell().preferredLayoutAttributesFitting(layoutAttributes).frame.size
////       return size
//    }
//}
//
