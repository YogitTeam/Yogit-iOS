//
//  MainViewController.swift
//  Yogit
//
//  Created by Junseo Park on 2023/02/14.
//

import UIKit
import SnapKit
import CoreLocation
import SkeletonView

class MainViewController: UIViewController {
    private var gatheringPages = GatheringPages()
    
    private let skeletonAnimation = SkeletonAnimationBuilder().makeSlidingAnimation(withDirection: .topBottom)
    
    private var selectedCell: CategoryImageViewCollectionViewCell? {
        didSet {
            DispatchQueue.main.async { [weak self] in
                oldValue?.imageView.tintColor = .label
                oldValue?.titleLabel.textColor = .label
                oldValue?.backView.backgroundColor = .systemGray6
                oldValue?.backView.layer.borderWidth = 1
                oldValue?.backView.layer.borderColor = UIColor.systemGray6.cgColor
                
                self?.selectedCell?.imageView.tintColor = ServiceColor.primaryColor
                self?.selectedCell?.titleLabel.textColor = ServiceColor.primaryColor
                self?.selectedCell?.backView.backgroundColor = .systemGray6
                self?.selectedCell?.backView.layer.borderWidth = 1
                self?.selectedCell?.backView.layer.borderColor = ServiceColor.primaryColor.cgColor
            }
        }
    }
    
