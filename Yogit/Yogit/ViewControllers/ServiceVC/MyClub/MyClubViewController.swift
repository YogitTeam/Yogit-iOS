//
//  MyClubViewController.swift
//  Yogit
//
//  Created by Junseo Park on 2022/12/12.
//

import UIKit
import Alamofire

enum MyClubType: String {
    case search = "APPLIED_CLUB", create = "OPENED_CLUB"
    
    func toString() -> String {
        return self.rawValue
    }
}

class MyClubViewController: UIViewController {

    private var createdBoards: [Board] = []
    private var searchBoards: [Board] = []
    
    private let searchMyBoardCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.register(GatheringBoardThumbnailCollectionViewCell.self, forCellWithReuseIdentifier: GatheringBoardThumbnailCollectionViewCell.identifier)
//        collectionView.layer.borderColor = UIColor.systemGray.cgColor
//        collectionView.layer.borderWidth = 1
        collectionView.backgroundColor = .systemBackground
        collectionView.isHidden = false
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    private let createMyBoardCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isHidden = true
        collectionView.register(GatheringBoardThumbnailCollectionViewCell.self, forCellWithReuseIdentifier: GatheringBoardThumbnailCollectionViewCell.identifier)
//        collectionView.layer.borderColor = UIColor.systemGray.cgColor
//        collectionView.layer.borderWidth = 1
        collectionView.backgroundColor = .systemBackground
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
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
//        self.didChangeValue(segment: self.segmentedControl)
        self.view.addSubview(segmentedControl)
        self.view.addSubview(searchMyBoardCollectionView)
        self.view.addSubview(createMyBoardCollectionView)
        searchMyBoardCollectionView.delegate = self
        searchMyBoardCollectionView.dataSource = self
        createMyBoardCollectionView.delegate = self
        createMyBoardCollectionView.dataSource = self
        // 조회한 get 요청
//        getMyBoardThumbnail(type: MyClubType.search.toString())
        configureViewComponent()
        // Do any additional setup after loading the view.
    }


    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        segmentedControl.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }
        searchMyBoardCollectionView.snp.makeConstraints { make in
            make.top.equalTo(segmentedControl.snp.bottom)
//            make.leading.equalToSuperview().inset(10)
            make.leading.trailing.bottom.equalToSuperview()
        }
        createMyBoardCollectionView.snp.makeConstraints { make in
            make.top.equalTo(segmentedControl.snp.bottom)
//            make.leading.equalToSuperview().inset(10)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        initNavigationBar()
        getMyBoardThumbnail(type: MyClubType.search.toString())
    }


    private func configureViewComponent() {
        view.backgroundColor = .systemBackground
        searchMyBoardCollectionView.tag = 0
        createMyBoardCollectionView.tag = 1
    }
    
    private func initNavigationBar() {
        self.tabBarController?.makeNaviTopLabel(title: TabBarKind.myClub.rawValue)
//        let editButton = self.tabBarController?.makeNaviTopButton(self, action: #selector(self.editButtonTapped(_:)), named: "Edit")
//        let settingButton = self.tabBarController?.makeNaviTopButton(self, action: #selector(self.settingButtonTapped(_:)), named: "Setting")
//        let spacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
//        spacer.width = 15
//        self.tabBarController?.navigationItem.rightBarButtonItems = [settingButton!, spacer, editButton!]
    }
    
    func getMyBoardThumbnail(type: String) {
        guard let userItem = try? KeychainManager.getUserItem() else { return }
        print("Type-getMyBoard", type)
        let getMyClub = GetMyClub(cursor: 0, myClubType: type, refreshToken: userItem.refresh_token, userId: userItem.userId)
        AF.request(API.BASE_URL + "boards/get/myclub",
                   method: .post,
                   parameters: getMyClub,
                   encoder: JSONParameterEncoder.default) // default set body and Content-Type HTTP header field of an encoded request is set to application/json
        .validate(statusCode: 200..<500)
        .response { response in // reponseData
            switch response.result {
            case .success:
                debugPrint(response)
                if let data = response.data {
                    do{
                        let decodedData = try JSONDecoder().decode(APIResponse<[Board]>.self, from: data)
                        guard let boardsData = decodedData.data else { return }
                        print("boardsData", boardsData)
                        DispatchQueue.main.async {
                            if type == MyClubType.search.toString() {
                                self.searchBoards = boardsData
                                print("Get searchBoards", self.searchBoards)
                                self.searchMyBoardCollectionView.reloadData()
                            }
                            else {
                                self.createdBoards = boardsData
                                print("Get createdBoards", self.createdBoards)
                                self.createMyBoardCollectionView.reloadData()
                            }
                        }
                    }
                    catch{
                        print(error.localizedDescription)
                    }
                }
            case .failure(let error):
                debugPrint(response)
                print(error)
            }
        }
    }
    
    @objc private func didChangeValue(_ sender: UISegmentedControl) {
        print("selectedSegmentIndex \(sender.selectedSegmentIndex)")
        if sender.selectedSegmentIndex == 0 {
            // 조회 get 요청
            print("MyClubType.search - segement 0")
            getMyBoardThumbnail(type: MyClubType.search.toString())
        } else {
            // 생성 get 요청
            print("MyClubType.search - segment 1")
            getMyBoardThumbnail(type: MyClubType.create.toString())
        }
        self.searchMyBoardCollectionView.isHidden = !self.searchMyBoardCollectionView.isHidden
        self.createMyBoardCollectionView.isHidden = !self.createMyBoardCollectionView.isHidden
     }

}

