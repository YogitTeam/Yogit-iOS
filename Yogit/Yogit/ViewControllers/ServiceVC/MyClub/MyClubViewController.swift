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

class MyClubViewController: UIViewController {
    private var gatheringPages = GatheringPages()

    private var boardType: String = MyClubType.search.toString()

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
        control.selectedSegmentTintColor = ServiceColor.primaryColor
        control.layer.cornerRadius = 30
        control.layer.masksToBounds = true
        let normalAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.black,
        ]
        control.setTitleTextAttributes(normalAttributes, for: .normal)
        let selectedAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white,
        ]
        control.setTitleTextAttributes(selectedAttributes, for: .selected)
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureLayout()
        configureCollectionView()
        initAPICall()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initNavigationBar()
    }

    private func configureView() {
        view.addSubview(segmentedControl)
        view.addSubview(myBoardsCollectionView)
        view.backgroundColor = .systemBackground
    }
    
    private func configureCollectionView() {
        myBoardsCollectionView.delegate = self
        myBoardsCollectionView.dataSource = self
        myBoardsCollectionView.refreshControl = refreshControl
    }
    
    private func configureLayout() {
        segmentedControl.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }
        myBoardsCollectionView.snp.makeConstraints { make in
            make.top.equalTo(segmentedControl.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func initAPICall() {
        pagingMyBoards(type: boardType, isRefresh: true)
    }
    
    @objc private func refreshGatheringBoards() {
        if !gatheringPages.isPaging {
            resetBoardsData()
            pagingMyBoards(type: boardType, isRefresh: true)
        }
        refreshControl.endRefreshing()
    }

    
    private func initNavigationBar() {
        tabBarController?.makeNaviTopLabel(title: TabBarKind.myClub.rawValue.localized())
        tabBarController?.navigationItem.rightBarButtonItems?.removeAll()
//        let editButton = self.tabBarController?.makeNaviTopButton(self, action: #selector(self.editButtonTapped(_:)), named: "Edit")
//        let settingButton = self.tabBarController?.makeNaviTopButton(self, action: #selector(self.settingButtonTapped(_:)), named: "Setting")
//        let spacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
//        spacer.width = 15
//        self.tabBarController?.navigationItem.rightBarButtonItems = [settingButton!, spacer, editButton!]
    }
    
    @MainActor private func bottomLoading() {
        let at = gatheringPages.boardsCnt == 0 ? 0 : gatheringPages.boardsCnt-1
        myBoardsCollectionView.reloadItems(at: [IndexPath(item: at, section: 0)])
    }
    
    private func gatheringMyPagesInsertLogic(boards: GetBoardsByCategoryRes) async {
        let totalPage = boards.totalPage
        if gatheringPages.cursor < totalPage {
            let getAllBoardResList = boards.getAllBoardResList
            let getBoardCnt = getAllBoardResList.count
            var stIdx = 0
            if gatheringPages.boardsCnt > 0 {
                // 동기화 이후 리스트 삭제/추가하면 중복되지 않게 검증 절차
                // 서버의 마지막 인덱스값부터 -1씩 감소하며 기존 리스트의 마지막 인덱스 값과 일치하는지 검사
                for idx in stride(from: getBoardCnt-1, through: 0, by: -1) {
                    if gatheringPages.lastBoardId == getAllBoardResList[idx].boardID {
                        stIdx = idx + 1 // 일치한다면 다음 인덱스 부터 시작
                        break
                    }
                }
            }
            for i in stIdx..<getBoardCnt {
                gatheringPages.addBoard(board: getAllBoardResList[i])
                await MainActor.run {
                    myBoardsCollectionView.insertItems(at: [IndexPath(item: gatheringPages.boardsCnt-1, section: 0)])
                }
            }
            gatheringPages.addCursor()
        }
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
    
    private func pagingMyBoards(type: String, isRefresh: Bool) {
        guard let identifier = UserDefaults.standard.object(forKey: UserSessionManager.currentServiceTypeIdentifier) as? String,
              let userItem = try? KeychainManager.getUserItem(serviceType: identifier)
        else { return }
        gatheringPages.isPaging = true
        gatheringPages.isLoading = false
        if isRefresh {
            myBoardsCollectionView.showAnimatedGradientSkeleton(usingGradient: .init(colors: [.systemGray6, .systemGray5]), animation: skeletonAnimation, transition: .none)
        }
        let task = Task {
            do {
                
                if Task.isCancelled {
                    print("Before api request")
                   return
                }
                
                let startTime = DispatchTime.now().uptimeNanoseconds
                
                let getData = try await fetchGatheringMyBoards(type: type, page: gatheringPages.cursor, userId: userItem .userId, refreshToken: userItem.refresh_token)
                
                if Task.isCancelled {
                    print("Before skeletion animation stop")
                   return
                }
                
                if isRefresh {
                    myBoardsCollectionView.stopSkeletonAnimation()
                    myBoardsCollectionView.hideSkeleton(reloadDataAfter: false)
                } else {
                    let endTime = DispatchTime.now().uptimeNanoseconds
                    let elapsedTime = endTime - startTime
                    if elapsedTime <= 500_000_000 {
                        do {
                            try await Task.sleep(nanoseconds: 500_000_000 - elapsedTime)
                        } catch {
                            print("sleep nanoseconds error \(error.localizedDescription)") // Task 취소 되면 에러 발생
                        }
                    }
                    bottomLoading()
                }
                
                if Task.isCancelled {
                    print("Before page loading")
                   return
                }
                
                await gatheringMyPagesInsertLogic(boards: getData)
                
                
            } catch {
                print("fetchGatheringMyBoards error \(error.localizedDescription)")
            }
            gatheringPages.isPaging = false
        }
        gatheringPages.addTask(task: task)
    }
    
    private func resetBoardsData() {
        gatheringPages.resetPage()
        myBoardsCollectionView.reloadData()
    }
    
    @objc private func didChangeValue(_ sender: UISegmentedControl) {
        resetBoardsData()
        if sender.selectedSegmentIndex == 0 {
            boardType = MyClubType.search.toString() // 조회 모임
        } else {
            boardType = MyClubType.create.toString() // 생성 모임
        }
        pagingMyBoards(type: boardType, isRefresh: true)
     }
}

extension MyClubViewController: SkeletonCollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        DispatchQueue.main.async { [weak self] in
            let boardId = self?.gatheringPages.getBoardId(idx: indexPath.row)
            let GDBVC = GatheringDetailBoardViewController()
            GDBVC.boardWithMode.boardId = boardId
            self?.navigationController?.pushViewController(GDBVC, animated: true)
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
       return 6 //UICollectionView.automaticNumberOfSkeletonItems
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gatheringPages.boardsCnt
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GatheringBoardThumbnailCollectionViewCell.identifier, for: indexPath) as? GatheringBoardThumbnailCollectionViewCell else { return UICollectionViewCell() }
        let data = gatheringPages.boards[indexPath.row]
        Task {
            await cell.configure(with: data)
        }
        return cell
    }
}

extension MyClubViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width/2-25, height: (collectionView.frame.width/2-25)*5/4)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if gatheringPages.isLoading {
            return CGSize(width: collectionView.bounds.width, height: 50)
        }
        return CGSize.zero
    }
}



extension  MyClubViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        // scrollView.contentOffset.y > 80 &&
        if !gatheringPages.isPaging {
            if scrollView.contentOffset.y > 80 && (scrollView.contentOffset.y > (scrollView.contentSize.height-scrollView.frame.size
                .height)) { // -500
                gatheringPages.isLoading = true
                bottomLoading()
                pagingMyBoards(type: boardType, isRefresh: false)
            }
        }
    }

}