    private let guideLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.medium)
        label.sizeToFit()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        return label
    }()

    private(set) lazy var refreshControl: UIRefreshControl = {
        let control = UIRefreshControl()
        control.addTarget(self, action: #selector(refreshGatheringBoards), for: .valueChanged)
//        control.transform = CGAffineTransformMakeScale(0.5, 0.5)
        return control
    }()
    
    private lazy var createGatheringBoardButton: UIButton = {
        let button = UIButton()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold)
        let image = UIImage(systemName: "plus", withConfiguration: imageConfig)
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.isEnabled = true
        button.backgroundColor = ServiceColor.primaryColor
        button.addTarget(self, action: #selector(self.createBoardButtonTapped(_:)), for: .touchUpInside)
        return button
    }()

    
    private lazy var gatheringBoardCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(GatheringBoardThumbnailCollectionViewCell.self, forCellWithReuseIdentifier: GatheringBoardThumbnailCollectionViewCell.identifier)
        collectionView.register(LoadingFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: LoadingFooterView.identifier)
        collectionView.backgroundColor = .systemBackground
        collectionView.showsVerticalScrollIndicator = true
        collectionView.isSkeletonable = true
        collectionView.addSubview(guideLabel)
        return collectionView
    }()

    // category view
    private let categoryImageViewCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.estimatedItemSize = CGSize(width: 100, height: 100)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(CategoryImageViewCollectionViewCell.self, forCellWithReuseIdentifier: CategoryImageViewCollectionViewCell.identifier)
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    private lazy var searchCityNameButton: UIBarButtonItem = {
        let buttonTitle = ServiceCountry.defaulltCityName.localized()
        let buttonImage = UIImage(systemName: "chevron.down")?.withTintColor(.label, renderingMode: .alwaysOriginal)
        let button = UIButton(type: .custom)
//        button.semanticContentAttribute = .forceRightToLeft
        button.contentMode = .scaleAspectFit
        button.setTitle(buttonTitle, for: .normal)
        button.contentHorizontalAlignment = .right
        button.setImage(buttonImage, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.setTitleColor(.label, for: .normal)
        button.addTarget(self, action: #selector(searchCityNameButtonTapped), for: .touchUpInside)
        let barButtonItem = UIBarButtonItem(customView: button)
        barButtonItem.customView?.semanticContentAttribute = .forceRightToLeft
        return barButtonItem
    }()

    private let lineView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray3
        return view
    }()


    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureLayout()
        configureNav()
        configureCollectionView()
        initAPICall()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initNavigationBar()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let cell = categoryImageViewCollectionView.cellForItem(at: IndexPath(item: gatheringPages.categoryId-1, section: 0)) as? CategoryImageViewCollectionViewCell {
            selectedCell = cell
        }
    }

    private func configureView() {
        view.addSubview(categoryImageViewCollectionView)
        view.addSubview(gatheringBoardCollectionView)
        view.addSubview(lineView)
        view.addSubview(createGatheringBoardButton)
        view.backgroundColor = .systemBackground
    }
    
    private func configureLayout() {
        categoryImageViewCollectionView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(86)
        }
        lineView.snp.makeConstraints {
            $0.top.equalTo(categoryImageViewCollectionView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(0.2)
        }
        gatheringBoardCollectionView.snp.makeConstraints {
            $0.top.equalTo(lineView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        createGatheringBoardButton.snp.makeConstraints {
            $0.width.height.equalTo(54)
            $0.bottom.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        guideLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(20)
        }
    }
    
    private func configureNav() {
        navigationController?.navigationBar.topItem?.backButtonTitle = ""
        navigationController?.navigationBar.tintColor = UIColor.label
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.backgroundColor = .systemBackground
        navigationController?.navigationBar.standardAppearance = navigationBarAppearance
    }
    
    private func initNavigationBar() {
        tabBarController?.makeNaviTopLabel(title: TabBarKind.home.rawValue.localized())
        tabBarController?.navigationItem.rightBarButtonItems?.removeAll()
        tabBarController?.navigationItem.rightBarButtonItems = [searchCityNameButton]
        searchCityNameButton.customView?.semanticContentAttribute = .forceRightToLeft
    }

    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        createGatheringBoardButton.layer.cornerRadius = createGatheringBoardButton.frame.size.width/2
    }
    
    
    private func configureCollectionView() {
        categoryImageViewCollectionView.delegate = self
        categoryImageViewCollectionView.dataSource = self
        gatheringBoardCollectionView.delegate = self
        gatheringBoardCollectionView.dataSource = self
        gatheringBoardCollectionView.refreshControl = refreshControl
    }
    
    private func initAPICall() {
        pagingBoardsByCategory(categoryId: gatheringPages.categoryId, cityName: gatheringPages.cityNameToServer, isRefresh: true)
    }

    private func resetBoardsData() {
        gatheringPages.resetPage()
        gatheringBoardCollectionView.reloadData()
    }
    
    @MainActor private func bottomLoading() {
        let at = gatheringPages.boardsCnt == 0 ? 0 : gatheringPages.boardsCnt-1
        gatheringBoardCollectionView.reloadItems(at: [IndexPath(item: at, section: 0)])
    }
    
    @MainActor private func showGuideLabel(isInit: Bool) {
        if gatheringPages.boardsCnt == 0 && !isInit { // 초기값이 아니고
            guideLabel.text = "GATHERING_BOARD_NONE_GUIDE_TITLE".localized()
        } else {
            guideLabel.text = ""
        }
    }
    
    private func gatheringPagesInsertLogic(boards: GetBoardsByCategoryRes) async {
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
                        stIdx = idx + 1 // 일치 한다면 다음 인덱스 부터 시작
                        break
                    }
                }
            }
            for i in stIdx..<getBoardCnt {
                gatheringPages.addBoard(board: getAllBoardResList[i])
                await MainActor.run {
                    gatheringBoardCollectionView.insertItems(at: [IndexPath(item: gatheringPages.boardsCnt-1, section: 0)])
                }
            }
            if gatheringPages.boardsCnt%gatheringPages.modular == 0 {
                gatheringPages.addCursor()
            }
        }
    }
    
    // cityNameEng가 default면 기존 api, 다르면 다른 api 요청
    private func fetchGatheringBoardsByCategory(categoryId: Int, page: Int, userId: Int64, refreshToken: String) async throws -> GetBoardsByCategoryRes {
        let getBoardsByCategoryReq = GetBoardsByCategoryReq(categoryId: categoryId, cursor: page, refreshToken: refreshToken, userId: userId)
        let dataTask = AlamofireManager.shared.session.request(BoardRouter.readCategoryBoards(parameters: getBoardsByCategoryReq)).validate(statusCode: 200..<501).serializingDecodable(APIResponse<GetBoardsByCategoryRes>.self)
        let response = await dataTask.response
        switch response.result {
        case .success:
            if let value = response.value, value.httpCode == 200, let data = value.data {
                return data
            } else {
                throw FetchError.badResponse
            }
        case let .failure(error):
            print("fetchGatheringBoardsByCategory", error)
            throw FetchError.failureResponse
        }
    }
    
    // cityNameEng가 default면 기존 api, 다르면 다른 api 요청
    private func fetchGatheringBoardsByCategoryCity(cityName: String, categoryId: Int, page: Int, userId: Int64, refreshToken: String) async throws -> GetBoardsByCategoryRes {
        let getBoardsByCategoryCityReq = GetBoardsByCategoryCityReq(cityName: cityName, categoryId: categoryId, cursor: page, refreshToken: refreshToken, userId: userId)
        let dataTask = AlamofireManager.shared.session.request(BoardRouter.readCategoryBoardsByCity(parameters: getBoardsByCategoryCityReq)).validate(statusCode: 200..<501).serializingDecodable(APIResponse<GetBoardsByCategoryRes>.self)
        let response = await dataTask.response
        switch response.result {
        case .success:
            if let value = response.value, value.httpCode == 200, let data = value.data {
                return data
            } else {
                throw FetchError.badResponse
            }
        case let .failure(error):
            print("fetchGatheringBoardsByCategory", error)
            throw FetchError.failureResponse
        }
    }
    
    private func pagingBoardsByCategory(categoryId: Int, cityName: String?, isRefresh: Bool) {
        guard let identifier = UserDefaults.standard.object(forKey: UserSessionManager.currentServiceTypeIdentifier) as? String,
              let userItem = try? KeychainManager.getUserItem(serviceType: identifier)
        else { return }
        let startTime = DispatchTime.now().uptimeNanoseconds
        showGuideLabel(isInit: true)
        gatheringPages.isPaging = true
        gatheringPages.isLoading = false
        if isRefresh {
            gatheringBoardCollectionView.showAnimatedGradientSkeleton(usingGradient: .init(colors: [.systemGray6, .systemGray5]), animation: skeletonAnimation, transition: .none)
        }
        let task = Task {
            do {
                if Task.isCancelled {
                    print("Before api request")
                   return
                }
                
                let getData: GetBoardsByCategoryRes
                if gatheringPages.isDefaultCity {
                    getData = try await fetchGatheringBoardsByCategory(categoryId: categoryId, page: gatheringPages.cursor, userId: userItem .userId, refreshToken: userItem.refresh_token)
                } else {
                    guard let cityName = cityName else { return }
                    getData = try await fetchGatheringBoardsByCategoryCity(cityName: cityName, categoryId: categoryId, page: gatheringPages.cursor, userId: userItem .userId, refreshToken: userItem.refresh_token)
                }
        
                if Task.isCancelled {
                    print("Before skeletion animation stop")
                   return
                }
                
                if isRefresh {
                    gatheringBoardCollectionView.stopSkeletonAnimation()
                    gatheringBoardCollectionView.hideSkeleton(reloadDataAfter: false)
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
                    print("Before page load")
                   return
                }

                await gatheringPagesInsertLogic(boards: getData)
                
                showGuideLabel(isInit: false)
            } catch {
                print("fetchGatheringBoardsByCategory error \(error.localizedDescription)")
            }
            gatheringPages.isPaging = false
        }
        gatheringPages.addTask(task: task)
    }
    
    @objc private func searchCityNameButtonTapped(_ sender: UIButton) {
        DispatchQueue.main.async(execute: {
            let SCNTVC = SearchCityNameViewController()
            SCNTVC.delegate = self
            let NC = UINavigationController(rootViewController: SCNTVC)
            NC.modalPresentationStyle = .fullScreen
            self.present(NC, animated: true, completion: nil)
        })
    }
    
    @objc private func refreshGatheringBoards() {
        if !gatheringPages.isPaging {
            resetBoardsData()
            pagingBoardsByCategory(categoryId: gatheringPages.categoryId, cityName: gatheringPages.cityNameToServer, isRefresh: true)
        }
        refreshControl.endRefreshing()
    }
    
    @objc func createBoardButtonTapped(_ sender: UIButton) {
        DispatchQueue.main.async {
            let GBCVC = GatheringBoardCategoryViewController()
            GBCVC.boardWithMode.mode = .create 
            self.navigationController?.pushViewController(GBCVC, animated: true)
        }
    }
}

