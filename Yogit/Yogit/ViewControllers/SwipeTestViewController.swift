//
//  SwipeTestViewController.swift
//  Yogit
//
//  Created by Junseo Park on 2023/02/03.
//

import UIKit
import Alamofire

//enum SwipeTestType: String {
//    case search = "APPLIED_CLUB", create = "OPENED_CLUB"
//
//    func toString() -> String {
//        return self.rawValue
//    }
//}

//class GatheringBoardTagsViewController: UIViewController {
//
//    private var tags = [String]()
//
//    private var sss = ["titlelalalalla", "dfd", "dfdfdf", "adfdddddddddd", "1","titlelalalalla", "dfd", "dfdfdf", "adfdddddddddd", "1","titlelalalalla", "dfd", "dfdfdf", "adfdddddddddd", "1","titlelalalalla", "dfd", "dfdfdf", "adfdddddddddd", "1","titlelalalalla", "dfd", "dfdfdf", "adfdddddddddd", "1","titlelalalalla", "dfd", "dfdfdf", "adfdddddddddd", "1","titlelalalalla", "dfd", "dfdfdf", "adfdddddddddd", "1","titlelalalalla", "dfd", "dfdfdf", "adfdddddddddd", "1","titlelalalalla", "dfd", "dfdfdf", "adfdddddddddd", "1"]
//
//    private let searchMyBoardCollectionView: UICollectionView = {
//        let layout = UICollectionViewFlowLayout()
////        layout.scrollDirection = .vertical
//        layout.scrollDirection = .horizontal
////        layout.sectionInset = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
////        layout.minimumLineSpacing = 3
////        layout.minimumInteritemSpacing = 3
//           layout.sectionInset = UIEdgeInsets(top: 5, left: 2, bottom: 5, right: 2)
//        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
//
//        collectionView.register(SwipeCollectionViewCell.self, forCellWithReuseIdentifier: SwipeCollectionViewCell.identifier)
////        collectionView.layer.borderColor = UIColor.systemGray.cgColor
////        collectionView.layer.borderWidth = 1
//        collectionView.backgroundColor = .red
//        collectionView.isHidden = false
//
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
//        collectionView.register(SwipeCollectionViewCell.self, forCellWithReuseIdentifier: SwipeCollectionViewCell.identifier)
////        collectionView.layer.borderColor = UIColor.systemGray.cgColor
////        collectionView.layer.borderWidth = 1
//        collectionView.backgroundColor = .systemBackground
//        collectionView.showsHorizontalScrollIndicator = false
//        return collectionView
//    }()
//
//    private lazy var segmentedControl: UISegmentedControl = {
//        let control = UISegmentedControl(items: ["Applied Club", "Opened Club"])
//        control.addTarget(self, action: #selector(didChangeValue(_:)), for: .valueChanged)
//        control.selectedSegmentIndex = 0
////        control.backgroundColor = UIColor(rgb: 0x3232FF, alpha: 1.0)
//        control.selectedSegmentTintColor = UIColor(rgb: 0x3232FF, alpha: 1.0)
//        control.layer.cornerRadius = 30
//        control.layer.masksToBounds = true
////        control.clipsToBounds = true
//        control.translatesAutoresizingMaskIntoConstraints = false
//        return control
//    }()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
////        self.didChangeValue(segment: self.segmentedControl)
//        self.view.addSubview(segmentedControl)
//        self.view.addSubview(searchMyBoardCollectionView)
//        self.view.addSubview(createMyBoardCollectionView)
//        searchMyBoardCollectionView.delegate = self
//        searchMyBoardCollectionView.dataSource = self
//        createMyBoardCollectionView.delegate = self
//        createMyBoardCollectionView.dataSource = self
//        // 조회한 get 요청
////        getMyBoardThumbnail(type: SwipeTestType.search.toString())
//        configureViewComponent()
//        // Do any additional setup after loading the view.
//    }
//
//
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        segmentedControl.snp.makeConstraints { make in
//            make.top.equalTo(view.safeAreaLayoutGuide)
//            make.leading.trailing.equalToSuperview().inset(20)
//            make.height.equalTo(44)
//        }
//        searchMyBoardCollectionView.snp.makeConstraints { make in
//            make.top.equalTo(segmentedControl.snp.bottom)
////            make.leading.equalToSuperview().inset(10)
//            make.leading.trailing.bottom.equalToSuperview()
//        }
//        createMyBoardCollectionView.snp.makeConstraints { make in
//            make.top.equalTo(segmentedControl.snp.bottom)
////            make.leading.equalToSuperview().inset(10)
//            make.leading.trailing.bottom.equalToSuperview()
//        }
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        initNavigationBar()
////        getMyBoardThumbnail(type: SwipeTestType.search.toString())
//    }
//
//
//    private func configureViewComponent() {
//        view.backgroundColor = .systemBackground
//        searchMyBoardCollectionView.tag = 0
//        createMyBoardCollectionView.tag = 1
//    }
//
//    private func initNavigationBar() {
//        self.tabBarController?.makeNaviTopLabel(title: TabBarKind.myClub.rawValue)
////        let editButton = self.tabBarController?.makeNaviTopButton(self, action: #selector(self.editButtonTapped(_:)), named: "Edit")
////        let settingButton = self.tabBarController?.makeNaviTopButton(self, action: #selector(self.settingButtonTapped(_:)), named: "Setting")
////        let spacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
////        spacer.width = 15
////        self.tabBarController?.navigationItem.rightBarButtonItems = [settingButton!, spacer, editButton!]
//    }
//
//    func getMyBoardThumbnail(type: String) {
//        guard let userItem = try? KeychainManager.getUserItem() else { return }
//        print("Type-getMyBoard", type)
//        let getSwipeTest = GetMyClub(cursor: 0, myClubType: type, refreshToken: userItem.refresh_token, userId: userItem.userId)
//        AF.request(API.BASE_URL + "boards/get/SwipeTest",
//                   method: .post,
//                   parameters: getSwipeTest,
//                   encoder: JSONParameterEncoder.default) // default set body and Content-Type HTTP header field of an encoded request is set to application/json
//        .validate(statusCode: 200..<500)
//        .response { response in // reponseData
//            switch response.result {
//            case .success:
//                debugPrint(response)
//                if let data = response.data {
//                    do{
//                        let decodedData = try JSONDecoder().decode(APIResponse<[Board]>.self, from: data)
//                        guard let boardsData = decodedData.data else { return }
//                        print("boardsData", boardsData)
//                        DispatchQueue.main.async {
//                            if type == SwipeTestType.search.toString() {
//                                self.searchBoards = boardsData
//                                print("Get searchBoards", self.searchBoards)
//                                self.searchMyBoardCollectionView.reloadData()
//                            }
//                            else {
//                                self.createdBoards = boardsData
//                                print("Get createdBoards", self.createdBoards)
//                                self.createMyBoardCollectionView.reloadData()
//                            }
//                        }
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
//    }
//
//    @objc private func didChangeValue(_ sender: UISegmentedControl) {
//        print("selectedSegmentIndex \(sender.selectedSegmentIndex)")
//        if sender.selectedSegmentIndex == 0 {
//            // 조회 get 요청
//            print("SwipeTestType.search - segement 0")
////            getMyBoardThumbnail(type: SwipeTestType.search.toString())
//        } else {
//            // 생성 get 요청
//            print("SwipeTestType.search - segment 1")
////            getMyBoardThumbnail(type: SwipeTestType.create.toString())
//        }
//        self.searchMyBoardCollectionView.isHidden = !self.searchMyBoardCollectionView.isHidden
//        self.createMyBoardCollectionView.isHidden = !self.createMyBoardCollectionView.isHidden
//     }
//
//}

//extension SwipeTestViewController: UICollectionViewDelegate {
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        collectionView.deselectItem(at: indexPath, animated: true)
//        print("Tapped gatherging board collectionview image")
//        var boardId = Int64()
//        if self.searchMyBoardCollectionView.isHidden {
//            boardId = createdBoards[indexPath.row].boardID
//        } else {
//            boardId = searchBoards[indexPath.row].boardID
//        }
//
//        DispatchQueue.main.async {
//            let GDBVC = GatheringDetailBoardViewController()
//            GDBVC.boardWithMode.boardId = boardId
////            GDBVC.boardId = boardId
//            self.navigationController?.pushViewController(GDBVC, animated: true)
//        }
//
////        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
////        alert.view.tintColor = UIColor.label
////        let cancel = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
////
////        if indexPath.row < memberImages.count {
////            let delete = UIAlertAction(title: "Delete", style: .destructive) { (action) in self.deleteImage(indexPath.row)}
////            alert.addAction(delete)
////            alert.addAction(cancel)
////        } else {
////            let library = UIAlertAction(title: "Upload photo", style: .default) { (action) in self.openLibrary()}
////            let camera = UIAlertAction(title: "Take photo", style: .default) { (action) in self.openCamera()}
////            alert.addAction(library)
////            alert.addAction(camera)
////            alert.addAction(cancel)
////        }
////        DispatchQueue.main.async {
////            self.present(alert, animated: true, completion: nil)
////        }
//    }
//
//}
//
//extension SwipeTestViewController: UICollectionViewDataSource {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
////        if collectionView.tag == 0 {
////            return searchBoards.count
////        } else {
////            return createdBoards.count
////        }
//
//        return sss.count//30
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        print("indexpath update \(indexPath)")
//        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SwipeCollectionViewCell.identifier, for: indexPath) as? SwipeCollectionViewCell else { return UICollectionViewCell() }
////        if collectionView.tag == 0 {
////            cell.configure(with: searchBoards[indexPath.row])
////        } else {
////            print(indexPath.row)
////            cell.configure(with: createdBoards[indexPath.row])
////        }
//        cell.configure(tag: sss[indexPath.row])
//        return cell
//    }
//}
//
//extension SwipeTestViewController: UICollectionViewDelegateFlowLayout {
////    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
////
//////        let size: CGFloat = imagesCollectionView.frame.size.width/2
////////        CGSize(width: size, height: size)
//////
//////        CGSize(width: view.frame.width / 5, height: view.frame.width / 5)
////        print("Sizing collectionView")
////        collectionView.frame.size
////        return CGSize(width: collectionView.frame.width, height: collectionView.frame.width/10)
////    }
//
////    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
////        let market = self.sss[indexPath.row]
////        let label = UILabel(frame: CGRect.zero)
////        label.text =  market
////        label.sizeToFit()
////        label.adjustsFontSizeToFitWidth = true
////        return CGSize(width: label.frame.width, height: 25)
////    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//            let text = NSAttributedString(string: sss[indexPath.row])
//            return CGSize(width: text.size().width, height: 25)
//    }
//}
//
//class LeftAlignedCollectionViewFlowLayout: UICollectionViewFlowLayout {
//  override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
//    // 재정의 오버라이드 메소드 임으로 리턴값으로 layout 속성값들을 받습니다.
//    let attributes = super.layoutAttributesForElements(in: rect)
//
//    // contentView의 left 여백
//    var leftMargin = sectionInset.left
//    var maxY: CGFloat = -1.0 // cell라인의 y값의 디폴트값
//    attributes?.forEach { layoutAttribute in
//        // cell일경우
//      if layoutAttribute.representedElementCategory == .cell {
//        // 한 cell의 y 값이 이전 cell들이 들어갔더 line의 y값보다 크다면
//        // 디폴트값을 -1을 줬기 때문에 처음은 무조건 발동, x좌표 left에서 시작
//        if layoutAttribute.frame.origin.y >= maxY {
//          leftMargin = sectionInset.left
//        }
//        // cell의 x좌표에 leftMargin값 적용해주고
//        layoutAttribute.frame.origin.x = leftMargin
//        // cell의 다음값만큼 cellWidth + minimumInteritemSpacing + 해줌
//        leftMargin += layoutAttribute.frame.width + minimumInteritemSpacing
//        // cell의 위치값과 maxY변수값 중 최대값 넣어줌(라인 y축값 업데이트)
//        maxY = max(layoutAttribute.frame.maxY, maxY)
//      }
//    }
//    return attributes
//  }
//}
//
//
//
