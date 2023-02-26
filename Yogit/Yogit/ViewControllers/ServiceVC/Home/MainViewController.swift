//
//  MainViewController.swift
//  Yogit
//
//  Created by Junseo Park on 2023/02/14.
//

import UIKit
import SnapKit
import CoreLocation

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
//    let categories: [Int] = [0,1,2,3,4,5]

    // 전체 카테고리 페이지
    // 카테고리별 페이지

    // 페이지네이션: 각 페이지마다 끝점 전체 카테고리 페이지 페이지 네이션 >> 카테고리별로 필터링
//    private let categoryImages: [UIImage] = [UIImage(named: "Language exchange")!,UIImage(named: "Language exchange")!,UIImage(named: "Language exchange")!, UIImage(named: "Language exchange")!,UIImage(named: "Language exchange")!]
    private var gatheringBoards = [[Board]]()
//    private var filteredGatheringBoards = [[Board]]()
    private var pagesCursor = [Int](repeating: 0, count: CategoryId.allCases.count)
    private var pagesListCount = [Int](repeating: 0, count: CategoryId.allCases.count)
    private var isPaging: Bool = false
    private let modular = 10
//    private var filter = Filter(fillterType: .none)

    private var categoryId: Int = 1 {
        didSet {
            Task(priority: .high, operation: {
                resetBoardsData(categoryId: categoryId)
                await pagingBoardsByCategory(categoryId: categoryId, isPaging: isPaging)
            })
        }
    }
    
    var cellHeights: [IndexPath: CGFloat] = [:]
    var selectedCell: CategoryImageViewCollectionViewCell? {
        didSet {
            DispatchQueue.main.async { [self] in
                selectedCell?.imageView.tintColor = ServiceColor.primaryColor//.label//UIColor(rgb: 0x3232FF, alpha: 1.0) //.white // .white
                selectedCell?.titleLabel.textColor = ServiceColor.primaryColor //.label//UIColor(rgb: 0x3232FF, alpha: 1.0)
                selectedCell?.backView.backgroundColor = .systemGray6//UIColor(rgb: 0xEFEFEF, alpha: 1.0) // .withAlphaComponent(0.8)
                selectedCell?.backView.layer.borderWidth = 1
                selectedCell?.backView.layer.borderColor = ServiceColor.primaryColor.cgColor
            }
        }
    }
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
    
//    private lazy var refreshControl: UIRefreshControl = {
//        let refreshControl = UIRefreshControl()
//        refreshControl.addTarget(self, action: #selector(refreshGatheringBoards), for: .valueChanged)
//        gatheringBoardCollectionView.refreshControl = refreshControl
//        return refreshControl
//    }()
//
    private(set) lazy var refreshControl: UIRefreshControl = {
        let control = UIRefreshControl()
        control.addTarget(self, action: #selector(refreshGatheringBoards), for: .valueChanged)
//        control.transform = CGAffineTransformMakeScale(0.5, 0.5)
        return control
    }()
    
    private lazy var createGatheringBoardButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "Edit")?.withTintColor(.label, renderingMode: .alwaysOriginal), for: .normal)
//        button.tintColor = .white
//        button.layer.cornerRadius = 24
        button.isEnabled = true
        button.backgroundColor = .systemGray6
        button.addTarget(self, action: #selector(self.createBoardButtonTapped(_:)), for: .touchUpInside)
        return button
    }()

    
    private let gatheringBoardCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(GatheringBoardThumbnailCollectionViewCell.self, forCellWithReuseIdentifier: GatheringBoardThumbnailCollectionViewCell.identifier)
        collectionView.backgroundColor = .systemBackground
        collectionView.showsVerticalScrollIndicator = true
        collectionView.layer.borderWidth = 1
        collectionView.layer.borderColor = UIColor.red.cgColor
//        collectionView.backgroundColor = .systemBackground
        return collectionView
    }()

    // category view
    private lazy var categoryImageViewCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.estimatedItemSize = CGSize(width: 100, height: 100)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(CategoryImageViewCollectionViewCell.self, forCellWithReuseIdentifier: CategoryImageViewCollectionViewCell.identifier)
