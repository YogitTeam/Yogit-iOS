//
//  MyClubViewController.swift
//  Yogit
//
//  Created by Junseo Park on 2022/12/12.
//

import UIKit
import Alamofire
import SkeletonView

enum MyClubType: String {
    case search = "APPLIED_CLUB", create = "OPENED_CLUB"
    
    func toString() -> String {
        return self.rawValue
    }
}

private struct SmallGatheringPage {
    var cursor: Int
    var cursorList: Int
    var boards: [Board]
    
    init(cursor: Int = 0, cursorList: Int = 0, boards: [Board] = []) {
        self.cursor = cursor
        self.cursorList = cursorList
        self.boards = boards
    }
}

class MyClubViewController: UIViewController {
    private var tasks = [Task<(), Never>]()
    private var gatheringBoards = [Board]()
    private var pageCursor = 0
    private var pageListCnt = 0
    private var boardType: String = MyClubType.search.toString()
//    private var createPage = SmallGatheringPage()
//    private var searchPage = SmallGatheringPage()
//    private var taskArray = [DispatchWorkItem]()
    private var isPaging: Bool = false
    private let modular = 10
    private let skeletonAnimation = SkeletonAnimationBuilder().makeSlidingAnimation(withDirection: .topBottom)
//    private var createdBoards: [Board] = []
//    private var searchBoards: [Board] = []
    
    private(set) lazy var refreshControl: UIRefreshControl = {
        let control = UIRefreshControl()
        control.addTarget(self, action: #selector(refreshGatheringBoards), for: .valueChanged)
        return control
    }()
    
    private let myBoardsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.register(GatheringBoardThumbnailCollectionViewCell.self, forCellWithReuseIdentifier: GatheringBoardThumbnailCollectionViewCell.identifier)
//        collectionView.layer.borderColor = UIColor.systemGray.cgColor
//        collectionView.layer.borderWidth = 1
        collectionView.backgroundColor = .systemBackground
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isSkeletonable = true
        return collectionView
    }()
    
    
//    private let searchMyBoardCollectionView: UICollectionView = {
//        let layout = UICollectionViewFlowLayout()
//        layout.scrollDirection = .vertical
//        layout.sectionInset = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
//        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
//
//        collectionView.register(GatheringBoardThumbnailCollectionViewCell.self, forCellWithReuseIdentifier: GatheringBoardThumbnailCollectionViewCell.identifier)
////        collectionView.layer.borderColor = UIColor.systemGray.cgColor
////        collectionView.layer.borderWidth = 1
//        collectionView.backgroundColor = .systemBackground
//        collectionView.isHidden = false
//        collectionView.showsHorizontalScrollIndicator = false
//        return collectionView
//    }()
//
//    private let createMyBoardCollectionView: UICollectionView = {
//        let layout = UICollectionViewFlowLayout()
//        layout.scrollDirection = .vertical
//        layout.sectionInset = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
//        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
//        collectionView.isHidden = true
//        collectionView.register(GatheringBoardThumbnailCollectionViewCell.self, forCellWithReuseIdentifier: GatheringBoardThumbnailCollectionViewCell.identifier)
////        collectionView.layer.borderColor = UIColor.systemGray.cgColor
////        collectionView.layer.borderWidth = 1
//        collectionView.backgroundColor = .systemBackground
//        collectionView.showsHorizontalScrollIndicator = false
//        return collectionView
//    }()
    
