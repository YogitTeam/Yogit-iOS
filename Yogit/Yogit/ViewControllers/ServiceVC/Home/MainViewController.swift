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

//enum GatheringBoardLocationFilter{
////    var localityD
//    case none
//    case locality(parameter: String)
//    case distance(parameter: CLLocationCoordinate2D)
//
//    // 로컬 디비에 저장, 좌표는 소수점 세자리까지만 (보안)
//    var localityName: String? { // 로컬라이징으로 변경해야함
//        get {
//            guard let userItem = try? KeychainManager.getUserItem(),
//                  let localityName = userItem.account.localtiy
//            else { return nil }
//            return userItem.account.localtiy
//        } set (value) {
//            do {
//                // userStatus 정보 업데이트 (LOGIN)
//                // status만 업데이트
//                if let userItem = try? KeychainManager.getUserItem() {
//                    userItem.account.localtiy = value
//                    try KeychainManager.updateUserItem(userItem: userItem)
//                }
//            } catch {
//                print("KeychainManager.saveUserItem \(error.localizedDescription)")
//            }
//        }
//    }
//    var coordindate: CLLocationCoordinate2D? {
//        get {
//            guard let userItem = try? KeychainManager.getUserItem(),
//                  let latitude = userItem.account.latitude,
//                  let longitude = userItem.account.longitude
//            else { return nil }
//            return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
//        } set (value) {
//            do {
//
//                let number = 3.141592
//                let roundedNumber = String(format: "%.3f", number)
//                print(roundedNumber) // "3.142"
//                // userStatus 정보 업데이트 (LOGIN)
//                // status만 업데이트
//                if let userItem = try? KeychainManager.getUserItem() {
//                    userItem.account.localtiy = value
//                    try KeychainManager.updateUserItem(userItem: userItem)
//                }
//            } catch {
//                print("KeychainManager.saveUserItem \(error.localizedDescription)")
//            }
//        }
//    }
//
//    func calculateDistance(startLatitude: Double, endLongitude: Double) -> Double {
//        let stDigitLatitude = String(format: "%.3f", startLatitude)
//        let enDigitLongitude = String(format: "%.3f", enDigitLongitude)
//        let startCoordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
//        let endCoordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
//
//        let startLocation = CLLocation(latitude: startCoordinate.latitude, longitude: startCoordinate.longitude)
//        let endLocation = CLLocation(latitude: endCoordinate.latitude, longitude: endCoordinate.longitude)
//
//        let distanceInMeters = startLocation.distance(from: endLocation)
//        let distanceInKilometers = distanceInMeters / 1000
//        return distanceInKilometers
//    }
//}
//
//enum FilterType {
//    case city, distance, none
//}
//
//enum Location {
//    case locality(name: String)
//    case coordinates(latitude: Double, longitude: Double)
//
//    var latitude: Double? {
//        switch self {
//        case .coordinates(let lat, _):
//            return lat
//        default:
//            return nil
//        }
//    }
//
//    var longitude: Double? {
//        switch self {
//        case .coordinates(_, let long):
//            return long
//        default:
//            return nil
//        }
//    }
//
//    var name: String? {
//        switch self {
//        case .locality(let name):
//            return name
//        default:
//            return nil
//        }
//    }
//}
//
//
//
//struct Filter {
////    var isFiltered: Bool
//    private var fillterType: FilterType //
//    private var distance: Double
//    private var cityName: String // 로컬에 저장
////    private var address: String {
////        get {
////            return cityName
////        }
////        set (value) {
////            forwardGeocoding(address: value) { ()
////
////            }
////        }
////    }
//
//    init(fillterType: FilterType) { // 로컬 디비에 저자
////        self.isFiltered = isFiltered
//        self.fillterType = .none
//    }
//
//    mutating func setCityFilter(address: String) -> String {
//        self.fillterType = .city
//        forwardGeocoding(address: address) { (cityName, countryCode) in
//            self.cityName = cityName
//        }
////        self.fillterType = fillterType
//
////        switch self.fillterType {
////        case .city: break
//////            forwardGeocoding(address: <#T##String#>) { ()
//////
//////            }
////        case .distance: break
////        case .none: break
////        }
//    }
//
//    func calculateDistance(latitude: Double, longitude: Double) -> Double {
//        let startCoordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
//        let endCoordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
//
//        let startLocation = CLLocation(latitude: startCoordinate.latitude, longitude: startCoordinate.longitude)
//        let endLocation = CLLocation(latitude: endCoordinate.latitude, longitude: endCoordinate.longitude)
//
//        let distanceInMeters = startLocation.distance(from: endLocation)
//        let distanceInKilometers = distanceInMeters / 1000
//        return distanceInKilometers
//    }
//
//    mutating func forwardGeocoding(address: String, completion: @escaping (String, String) -> Void) {
//        print("forwardGeocoding locality", address)
//        let geocoder = CLGeocoder()
////        let locale = Locale(identifier: "en_US")
//        guard let identifier = Locale.preferredLanguages.first else { return }// en-KR
//        let region = Locale.current.region?.identifier // KR
//        let locale = Locale(identifier: identifier)
//
//        // 주소 다됨 (country, locality, "KR" >> South Korea)
//        geocoder.geocodeAddressString(address, in: nil, preferredLocale: locale, completionHandler: { (placemarks, error) in
//            if error != nil {
//                print("Failed to geocodeAddressString location")
//                return
//            }
//
//            guard let pm = placemarks?.last else { return }
//            guard let locality = pm.locality else { return }
//            guard let countryCodeName = pm.country else { return }
//            print("forwardGeocoding locality and county", locality, countryCodeName)
//            self.cityName = locality
//            completion(locality, countryCodeName)
//        })
//    }
//}