//        collectionView.layer.borderColor = UIColor.red.cgColor
//        collectionView.layer.borderWidth = 1
//        collectionView.layer.borderWidth = 0.3
//        collectionView.backgroundColor = .systemBackground
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isHidden = true
//        collectionView.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: 100)// CGRect(origin: .zero, size: CGSize(width: view.frame.size.width, height: 100))
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
        configureViewComponent()
        initGahtheringBoards()
        configureCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initNavigationBar()
    }

    private func initNavigationBar() {
        self.tabBarController?.makeNaviTopLabel(title: TabBarKind.home.rawValue)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        categoryImageViewCollectionView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(80)
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
    
    override func viewDidAppear(_ animated: Bool) {
        let indexPath = IndexPath(item: categoryId-1, section: 0)
        guard let cell = categoryImageViewCollectionView.cellForItem(at: indexPath) as? CategoryImageViewCollectionViewCell else { return }
        selectedCell = cell
    }

    private func initGahtheringBoards() {
        for _ in 0..<CategoryId.allCases.count {
            gatheringBoards.append([])
        }
        Task(priority: .high, operation: {
            await pagingBoardsByCategory(categoryId: categoryId, isPaging: isPaging)
        })
    }

    private func configureViewComponent() {
        view.addSubview(categoryImageViewCollectionView)
        view.addSubview(gatheringBoardCollectionView)
        view.addSubview(lineView)
        view.addSubview(createGatheringBoardButton)
        view.backgroundColor = .systemBackground
    }
    
    private func configureCollectionView() {
        categoryImageViewCollectionView.tag = 0
        gatheringBoardCollectionView.tag = 1
        categoryImageViewCollectionView.delegate = self
        categoryImageViewCollectionView.dataSource = self
        gatheringBoardCollectionView.delegate = self
        gatheringBoardCollectionView.dataSource = self
        gatheringBoardCollectionView.refreshControl = refreshControl
    }

    private func resetBoardsData(categoryId: Int) {
        gatheringBoards[categoryId-1].removeAll()
        gatheringBoardCollectionView.reloadData()
        pagesListCount[categoryId-1] = 0
        pagesCursor[categoryId-1] = 0
    }
    
//    func fetchGatheringBoardsByCategory(category: Int, page: Int, userId: Int64, refreshToken: String) async throws -> GetBoardsByCategoryRes {
//        let getBoardsByCategoryReq = GetBoardsByCategoryReq(categoryId: categoryId, cursor: page, refreshToken: refreshToken, userId: userId)
//        let dataTask = AlamofireManager.shared.session.request(BoardRouter.readCategoryBoards(parameters: getBoardsByCategoryReq)).validate(statusCode: 200..<501).serializingDecodable(APIResponse<GetBoardsByCategoryRes>.self)
//        let response = await dataTask.response
//        switch response.result {
//        case .success:
//        if let value = response.value, value.httpCode == 200, let data = value.data {
//            return data
//        } else {
//            throw FetchError.badResponse
//        }
//        case let .failure(error):
//            throw FetchError.failureResponse
//        }
//    }

    func fetchGatheringBoardsByCategory(category: Int, page: Int) async -> GetBoardsByCategoryRes? {
        guard let userItem = try? KeychainManager.getUserItem() else { return nil }
        let getBoardsByCategoryReq = GetBoardsByCategoryReq(categoryId: categoryId, cursor: page, refreshToken: userItem.refresh_token, userId: userItem.userId)
        let dataTask = AlamofireManager.shared.session.request(BoardRouter.readCategoryBoards(parameters: getBoardsByCategoryReq)).validate(statusCode: 200..<501).serializingDecodable(APIResponse<GetBoardsByCategoryRes>.self)
        let response = await dataTask.response
        let value = response.value
        return value?.data
    }

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
    private func pagingBoardsByCategory(categoryId: Int, isPaging: Bool) {
        if isPaging { return }
        else { self.isPaging = true }
        let page = pagesCursor[categoryId-1]
        Task {
            let getData = await fetchGatheringBoardsByCategory(category: categoryId, page: page)
            guard let totalPage = getData?.totalPage else { return }
            if page < totalPage {
                guard let getAllBoardResList = getData?.getAllBoardResList else { return }
                let getBoardCnt = getAllBoardResList.count
                let pageListCnt = pagesListCount[categoryId-1]
                for i in pageListCnt..<getBoardCnt {
                    gatheringBoards[categoryId-1].append(getAllBoardResList[i])
                    gatheringBoardCollectionView.insertItems(at: [IndexPath(item: gatheringBoards[categoryId-1].count-1, section: 0)])
                }
                pagesListCount[categoryId-1] = getBoardCnt%modular // 0
                if pagesListCount[categoryId-1] == 0 {
                    pagesCursor[categoryId-1] += 1
                }
            }
            self.isPaging = false
        }
    }
    
    @objc func refreshGatheringBoards() {
        print("refresh")
        Task(priority: .high, operation: {
            resetBoardsData(categoryId: categoryId)
            await pagingBoardsByCategory(categoryId: categoryId, isPaging: isPaging)
            refreshControl.endRefreshing()
        })
    }
    
    @objc func createBoardButtonTapped(_ sender: UIButton) {
        DispatchQueue.main.async {
            let GBCVC = GatheringBoardCategoryViewController()
            GBCVC.boardWithMode.mode = .create //.post
            self.navigationController?.pushViewController(GBCVC, animated: true)
        }
    }
}

