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
    private var isPaging: Bool = false
    private var isLoading: Bool = false
    private let modular = 10
    private let skeletonAnimation = SkeletonAnimationBuilder().makeSlidingAnimation(withDirection: .topBottom)
    
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
        collectionView.register(LoadingFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: LoadingFooterView.identifier)
        collectionView.backgroundColor = .systemBackground
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isSkeletonable = true
        return collectionView
    }()
    
    
    private lazy var segmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["JOINED".localized(), "OPENED".localized()])
        control.addTarget(self, action: #selector(didChangeValue(_:)), for: .valueChanged)
        control.selectedSegmentIndex = 0
//        control.backgroundColor = ServiceColor.primaryColor
        control.selectedSegmentTintColor = ServiceColor.primaryColor
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
        initAPICall()
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
    }
    
    private func initAPICall() {
        isPaging = true
        pagingMyBoards(type: boardType, firstPage: true)
    }
    
    @objc private func refreshGatheringBoards() {
        if !isPaging {
            isPaging = true
            resetBoardsData()
            pagingMyBoards(type: boardType, firstPage: true)
        }
        refreshControl.endRefreshing()
    }

    
    private func initNavigationBar() {
        self.tabBarController?.makeNaviTopLabel(title: TabBarKind.myClub.rawValue.localized())
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
            print("fetchGatheringMyBoards error", error)
            throw FetchError.failureResponse
        }
    }
    
    private func pagingMyBoards(type: String, firstPage: Bool) {
        guard let identifier = UserDefaults.standard.object(forKey: SessionManager.currentServiceTypeIdentifier) as? String else { return }
        guard let userItem = try? KeychainManager.getUserItem(serviceType: identifier) else { return }
        if firstPage {
            myBoardsCollectionView.showAnimatedGradientSkeleton(usingGradient: .init(colors: [.systemGray6, .systemGray5]), animation: skeletonAnimation, transition: .none)
        }
        isLoading = false
        let startTime = DispatchTime.now().uptimeNanoseconds
        let task = Task {
            do {
                let getData = try await fetchGatheringMyBoards(type: type, page: pageCursor, userId: userItem .userId, refreshToken: userItem.refresh_token)
                let totalPage = getData.totalPage
                if pageCursor < totalPage {
                    let getAllBoardResList = getData.getAllBoardResList
                    let getBoardCnt = getAllBoardResList.count
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
            } else {
                let endTime = DispatchTime.now().uptimeNanoseconds
                let elapsedTime = endTime - startTime
                if elapsedTime <= 300_000_000 {
                    do {
                        try await Task.sleep(nanoseconds: 300_000_000 - elapsedTime)
                    } catch {
                        print("sleep nanoseconds error \(error.localizedDescription)")
                    }
                }
                let at = gatheringBoards.count == 0 ? 0 : gatheringBoards.count-1
                myBoardsCollectionView.reloadItems(at: [IndexPath(item: at, section: 0)])
            }
            isPaging = false
        }
        tasks.append(task)
    }
    
    private func resetBoardsData() {
        gatheringBoards.removeAll() //[categoryId-1].removeAll()
        pageCursor = 0
        pageListCnt = 0
        DispatchQueue.main.async { [weak self] in
            self?.myBoardsCollectionView.reloadData()
        }
    }
    
    @objc private func didChangeValue(_ sender: UISegmentedControl) {
        for task in tasks {
            task.cancel()
        }
        isPaging = true
        resetBoardsData()
        if sender.selectedSegmentIndex == 0 {
            boardType = MyClubType.search.toString() // 조회 모임
        } else {
            boardType = MyClubType.create.toString() // 생성 모임
        }
        pagingMyBoards(type: boardType, firstPage: true)
     }
}

extension MyClubViewController: SkeletonCollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let boardId = gatheringBoards[indexPath.row].boardID
        DispatchQueue.main.async {
            let GDBVC = GatheringDetailBoardViewController()
            GDBVC.boardWithMode.boardId = boardId
            self.navigationController?.pushViewController(GDBVC, animated: true)
        }
    }
}

extension MyClubViewController: SkeletonCollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionFooter && indexPath.section == 0 {
            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: LoadingFooterView.identifier, for: indexPath) as? LoadingFooterView
            // Customize the footer view as needed
            return footerView!
        }
        return UICollectionReusableView()
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> SkeletonView.ReusableCellIdentifier {
        return GatheringBoardThumbnailCollectionViewCell.identifier
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       return UICollectionView.automaticNumberOfSkeletonItems
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gatheringBoards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GatheringBoardThumbnailCollectionViewCell.identifier, for: indexPath) as? GatheringBoardThumbnailCollectionViewCell else { return UICollectionViewCell() }
        Task(priority: .userInitiated, operation: {
            let data = gatheringBoards[indexPath.row]
            await cell.configure(with: data)
        })
        return cell
    }
}

extension MyClubViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width/2-25, height: (collectionView.frame.width/2-25)*5/4)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if isLoading {
            return CGSize(width: collectionView.bounds.width, height: 50)
        }
        return CGSize.zero
    }
}



extension  MyClubViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        // scrollView.contentOffset.y > 80 && 
        if !isPaging {
            if scrollView.contentOffset.y > 80 && (scrollView.contentOffset.y > (scrollView.contentSize.height-scrollView.frame.size
                .height)) { // -500
                isPaging = true
                isLoading = true
                let at = gatheringBoards.count == 0 ? 0 : gatheringBoards.count-1
                myBoardsCollectionView.reloadItems(at: [IndexPath(item: at, section: 0)])
                pagingMyBoards(type: boardType, firstPage: false)
            }
        }
    }

}