    private lazy var segmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["Applied", "Opened"])
        control.addTarget(self, action: #selector(didChangeValue(_:)), for: .valueChanged)
        control.selectedSegmentIndex = 0
//        control.backgroundColor = UIColor(rgb: 0x3232FF, alpha: 1.0)
        control.selectedSegmentTintColor = UIColor(rgb: 0x3232FF, alpha: 1.0)
        control.layer.cornerRadius = 30
        control.layer.masksToBounds = true
//        control.clipsToBounds = true
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureCollectionView()
//        self.view.addSubview(searchMyBoardCollectionView)
//        self.view.addSubview(createMyBoardCollectionView)
//        searchMyBoardCollectionView.delegate = self
//        searchMyBoardCollectionView.dataSource = self
//        createMyBoardCollectionView.delegate = self
//        createMyBoardCollectionView.dataSource = self
//        getMyBoardThumbnail(type: MyClubType.search.toString(), cursor: searchPage.cursor)
        // Do any additional setup after loading the view.
    }


    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        segmentedControl.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }
        myBoardsCollectionView.snp.makeConstraints { make in
            make.top.equalTo(segmentedControl.snp.bottom).offset(10)
            make.leading.trailing.bottom.equalToSuperview()
        }
//        searchMyBoardCollectionView.snp.makeConstraints { make in
//            make.top.equalTo(segmentedControl.snp.bottom).offset(10)
////            make.leading.equalToSuperview().inset(10)
//            make.leading.trailing.bottom.equalToSuperview()
//        }
//        createMyBoardCollectionView.snp.makeConstraints { make in
//            make.top.equalTo(segmentedControl.snp.bottom)
////            make.leading.equalToSuperview().inset(10)
//            make.leading.trailing.bottom.equalToSuperview()
//        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        initNavigationBar()
    }

    private func configureView() {
        self.view.addSubview(segmentedControl)
        self.view.addSubview(myBoardsCollectionView)
        view.backgroundColor = .systemBackground
    }
    
    private func configureCollectionView() {
        myBoardsCollectionView.delegate = self
        myBoardsCollectionView.dataSource = self
        myBoardsCollectionView.refreshControl = refreshControl
        isPaging = true
        pagingMyBoards(type: boardType, firstPage: true)
    }
    
    @objc private func refreshGatheringBoards() {
        print("리프레쉬 ??")
        if !isPaging {
            print("리프레쉬 됨")
            isPaging = true
            resetBoardsData()
            pagingMyBoards(type: boardType, firstPage: true)
        } else {
            print("리프레쉬 안됨")
        }
        refreshControl.endRefreshing()
    }

    
    private func initNavigationBar() {
        self.tabBarController?.makeNaviTopLabel(title: TabBarKind.myClub.rawValue)
//        let editButton = self.tabBarController?.makeNaviTopButton(self, action: #selector(self.editButtonTapped(_:)), named: "Edit")
//        let settingButton = self.tabBarController?.makeNaviTopButton(self, action: #selector(self.settingButtonTapped(_:)), named: "Setting")
//        let spacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
//        spacer.width = 15
//        self.tabBarController?.navigationItem.rightBarButtonItems = [settingButton!, spacer, editButton!]
    }
    
    private func fetchGatheringMyBoards(type: String, page: Int, userId: Int64, refreshToken: String) async throws -> GetBoardsByCategoryRes {
        let getMyClub = GetMyClub(cursor: page, myClubType: type, refreshToken: refreshToken, userId: userId)
        let dataTask = AlamofireManager.shared.session.request(BoardRouter.readMyBoards(parameters: getMyClub)).validate(statusCode: 200..<501).serializingDecodable(APIResponse<GetBoardsByCategoryRes>.self)
        let response = await dataTask.response
        switch response.result {
        case .success:
        if let value = response.value, value.httpCode == 200, let data = value.data {
            return data
        } else {
            throw FetchError.badResponse
        }
        case let .failure(error):
            print("fetchGatheringMyBoards", error)
            throw FetchError.failureResponse
        }
    }
    
    private func pagingMyBoards(type: String, firstPage: Bool) {
        guard let userItem = try? KeychainManager.getUserItem() else { return }
        if firstPage {
            myBoardsCollectionView.showAnimatedGradientSkeleton(usingGradient: .init(colors: [.systemGray6, .systemGray5]), animation: skeletonAnimation, transition: .none)
        }
        let task = Task {
            do {
                let getData = try await fetchGatheringMyBoards(type: type, page: pageCursor, userId: userItem .userId, refreshToken: userItem.refresh_token)
                let totalPage = getData.totalPage
                if pageCursor < totalPage {
                    let getAllBoardResList = getData.getAllBoardResList
                    let getBoardCnt = getAllBoardResList.count
                    print("pageListCnt, getBoardCnt", pageListCnt, getBoardCnt)
                    if Task.isCancelled {
                       return
                    }
                    for i in pageListCnt..<getBoardCnt { // 2 < 3
                        if gatheringBoards.count > 0 && getAllBoardResList[i].boardID == gatheringBoards[gatheringBoards.count-1].boardID {
                            break
                        } // 최신 데이터가 추가되면 데이터가 뒤로 밀려날 경우에, 같은 보드 데이터는 jump
                        gatheringBoards.append(getAllBoardResList[i])
                        await MainActor.run {
                            myBoardsCollectionView.insertItems(at: [IndexPath(item: gatheringBoards.count-1, section: 0)])
                        }
                    }
                    pageListCnt = getBoardCnt%modular
                    if pageListCnt == 0 {
                        pageCursor += 1
                    }
                }
            } catch {
                print("fetchGatheringMyBoards error \(error.localizedDescription)")
            }
            if firstPage {
                myBoardsCollectionView.stopSkeletonAnimation()
                myBoardsCollectionView.hideSkeleton(reloadDataAfter: false)
            }
            isPaging = false
        }
        tasks.append(task)
    }
    