//extension  MainViewController: UITableViewDataSource {
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

//extension  MainViewController: UITableViewDelegate {
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

extension  MainViewController: UIScrollViewDelegate {
    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        Task(priority: .high) {
//            if scrollView.tag == 1 {
//                if (scrollView.contentOffset.y > (scrollView.contentSize.height-scrollView.frame.size
//                    .height-300)) {
//                    print("Upload for up scroling")
//                    await pagingBoardsByCategory(categoryId: categoryId, isPaging: isPaging)
//                    print("End Bottom Load")
//                }
//            }
//        }
//    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        Task(priority: .high) {
            if scrollView.tag == 1 {
                if (scrollView.contentOffset.y > (scrollView.contentSize.height-scrollView.frame.size
                    .height-300)) {
                    print("Upload for up scroling")
                    await pagingBoardsByCategory(categoryId: categoryId, isPaging: isPaging)
                    print("End Bottom Load")
                }
            }
        }
        
//        if scrollView == gatheringBoardCollectionView {
//            if (scrollView.contentOffset.y > (scrollView.contentSize.height-scrollView.frame.size
//                .height-300)) {
//                print("Upload for up scroling")
//                pagingBoardsByCategory(categoryId: categoryId, isPaging: isPaging)
//                print("End Bottom Load")
//            }
//        }
    }
}

extension  MainViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        collectionView.deselectItem(at: indexPath, animated: true)
        if collectionView.tag == 0 {
            guard let cell = collectionView.cellForItem(at: indexPath) as? CategoryImageViewCollectionViewCell else { return }
            selectedCell?.imageView.tintColor = .label
            selectedCell?.titleLabel.textColor = .label
            selectedCell?.backView.backgroundColor = .systemGray6 //.systemBackground
            selectedCell?.backView.layer.borderWidth = 1
            selectedCell?.backView.layer.borderColor = UIColor.systemGray6.cgColor
            
            //                backView.layer.borderColor = UIColor.label.cgColor
            
            //        selectedCell?.backView.layer.shadowColor = nil//UIColor.black.cgColor
            //        selectedCell?.backView.layer.shadowOffset = CGSize(width: 0, height: 0)//CGSize(width: 1, height: 1)
            //        selectedCell?.backView.layer.shadowRadius = 0
            //        selectedCell?.backView.layer.shadowOpacity = 0//0.2
            
            selectedCell = cell
            
            //        selectedCell?.imageView.tintColor = .label//UIColor(rgb: 0x3232FF, alpha: 1.0) //.white // .white
            //        selectedCell?.titleLabel.textColor = .label//UIColor(rgb: 0x3232FF, alpha: 1.0)
            //        selectedCell?.backView.backgroundColor = .systemGray6//UIColor(rgb: 0xEFEFEF, alpha: 1.0) // .withAlphaComponent(0.8)
            //        selectedCell?.backView.layer.borderWidth = 1
            //        selectedCell?.backView.layer.borderColor = UIColor.systemGray4.cgColor//UIColor(rgb: 0xDDDDDD, alpha: 1.0).cgColor
            //
            
            // 그라데이션
            //        let gradientLayer = CAGradientLayer()
            //        gradientLayer.frame = (selectedCell?.backView.bounds.integral)!
            //        gradientLayer.colors = [UIColor(red: 177, green: 50, blue: 255, alpha: 1.0).cgColor, ServiceColor.primaryColor.cgColor]
            ////        gradientLayer.locations = [0.7] // <- 추가
            //        selectedCell?.backView.layer.addSublayer(gradientLayer)
            
//                        selectedCell?.backView.layer.shadowColor = ServiceColor.primaryColor.cgColor
//                        selectedCell?.backView.layer.shadowOffset = CGSize(width: 3, height: 3)
//                        selectedCell?.backView.layer.shadowRadius = 3
//                        selectedCell?.backView.layer.shadowOpacity = 0.25
            if categoryId != indexPath.row + 1 {
                categoryId = indexPath.row + 1
                print("Tapped gatherging board collectionview", categoryId)
                //                gatheringBoards[categoryId-1].removeAll()
                //                pagesListCount[categoryId-1] = 0
                //                pagesCursor[categoryId-1] = 0
                //                await pagingBoardsByCategory(categoryId: categoryId-1, isPaging: isPaging)
            }
        } else {
            let boardId = gatheringBoards[categoryId-1][indexPath.row].boardID
            DispatchQueue.main.async {
                let GDBVC = GatheringDetailBoardViewController()
                GDBVC.boardWithMode.boardId = boardId
                self.navigationController?.pushViewController(GDBVC, animated: true)
            }
        }
    }
}