// 테이블뷰 헤더 콜렉션뷰 카테고리
// 각 카테고리마다 페이지네이션 필요
class  MainViewController: UIViewController {

//    func ddd() {
//        // Example usage
//        let selectedLocality = Location.locality(name: "New York City")
//        print("Selected locality name: \(selectedLocality.name ?? "N/A")")
//
//        let selectedCoordinates = Location.coordinates(latitude: 40.7128, longitude: -74.0060)
//        print("Selected coordinates: (\(selectedCoordinates.latitude ?? 0), \(selectedCoordinates.longitude ?? 0))")
//    }
        
//    private var filteredGatheringBoards = [[Board]]()
    private var gatheringBoards = [Board]()
    private var pageCursor = 0
    private var pageListCnt = 0
    private var isPaging: Bool = false
    private var isLoading: Bool = false
    private let modular = 10
    private var tasks = [Task<(), Never>]()
    private var categoryId: Int = 1
    
    private var selectedCell: CategoryImageViewCollectionViewCell? {
        didSet {
            print("변경후")
            DispatchQueue.main.async { [weak self] in
                oldValue?.imageView.tintColor = .label
                oldValue?.titleLabel.textColor = .label
                oldValue?.backView.backgroundColor = .systemGray6 //.systemBackground
                oldValue?.backView.layer.borderWidth = 1
                oldValue?.backView.layer.borderColor = UIColor.systemGray6.cgColor
                
                self?.selectedCell?.imageView.tintColor = ServiceColor.primaryColor//.label//UIColor(rgb: 0x3232FF, alpha: 1.0) //.white // .white
                self?.selectedCell?.titleLabel.textColor = ServiceColor.primaryColor //.label//UIColor(rgb: 0x3232FF, alpha: 1.0)
                self?.selectedCell?.backView.backgroundColor = .systemGray6//UIColor(rgb: 0xEFEFEF, alpha: 1.0) // .withAlphaComponent(0.8)
                self?.selectedCell?.backView.layer.borderWidth = 1
                self?.selectedCell?.backView.layer.borderColor = ServiceColor.primaryColor.cgColor
            }
        }
    }