extension  MainViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == gatheringBoardCollectionView && !gatheringPages.isPaging {
            if scrollView.contentOffset.y > 86 && (scrollView.contentOffset.y > (scrollView.contentSize.height-scrollView.frame.size
                .height)) { // -500
                gatheringPages.isLoading = true
                bottomLoading()
                pagingBoardsByCategory(categoryId: gatheringPages.categoryId, cityName: gatheringPages.cityNameToServer, isRefresh: false)
            }
        }
    }
}

extension MainViewController: SkeletonCollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == categoryImageViewCollectionView {
            if gatheringPages.categoryId != indexPath.row + 1 {
                DispatchQueue.main.async { [weak self] in
                    if let cell = collectionView.cellForItem(at: indexPath) as? CategoryImageViewCollectionViewCell {
                        self?.selectedCell = cell
                    }
                }
                gatheringPages.categoryId = indexPath.row + 1
                resetBoardsData() // page reset logic
                pagingBoardsByCategory(categoryId: gatheringPages.categoryId, cityName: gatheringPages.cityNameToServer, isRefresh: true)
            }
        } else {
            DispatchQueue.main.async { [weak self] in
                let boardId = self?.gatheringPages.getBoardId(idx: indexPath.row)
                let GDBVC = GatheringDetailBoardViewController()
                GDBVC.boardWithMode.boardId = boardId
                self?.navigationController?.pushViewController(GDBVC, animated: true)
            }
        }
    }
}