extension  MainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return 10
        if collectionView.tag == 0 {
            return CategoryId.allCases.count
        } else {
            return gatheringBoards[categoryId-1].count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("ProfileImages indexpath update \(indexPath)")
        if collectionView.tag == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryImageViewCollectionViewCell.identifier, for: indexPath) as? CategoryImageViewCollectionViewCell else { return UICollectionViewCell() }
            DispatchQueue.main.async(qos: .userInteractive, execute: { 
                cell.configure(at: indexPath.row)
            })
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GatheringBoardThumbnailCollectionViewCell.identifier, for: indexPath) as? GatheringBoardThumbnailCollectionViewCell else { return UICollectionViewCell() }
            Task(priority: .high, operation: {
                let data = gatheringBoards[categoryId-1][indexPath.row]
                await cell.configure(with: data)
            })
//
//            DispatchQueue.main.async(qos: .userInteractive, execute: { [self] in
//                cell.configure(with: gatheringBoards[categoryId-1][indexPath.row])
//            })
//
            
//            cell.layer.cornerRadius = 10
//            cell.clipsToBounds = true
//            cell.contentView.layer.shadowColor = UIColor.black.cgColor
//            cell.contentView.layer.shadowOffset = CGSize(width: 3, height: 3)
//            cell.contentView.layer.shadowRadius = 3
//            cell.contentView.layer.shadowOpacity = 0.25
//            cell.contentView.layer.cornerRadius = 6
//            cell.layoutIfNeeded()
//            cell.contentView.layer.cornerRadius = 10
//                
//                // Set the shadow properties of the cell's content view to create a shadow effect
//                cell.contentView.layer.shadowColor = UIColor.black.cgColor
//                cell.contentView.layer.shadowOpacity = 0.5
//                cell.contentView.layer.shadowOffset = CGSize(width: 0, height: 5)
//                cell.contentView.layer.shadowRadius = 5
//                
//                // Set the background color of the cell to be transparent
//            cell.backgroundColor = .systemBackground
            return cell
        }
    }
}

extension  MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
////        let size: CGFloat = imagesCollectionView.frame.size.width/2
//////        CGSize(width: size, height: size)
////
////        CGSize(width: view.frame.width / 5, height: view.frame.width / 5)
//        print("Sizing collectionView")
        if collectionView.tag == 0 {
            return CGSize(width: 54, height: 54)
        } else {
            return CGSize(width: collectionView.frame.width/2-25, height: (collectionView.frame.width/2-25)*5/4)
        }
//       let layoutAttributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
//       let size = CategoryImageViewCollectionViewCell().preferredLayoutAttributesFitting(layoutAttributes).frame.size
//       return size
    }
}