//    private func getMyBoardThumbnail(type: String, cursor: Int) {
//        guard let userItem = try? KeychainManager.getUserItem() else { return }
//        print("Type-getMyBoard", type)
//        let getMyClub = GetMyClub(cursor: cursor, myClubType: type, refreshToken: userItem.refresh_token, userId: userItem.userId)
//        AF.request(API.BASE_URL + "boards/get/myclub",
//                   method: .post,
//                   parameters: getMyClub,
//                   encoder: JSONParameterEncoder.default) // default set body and Content-Type HTTP header field of an encoded request is set to application/json
//        .validate(statusCode: 200..<500)
//        .response { response in // reponseData
//            switch response.result {
//            case .success:
//                if let data = response.data {
//                    do{
//                        let decodedData = try JSONDecoder().decode(APIResponse<[Board]>.self, from: data)
//                        guard let boardsData = decodedData.data else { return }
//                        print("boardsData", boardsData)
//                        //
//                        DispatchQueue.main.async {
//                            if type == MyClubType.search.toString() {
//                                // 10 < 10
//                                if searchPage.cursorList.count%(modular+1) < boardsData.count {
//                                    self.searchPage.cursor += 1
//                                    self.searchPage.boards.append(contentsOf: boardsData)
//                                    self.searchMyBoardCollectionView.reloadData()
//                                }
//                            }
//                            else {
//                                self.createPage.cursor += 1
//                                self.createPage.boards.append(contentsOf: boardsData)
//                                self.createMyBoardCollectionView.reloadData()
//                            }
//                            pageListCnt = getBoardCnt%modular
//                            if pageListCnt == 0 {
//                                pageCursor += 1
//                            }
//                            self.isPaging = false
//                        }
//                    }
//                    catch{
//                        print(error.localizedDescription)
//                    }
//                }
//            case .failure(let error):
//                print(error)
//            }
//        }
//    }
    
    private func resetBoardsData() {
        gatheringBoards.removeAll() //[categoryId-1].removeAll()
        pageCursor = 0
        pageListCnt = 0
        DispatchQueue.main.async { [weak self] in
            self?.myBoardsCollectionView.reloadData()
        }
    }
    
    @objc private func didChangeValue(_ sender: UISegmentedControl) {
        print("selectedSegmentIndex \(sender.selectedSegmentIndex)")
//        self.searchMyBoardCollectionView.isHidden = !self.searchMyBoardCollectionView.isHidden
//        self.createMyBoardCollectionView.isHidden = !self.createMyBoardCollectionView.isHidden

        for task in tasks {
            task.cancel()
        }
        isPaging = true
        resetBoardsData()
        if sender.selectedSegmentIndex == 0 {
            // 조회 get 요청
            print("MyClubType.search - segement 0")
            boardType = MyClubType.search.toString()
//            getMyBoardThumbnail(type: MyClubType.search.toString(), cursor: searchPage.cursor)
        } else {
            // 생성 get 요청
            print("MyClubType.search - segment 1")
            boardType = MyClubType.create.toString()
//            getMyBoardThumbnail(type: MyClubType.create.toString(), cursor: createPage.cursor)
        }
        pagingMyBoards(type: boardType, firstPage: true)
     }
}