    private(set) lazy var refreshControl: UIRefreshControl = {
        let control = UIRefreshControl()
        control.addTarget(self, action: #selector(refreshGatheringBoards), for: .valueChanged)
//        control.transform = CGAffineTransformMakeScale(0.5, 0.5)
        return control
    }()
    
    private lazy var createGatheringBoardButton: UIButton = {
        let button = UIButton()
//        button.setImage(UIImage(named: "Edit")?.withTintColor(.label, renderingMode: .alwaysOriginal), for: .normal)
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold)
        let image = UIImage(systemName: "plus", withConfiguration: imageConfig)
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.isEnabled = true
        button.backgroundColor = ServiceColor.primaryColor
        button.addTarget(self, action: #selector(self.createBoardButtonTapped(_:)), for: .touchUpInside)
        return button
    }()

    
    private let gatheringBoardCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(GatheringBoardThumbnailCollectionViewCell.self, forCellWithReuseIdentifier: GatheringBoardThumbnailCollectionViewCell.identifier)
        collectionView.register(LoadingFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: LoadingFooterView.identifier)
        collectionView.backgroundColor = .systemBackground
        collectionView.showsVerticalScrollIndicator = true
        collectionView.isSkeletonable = true
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

    private let lineView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray3
        return view
    }()


    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureCollectionView()
        initAPICall()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initNavigationBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let cell = categoryImageViewCollectionView.cellForItem(at: IndexPath(item: categoryId-1, section: 0)) as? CategoryImageViewCollectionViewCell {
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
    
    private func initNavigationBar() {
        self.tabBarController?.makeNaviTopLabel(title: TabBarKind.home.rawValue.localized())
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
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
        createGatheringBoardButton.snp.makeConstraints { make in
            make.width.height.equalTo(54)
            make.bottom.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        createGatheringBoardButton.layoutIfNeeded()
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
        isPaging = true
        pagingBoardsByCategory(categoryId: categoryId, isFirstPage: true)
    }

    // 카테고리 눌렀을때만 reloadData
    private func resetBoardsData(categoryId: Int) {
        gatheringBoards.removeAll() //[categoryId-1].removeAll()
        pageCursor = 0
        pageListCnt = 0
        DispatchQueue.main.async {
            self.gatheringBoardCollectionView.reloadData()
        }
    }
    
    private func fetchGatheringBoardsByCategory(category: Int, page: Int, userId: Int64, refreshToken: String) async throws -> GetBoardsByCategoryRes {
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

//    func fetchGatheringBoardsByCategory(category: Int, page: Int) async -> GetBoardsByCategoryRes? {
//        guard let userItem = try? KeychainManager.getUserItem() else { return nil }
//        let getBoardsByCategoryReq = GetBoardsByCategoryReq(categoryId: categoryId, cursor: page, refreshToken: userItem.refresh_token, userId: userItem.userId)
//        let dataTask = AlamofireManager.shared.session.request(BoardRouter.readCategoryBoards(parameters: getBoardsByCategoryReq)).validate(statusCode: 200..<501).serializingDecodable(APIResponse<GetBoardsByCategoryRes>.self)
//        let response = await dataTask.response
//        let value = response.value
//        return value?.data
//    }

//    // category 1부터 시작
//    private func pagingBoardsByCategory(categoryId: Int, isPaging: Bool) async {
//        if isPaging { return }
//        else { self.isPaging = true }
//        let page = pagesCursor[categoryId-1]
//        let getData = await fetchGatheringBoardsByCategory(category: categoryId, page: page)
//        guard let totalPage = getData?.totalPage else { return }
//        if page < totalPage {
//            guard let getAllBoardResList = getData?.getAllBoardResList else { return }
//            let getBoardCnt = getAllBoardResList.count
//            let pageListCnt = pagesListCount[categoryId-1]
//            for i in pageListCnt..<getBoardCnt {
//                gatheringBoards[categoryId-1].append(getAllBoardResList[i])
//                gatheringBoardCollectionView.insertItems(at: [IndexPath(item: gatheringBoards[categoryId-1].count-1, section: 0)])
//            }
//            pagesListCount[categoryId-1] = getBoardCnt%modular // 0
//            if pagesListCount[categoryId-1] == 0 {
//                pagesCursor[categoryId-1] += 1
//            }
//        }
//        self.isPaging = false
//    }
    
    // category 1부터 시작
    
    private func pagingBoardsByCategory(categoryId: Int, isFirstPage: Bool) {
        guard let identifier = UserDefaults.standard.object(forKey: SessionManager.currentServiceTypeIdentifier) as? String, let userItem = try? KeychainManager.getUserItem(serviceType: identifier) else { return }
        if isFirstPage {
            let skeletonAnimation = SkeletonAnimationBuilder().makeSlidingAnimation(withDirection: .topBottom)
            gatheringBoardCollectionView.showAnimatedGradientSkeleton(usingGradient: .init(colors: [.systemGray6, .systemGray5]), animation: skeletonAnimation, transition: .none)
        }
        isLoading = false
        let startTime = DispatchTime.now().uptimeNanoseconds
        let task = Task {
            do {
                let getData = try await fetchGatheringBoardsByCategory(category: categoryId, page: pageCursor, userId: userItem .userId, refreshToken: userItem.refresh_token)
                
                if isFirstPage {
                    gatheringBoardCollectionView.stopSkeletonAnimation()
                    gatheringBoardCollectionView.hideSkeleton(reloadDataAfter: false)
                }
                
                let endTime = DispatchTime.now().uptimeNanoseconds
                let elapsedTime = endTime - startTime
                if elapsedTime <= 400_000_000 {
                    do {
                        try await Task.sleep(nanoseconds: 400_000_000 - elapsedTime)
                    } catch {
                        print("sleep nanoseconds error \(error.localizedDescription)")
                    }
                }
                
                if !isFirstPage {
                    let at = gatheringBoards.count == 0 ? 0 : gatheringBoards.count-1
                    await MainActor.run {
                        gatheringBoardCollectionView.reloadItems(at: [IndexPath(item: at, section: 0)])
                    }
                }
                
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
                            gatheringBoardCollectionView.insertItems(at: [IndexPath(item: gatheringBoards.count-1, section: 0)])
                        }
                    }
                    pageListCnt = getBoardCnt%modular
                    if pageListCnt == 0 {
                        pageCursor += 1
                    }
                }
            } catch {
                print("fetchGatheringBoardsByCategory error \(error.localizedDescription)")
            }
            isPaging = false
        }
        tasks.append(task)
    }
    
//    private func pagingBoardsByCategory(categoryId: Int) {
//        guard let userItem = try? KeychainManager.getUserItem() else { return }
//        let getBoardsByCategoryReq = GetBoardsByCategoryReq(categoryId: categoryId, cursor: pageCursor, refreshToken: userItem.refresh_token, userId: userItem.userId)
//        AlamofireManager.shared.session
//            .request(BoardRouter.readCategoryBoards(parameters: getBoardsByCategoryReq))
//            .validate(statusCode: 200..<501)
//            .responseDecodable(of: APIResponse<GetBoardsByCategoryRes>.self) { response in
//                switch response.result {
//                case .success:
//                if let value = response.value, value.httpCode == 200, let data = value.data {
//                    let totalPage = data.totalPage
//
//                    if self.pageCursor < totalPage {
//                        let getAllBoardResList = data.getAllBoardResList
//                        let getBoardCnt = getAllBoardResList.count
//                        print("pageListCnt, getBoardCnt", pageListCnt, getBoardCnt)
//                        for i in self.pageListCnt..<getBoardCnt {
//                            gatheringBoards.append(getAllBoardResList[i])
//                            gatheringBoardCollectionView.insertItems(at: [IndexPath(item: gatheringBoards.count-1, section: 0)])
//                        }
//                        self.pageListCnt = getBoardCnt%self.modular // 0
//                        if self.pageListCnt == 0 {
//                            self.pageCursor += 1
//                        }
//                    }
//                }
//                case let .failure(error):
//                    print("fetchGatheringBoardsByCategory", error)
//                }
//            }
//
//
//
//
//        do {
//            let getData = try await fetchGatheringBoardsByCategory(category: categoryId, page: pageCursor, userId: userItem .userId, refreshToken: userItem.refresh_token)
//            let totalPage = getData.totalPage
//            if pageCursor < totalPage {
//                let getAllBoardResList = getData.getAllBoardResList
//                let getBoardCnt = getAllBoardResList.count
//                print("pageListCnt, getBoardCnt", pageListCnt, getBoardCnt)
//                for i in pageListCnt..<getBoardCnt {
//                    gatheringBoards.append(getAllBoardResList[i])
//                    gatheringBoardCollectionView.insertItems(at: [IndexPath(item: gatheringBoards.count-1, section: 0)])
//                }
//                pageListCnt = getBoardCnt%modular // 0
//                if pageListCnt == 0 {
//                    pageCursor += 1
//                }
//            }
//        } catch {
//            print("fetchGatheringBoardsByCategory error \(error.localizedDescription)")
//        }
//        isPaging = false
//    }
    
