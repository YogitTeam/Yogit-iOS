//
//  SecondSetUpUserInfoViewController.swift
//  Yogit
//
//  Created by Junseo Park on 2022/09/23.
//

import UIKit
import SnapKit
import Alamofire

class SearchGatheringBoardController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private lazy var boardButton: UIButton = {
        let button = UIButton()
//        button.setTitle("", for: .normal)
//        button.imageView?.image = UIImage(named: "imageNULL")
        button.setImage(UIImage(named: "ImageNULL")?.withTintColor(.white, renderingMode: .alwaysOriginal), for: .normal)
//        button.tintColor = .white
        button.layer.cornerRadius = 24
        button.isEnabled = true
        button.backgroundColor = UIColor(rgb: 0x3232FF, alpha: 1.0)
        button.addTarget(self, action: #selector(self.createBoardButtonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    private let refreshControl = UIRefreshControl()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
//        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .systemBackground
        // register new cell
        // self: reference the type object
        tableView.register(BoardMainCollectionTableViewCell.self, forCellReuseIdentifier: BoardMainCollectionTableViewCell.identifier)
        
        return tableView
    }()
    
    // 0, 1, 2, 3
//    private let viewModels: [BoardMainCollectionTableViewCellViewModel] = []
    
//    [
//        BoardMainCollectionTableViewCellViewModel(
//            viewModels: [
//                ThumbnailCollectionCellViewModel(name: "Red", backgroundColor: .systemRed),
//                ThumbnailCollectionCellViewModel(name: "Orange", backgroundColor: .systemOrange),
//                ThumbnailCollectionCellViewModel(name: "Yellow", backgroundColor: .systemYellow),
//                ThumbnailCollectionCellViewModel(name: "Green", backgroundColor: .systemGreen),
//                ThumbnailCollectionCellViewModel(name: "Blue", backgroundColor: .systemBlue),
//                ThumbnailCollectionCellViewModel(name: "Purple", backgroundColor: .systemPurple),
//            ]
//        ),
//        BoardMainCollectionTableViewCellViewModel(
//            viewModels: [
//                ThumbnailCollectionCellViewModel(name: "Red", backgroundColor: .systemRed),
//                ThumbnailCollectionCellViewModel(name: "Orange", backgroundColor: .systemOrange),
//                ThumbnailCollectionCellViewModel(name: "Yellow", backgroundColor: .systemYellow),
//                ThumbnailCollectionCellViewModel(name: "Green", backgroundColor: .systemGreen),
//                ThumbnailCollectionCellViewModel(name: "Blue", backgroundColor: .systemBlue),
//                ThumbnailCollectionCellViewModel(name: "Purple", backgroundColor: .systemPurple),
//            ]
//        ),
//        BoardMainCollectionTableViewCellViewModel(
//            viewModels: [
//                ThumbnailCollectionCellViewModel(name: "Red", backgroundColor: .systemRed),
//                ThumbnailCollectionCellViewModel(name: "Orange", backgroundColor: .systemOrange),
//                ThumbnailCollectionCellViewModel(name: "Yellow", backgroundColor: .systemYellow),
//                ThumbnailCollectionCellViewModel(name: "Green", backgroundColor: .systemGreen),
//                ThumbnailCollectionCellViewModel(name: "Blue", backgroundColor: .systemBlue),
//                ThumbnailCollectionCellViewModel(name: "Purple", backgroundColor: .systemPurple),
//            ]
//        )
//
//    ]
    
    private var boardAllData: [[Board]] = [[]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        view.addSubview(boardButton)
        tableView.delegate = self
        tableView.dataSource = self
        configureViewComponent()
        getBoardThumbnail()
//        NotificationCenter.default.addObserver(self, selector: #selector(didBoardDetailNotification(_:)), name: .baordDetailRefresh, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(didDeleteBoardNotification(_:)), name: .deleteBoardRefresh, object: nil)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        initNavigationBar()
//        getBoardThumbnail()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
        boardButton.snp.makeConstraints { make in
            make.width.height.equalTo(48)
            make.bottom.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
    
    private func configureViewComponent() {
        view.backgroundColor = .systemBackground
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshBoards), for: .valueChanged)

    }
    
    private func initNavigationBar() {
        self.tabBarController?.makeNaviTopLabel(title: TabBarKind.home.rawValue)
        //        if let tabController = self.parent as? UITabBarController {
        //            tabController.navigationItem.title = "My Title"
        ////            tabController.navigationController?.makeLabel(title: "Home")
        //        }
        //        self.tabBarController?.navigationItem.title = "Home"
        //        self.tabBarController?.navigationController?.navigationBar.topItem?.title = "Home"
    }
    
    
    @objc func refreshBoards() {
        self.refreshControl.endRefreshing()
        getBoardThumbnail()
    }
    
    // boardDetail 데이터 전달 및 화면 이동
//    @objc private func didBoardDetailNotification(_ notification: Notification) {
//        guard let boardDetail = notification.object as? BoardDetail else { return }
//        DispatchQueue.main.async(qos: .userInteractive, execute: {
//            let GDBVC = GatheringDetailBoardViewController()
//            GDBVC.boardWithMode.mode = .refresh
//            GDBVC.bindBoardDetail(data: boardDetail)
//            self.navigationController?.pushViewController(GDBVC, animated: true)
//            sleep(1)
//            self.getBoardThumbnail()
//        })
//    }
    