extension MyClubViewController: SkeletonCollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        print("Tapped gatherging board collectionview image")
//        var boardId: Int64
//        if self.searchMyBoardCollectionView.isHidden {
//            boardId = createPage.boards[indexPath.row].boardID
//        } else {
//            boardId = searchPage.boards[indexPath.row].boardID
//        }
//
        let boardId = gatheringBoards[indexPath.row].boardID
        DispatchQueue.main.async {
            let GDBVC = GatheringDetailBoardViewController()
            GDBVC.boardWithMode.boardId = boardId
            self.navigationController?.pushViewController(GDBVC, animated: true)
        }
    }
}

extension MyClubViewController: SkeletonCollectionViewDataSource {
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> SkeletonView.ReusableCellIdentifier {
        return GatheringBoardThumbnailCollectionViewCell.identifier
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       // 아래의 코드로 컬렉션뷰를 다 채울 수 있다.
       return UICollectionView.automaticNumberOfSkeletonItems
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        if collectionView.tag == 0 {
//            return searchPage.boards.count
//        } else {
//            return createPage.boards.count
//        }
        return gatheringBoards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("indexpath update \(indexPath)")
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GatheringBoardThumbnailCollectionViewCell.identifier, for: indexPath) as? GatheringBoardThumbnailCollectionViewCell else { return UICollectionViewCell() }
        Task(priority: .userInitiated, operation: {
            let data = gatheringBoards[indexPath.row]
            await cell.configure(with: data)
        })
//        if collectionView.tag == 0 {
//            Task(priority: .userInitiated, operation: {
//                let data = searchPage.boards[indexPath.row]//searchBoards[indexPath.row]
//                await cell.configure(with: data)
//            })
////            DispatchQueue.main.async(qos: .userInteractive, execute: {
////                cell.configure(with: self.searchBoards[indexPath.row])
////            })
//        } else {
//            Task(priority: .userInitiated, operation: {
//                let data = createPage.boards[indexPath.row] //createdBoards[indexPath.row]
//                await cell.configure(with: data)
//            })
////            DispatchQueue.main.async(qos: .userInteractive, execute: {
////                cell.configure(with: self.createdBoards[indexPath.row])
////            })
//        }
        return cell
    }
}

extension MyClubViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
//        let size: CGFloat = imagesCollectionView.frame.size.width/2
////        CGSize(width: size, height: size)
//
//        CGSize(width: view.frame.width / 5, height: view.frame.width / 5)
        print("Sizing collectionView")
        return CGSize(width: collectionView.frame.width/2-25, height: (collectionView.frame.width/2-25)*5/4)
    }
}



extension  MyClubViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        // scrollView.contentOffset.y > 80 && 
        if !isPaging {
            if scrollView.contentOffset.y > 80 && (scrollView.contentOffset.y > (scrollView.contentSize.height-scrollView.frame.size
                .height)) { // -500
                print("하단 스크롤링")
                isPaging = true
                pagingMyBoards(type: boardType, firstPage: false)
            }
        }
    }

}