    @objc private func refreshGatheringBoards() {
        if !isPaging {
            isPaging = true
            resetBoardsData(categoryId: categoryId)
            pagingBoardsByCategory(categoryId: categoryId, isFirstPage: true)
        }
        refreshControl.endRefreshing()
    }
    
    @objc func createBoardButtonTapped(_ sender: UIButton) {
        DispatchQueue.main.async {
            let GBCVC = GatheringBoardCategoryViewController()
            GBCVC.boardWithMode.mode = .create //.post
            self.navigationController?.pushViewController(GBCVC, animated: true)
        }
    }
}

extension  MainViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == gatheringBoardCollectionView && !isPaging {
            if scrollView.contentOffset.y > 86 && (scrollView.contentOffset.y > (scrollView.contentSize.height-scrollView.frame.size
                .height)) { // -500
                print("하단 스크롤링")
                print("😀Upload for up scroling", categoryId)
                isPaging = true
                isLoading = true
                let at = gatheringBoards.count == 0 ? 0 : gatheringBoards.count-1
                gatheringBoardCollectionView.reloadItems(at: [IndexPath(item: at, section: 0)])
                pagingBoardsByCategory(categoryId: categoryId, isFirstPage: false)
                print("End Bottom Load")
            }
        }
    }
}

extension MainViewController: SkeletonCollectionViewDelegate { //UICollectionViewDelegate
    