    @objc private func didDeleteBoardNotification(_ notification: Notification) {
        DispatchQueue.main.async(qos: .userInteractive, execute: {
            self.getBoardThumbnail()
        })
    }
   
    private func getBoardThumbnail() {
        guard let userItem = try? KeychainManager.getUserItem() else { return }
        let getAllBoardsReq = GetAllBoardsReq(cursor: 0, refreshToken: userItem.refresh_token, userId: userItem.userId)
        AlamofireManager.shared.session
            .request(BoardRouter.readAllBoards(parameters: getAllBoardsReq))
            .validate(statusCode: 200..<501)
            .responseDecodable(of: APIResponse<[[Board]]>.self) { response in
                switch response.result {
                case .success:
                    guard let value = response.value else { return }
                    if value.httpCode == 200 {
                        guard let data = value.data else { return }
                        DispatchQueue.global().async(qos: .userInteractive, execute: {
                            self.boardAllData = data
                            DispatchQueue.main.async(qos: .userInteractive, execute: {
                                self.tableView.reloadData()
                            })
                        })
                    }
                case let .failure(error):
                    print(error)
                }
            }
        
        
//        AF.request(API.BASE_URL + "boards/get/categories",
//                   method: .post,
//                   parameters: getAllBoardsReq,
//                   encoder: JSONParameterEncoder.default) // default set body and Content-Type HTTP header field of an encoded request is set to application/json
//        .validate(statusCode: 200..<500)
//        .response { response in // reponseData
//            switch response.result {
//            case .success:
//                debugPrint(response)
//                if let data = response.data {
//                    do{
//                        let decodedData = try JSONDecoder().decode(APIResponse<[[Board]]>.self, from: data)
//                        print(decodedData)
//                        guard let boardsData = decodedData.data else { return }
//                        self.boardAllData = boardsData
//                        print(self.boardAllData)
//                        self.tableView.reloadData()
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
    
    // Reporting the number of sections and rows in the table.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return viewModels.count
        return boardAllData.count
    }
    
    // Providing cells for each row of the table.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let viewModel = viewModels[indexPath.row]

        guard let cell = tableView.dequeueReusableCell(withIdentifier: BoardMainCollectionTableViewCell.identifier, for: indexPath) as? BoardMainCollectionTableViewCell else {
            fatalError()
        }
        cell.delegate = self // touch delegate
        cell.configure(with: self.boardAllData[indexPath.row])
        let categoryId = CategoryId(rawValue: indexPath.row + 1)
        cell.headerLabel.text = categoryId?.toString()
//        cell.delegate = self // touch delegate
//
////        cell.configure(with: viewModel)
//        cell.configure(with: boardAllData[indexPath.row])
        
        print("categoryId, categoryString \(categoryId) \(categoryId?.toString())")
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.size.width/1.34
     }
    
    @objc func createBoardButtonTapped(_ sender: UIButton) {
        
//        let objCreateEventVC = CreateEventVC()
//        objCreateEventVC.hidesBottomBarWhenPushed = true
//        self.navigationController?.pushViewController(objCreateEventVC, animated: false)
        print("boardButtonTapped")
//        DispatchQueue.main.async(execute: {
//            let GBCVC = GatheringBoardCategoryViewController()
////            GBCVC.hidesBottomBarWhenPushed = true
//            self.navigationController?.pushViewController(GBCVC, animated: true)
//        })
        DispatchQueue.main.async {
            let GBCVC = GatheringBoardCategoryViewController()
//            GBCVC.mode = .post
//            GBCVC.hidesBottomBarWhenPushed = true
            GBCVC.boardWithMode.mode = .create //.post
            self.navigationController?.pushViewController(GBCVC, animated: true)
        }
    }
    
//    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//        if (refreshControl.isRefreshing) {
//            self.refreshControl.endRefreshing()
//            getBoardThumbnail()
////            if(self.searchFlag == 0){
////                self.currentPage = 1
////                fetchData(page: self.currentPage)
////            }
////            else{
////                self.searchCurrentPage = 1
////                fetchSearchedData(category: self.category, condition: self.condition, page: self.searchCurrentPage)
////            }
//
//        }
//    }
    
    
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        print(section)
//        let categoryId = CategoryId(rawValue: section + 1)
//        return categoryId?.toString()
//    }
   

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

//extension SearchGatheringBoardController: BoardMainCollectionTableViewCellDelegate {
//    func collectionTableViewTapIteom(with viewModel: ThumbnailCollectionCellViewModel) {
//        let alert = UIAlertController(title: viewModel.name, message: "Success", preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
//        present(alert, animated: true)
//    }
//}

extension SearchGatheringBoardController: BoardMainCollectionTableViewCellDelegate {
    func collectionTableViewTapItem(with board: Board) {
        DispatchQueue.main.async {
            let GDBVC = GatheringDetailBoardViewController()
//            GDBVC.boardId = board.boardID
            GDBVC.boardWithMode.boardId = board.boardID // boardId로 요청을 때려야함
//            self.present(GDBVC, animated: true)
            self.navigationController?.pushViewController(GDBVC, animated: true)
        }
    }
}