extension MyClubViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        print("Tapped gatherging board collectionview image")
        var boardId = Int64()
        if self.searchMyBoardCollectionView.isHidden {
            boardId = createdBoards[indexPath.row].boardID
        } else {
            boardId = searchBoards[indexPath.row].boardID
        }
    
        DispatchQueue.main.async {
            let GDBVC = GatheringDetailBoardViewController()
            GDBVC.boardWithMode.boardId = boardId
//            GDBVC.boardId = boardId
            self.navigationController?.pushViewController(GDBVC, animated: true)
        }
        
//        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
//        alert.view.tintColor = UIColor.label
//        let cancel = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
//
//        if indexPath.row < memberImages.count {
//            let delete = UIAlertAction(title: "Delete", style: .destructive) { (action) in self.deleteImage(indexPath.row)}
//            alert.addAction(delete)
//            alert.addAction(cancel)
//        } else {
//            let library = UIAlertAction(title: "Upload photo", style: .default) { (action) in self.openLibrary()}
//            let camera = UIAlertAction(title: "Take photo", style: .default) { (action) in self.openCamera()}
//            alert.addAction(library)
//            alert.addAction(camera)
//            alert.addAction(cancel)
//        }
//        DispatchQueue.main.async {
//            self.present(alert, animated: true, completion: nil)
//        }
    }
    
}

extension MyClubViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 0 {
            return searchBoards.count
        } else {
            return createdBoards.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("indexpath update \(indexPath)")
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GatheringBoardThumbnailCollectionViewCell.identifier, for: indexPath) as? GatheringBoardThumbnailCollectionViewCell else { return UICollectionViewCell() }
        if collectionView.tag == 0 {
            Task(priority: .userInitiated, operation: {
                let data = searchBoards[indexPath.row]
                await cell.configure(with: data)
            })
//            DispatchQueue.main.async(qos: .userInteractive, execute: {
//                cell.configure(with: self.searchBoards[indexPath.row])
//            })
        } else {
            Task(priority: .userInitiated, operation: {
                let data = createdBoards[indexPath.row]
                await cell.configure(with: data)
            })
//            DispatchQueue.main.async(qos: .userInteractive, execute: {
//                cell.configure(with: self.createdBoards[indexPath.row])
//            })
        }
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
        return CGSize(width: collectionView.frame.width/2-25, height: collectionView.frame.width/2-25)
    }
}