    // 카테고리 누른 후
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == categoryImageViewCollectionView {
            if categoryId != indexPath.row + 1 {
                for task in tasks {
                    task.cancel()
                }
                isPaging = true
                DispatchQueue.main.async { [weak self] in
                    if let cell = collectionView.cellForItem(at: indexPath) as? CategoryImageViewCollectionViewCell {
                        self?.selectedCell = cell
                    }
                }
                categoryId = indexPath.row + 1
                print("🎃", categoryId)
                resetBoardsData(categoryId: categoryId)
                pagingBoardsByCategory(categoryId: categoryId, isFirstPage: true)
            }
        } else {
            DispatchQueue.main.async { [weak self] in
                let boardId = self?.gatheringBoards[indexPath.row].boardID
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
            // Customize the footer view as needed
            return footerView!
        }
        return UICollectionReusableView()
//        fatalError("Unexpected element kind or section")
    }

    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> SkeletonView.ReusableCellIdentifier {
        return GatheringBoardThumbnailCollectionViewCell.identifier
    }

    func collectionSkeletonView(_ skeletonView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6 //UICollectionView.automaticNumberOfSkeletonItems
    }
    
    //UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == categoryImageViewCollectionView {
            return CategoryId.allCases.count
        } else {
            return gatheringBoards.count
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
            Task {
                let data = gatheringBoards[indexPath.row]
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
            if isLoading {
                return CGSize(width: collectionView.bounds.width, height: 50)
            }
        }
        return CGSize.zero
    }
}