extension MainViewController: SkeletonCollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if collectionView == gatheringBoardCollectionView && kind == UICollectionView.elementKindSectionFooter && indexPath.section == 0 {
            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: LoadingFooterView.identifier, for: indexPath) as? LoadingFooterView
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
        if collectionView == categoryImageViewCollectionView {
            return CategoryId.allCases.count
        } else {
            return gatheringPages.boardsCnt
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == categoryImageViewCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryImageViewCollectionViewCell.identifier, for: indexPath) as? CategoryImageViewCollectionViewCell else { return UICollectionViewCell() }
            DispatchQueue.main.async {
                cell.configure(at: indexPath.row)
            }
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GatheringBoardThumbnailCollectionViewCell.identifier, for: indexPath) as? GatheringBoardThumbnailCollectionViewCell else { return UICollectionViewCell() }
            let data = gatheringPages.boards[indexPath.row]
            Task {
                await cell.configure(with: data)
            }
            return cell
        }
    }
}

extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == categoryImageViewCollectionView {
            return CGSize(width: 58, height: 58)
        } else {
            return CGSize(width: collectionView.frame.width/2-25, height: (collectionView.frame.width/2-25)*5/4)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if collectionView == gatheringBoardCollectionView {
            if gatheringPages.isLoading {
                return CGSize(width: collectionView.bounds.width, height: 50)
            }
        }
        return CGSize.zero
    }
}

extension MainViewController: SearchCityNameProtocol {
    func cityNameSend(cityNameLocalized: String) {
        gatheringPages.cityNameLocalized = cityNameLocalized // localized 전 (defaultCityName포함)
        guard let button = searchCityNameButton.customView as? UIButton else { return }
        button.setTitle(cityNameLocalized.localized(), for: .normal) // localized 되서 보여준다.
        searchCityNameButton.customView?.semanticContentAttribute = .forceRightToLeft
        if gatheringPages.isDefaultCity {
            resetBoardsData()
            pagingBoardsByCategory(categoryId: gatheringPages.categoryId, cityName: gatheringPages.cityNameToServer, isRefresh: true)
        } else {
            LocationManager.shared.cityNameGeocodingToServer(address: cityNameLocalized) { [weak self] (cityNameEng, countyCode) in
                guard let self = self else { return }
                self.gatheringPages.cityNameToServer = cityNameEng
                self.resetBoardsData()
                self.pagingBoardsByCategory(categoryId: self.gatheringPages.categoryId, cityName: self.gatheringPages.cityNameToServer, isRefresh: true)
            }
        }
    }
}
