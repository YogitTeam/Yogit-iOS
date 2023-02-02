//
//  GatheringDetailBoardViewController.swift
//  Yogit
//
//  Created by Junseo Park on 2022/12/01.

import UIKit
import SnapKit
//import Alamofire
import MapKit
import BLTNBoard

//enum bottomButtonState {
//    case join, withdrawl
//}

class GatheringDetailBoardViewController: UIViewController {

//    var boardId: Int64? {
//        didSet {
//            print("boardId \(boardId)")
//        }
//    }
    
//    private var hostId: Int64? {
//        didSet {
//            self.rightButton.isHidden = false
//        }
//    }
    
//    private var coordinate: CLLocationCoordinate2D?
    
//    private var boardImages: [UIImage] = [] {
//        didSet(oldVal){
//            DispatchQueue.main.async {
//                if self.boardImages.count >= 2 {
//                    self.boardImagesPageControl.numberOfPages = self.boardImages.count
//                }
//                self.configureScrollView()
////                if self.BoardImagesScrollView.subviews.count == 2 {
////                    self.configureScrollView()
////                }
//            }
//        }
//    }
    
    // 고쳐야 함
    var isClipBoardAlarm: Bool? = false {
        didSet {
            if isClipBoardAlarm == true { moveToClipBoard() }
        }
    }
    
    
    private var boardImages: [String] = [] {
        didSet(oldVal){
            DispatchQueue.main.async {
                if self.boardImages.count >= 2 {
                    self.boardImagesPageControl.numberOfPages = self.boardImages.count
                }
                self.configureScrollView()
            }
        }
    }
    
//    private var memberImages: [UIImage] = [] {
//        didSet {
//            self.imagesCollectionView.reloadData()
//        }
//    }
    
    private var memberImages: [String] = [] {
        didSet {
            self.imagesCollectionView.reloadData()
        }
    }
    
//    private var applyButtonState: ApplyButtonState?
    
//    private var _applyButton: Bool {
//        get {
//            return applyButton.isEnabled
//        } set(newValue) {
//            applyButton.isEnabled = newValue
//            if !applyButton.isEnabled {
//                applyButton.backgroundColor = .placeholderText
//            } else {
//                clipBoardButton.backgroundColor = .placeholderText
//            }
//        }
//    }
    
    var boardWithMode = BoardWithMode()
    
//    var boardDetail: BoardDetail?
    
    private let mapView = MKMapView()
    private let placeBoardInfoView = BoardInfoView()
    private let dateBoardInfoView = BoardInfoView()
    
    
    private lazy var bulletinManager: BLTNItemManager = {
        
        let item = BLTNPageItem(title: "Join the gathering")
        item.image = "👋".stringToImage(width: 100, height: 100)//UIImage(named: "pro1")
//        item.imageAccessibilityLabel = "👋"
//        item.descriptionLabel?.text = "Join the gathering"
        item.actionButtonTitle = "Join"
//        item.alternativeButtonTitle = "Cancel"
        item.descriptionText = "Would you want to join the gathering?"
        item.appearance.actionButtonColor = UIColor(rgb: 0x3232FF, alpha: 1.0)
//        item.appearance.alternativeButtonTitleColor = .gray
        item.actionHandler = { _ in
            self.joinBoardRequest() // 분기처리 요구됨
        }
//        item.alternativeHandler = { _ in
//            print("Tap alter ")
//        }
        return BLTNItemManager(rootItem: item)
    }()
    
    private lazy var boardImagesPageControl: UIPageControl = {
        let pageControl = UIPageControl()
        //페이지 컨트롤의 전체 페이지를 images 배열의 전체 개수 값으로 설정
        pageControl.numberOfPages = 0 // self.BoardImages.count
        // 페이지 컨트롤의 현재 페이지를 0으로 설정
        pageControl.currentPage = 0
        // 페이지 표시 색상을 밝은 회색 설정
        pageControl.pageIndicatorTintColor = .placeholderText
        // 현재 페이지 표시 색상을 검정색으로 설정
        pageControl.currentPageIndicatorTintColor = UIColor(rgb: 0x3232FF, alpha: 1.0)
        pageControl.backgroundColor = .clear
        
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        
        pageControl.addTarget(self, action: #selector(pageControlDidChange(_:)), for: .valueChanged)
//        pageControl.frame = CGRect(x: 0, y: view.frame.size.width - 20, width: view.frame.size.width, height: 10)
        return pageControl
    }()
    
    private let boardImagesScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.alwaysBounceVertical = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.isScrollEnabled = true
        scrollView.backgroundColor = .placeholderText
        scrollView.translatesAutoresizingMaskIntoConstraints = false
//        scrollView.layer.borderWidth = 1
//        scrollView.layer.borderColor = UIColor.brown.c
//        scrollView.isPagingEnabled = true
//        scrollView.backgroundColor = .gray
        
//        scrollView.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.width)
        
        scrollView.bounces = true // 경계지점에서 bounce될건지 체크 (첫 or 마지막 페이지에서 바운스 스크롤 효과 여부)
        return scrollView
    }()
    
    private lazy var boardContentScrollView: UIScrollView = {
       let scrollView = UIScrollView()
        scrollView.backgroundColor = .systemBackground
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.isScrollEnabled = true
        scrollView.addSubview(contentView)
//        scrollView.addSubview(boardImagesScrollView)
//        scrollView.addSubview(contentView)
        return scrollView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Title"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 20, weight: UIFont.Weight.semibold)
        label.numberOfLines = 0
        label.sizeToFit()
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    

    private lazy var rightButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(systemName: "ellipsis"), style: .plain, target: self, action: #selector(rightButtonPressed(_:))) //
        button.isHidden = true
        button.tintColor = UIColor.label
        return button
    }()
    
    private let footerView1: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(rgb: 0xF5F5F5, alpha: 1.0)
        return view
    }()

    private let footerView2: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(rgb: 0xF5F5F5, alpha: 1.0)
        return view
    }()
    
    private let footerView3: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(rgb: 0xF5F5F5, alpha: 1.0)
        return view
    }()
    
    private lazy var hostImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .placeholderText
//        imageView.layer.cornerRadius = 55
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
//        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.profileImageViewTapped(_:))))
        return imageView
    }()
    
    private let hostLabel: UILabel = {
        let label = UILabel()
        label.text = "Host"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 20, weight: UIFont.Weight.medium)
        label.numberOfLines = 1
        label.sizeToFit()
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private let hostNameLabel: UILabel = {
        let label = UILabel()
        label.text = "hostName"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 20, weight: UIFont.Weight.regular)
        label.numberOfLines = 1
//        label.sizeToFit()
//        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private let memberLabel: UILabel = {
        let label = UILabel()
        label.text = "Member"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 20, weight: UIFont.Weight.medium)
        label.numberOfLines = 1
        label.sizeToFit()
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private let imagesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.register(MemberImagesCollectionViewCell.self, forCellWithReuseIdentifier: MemberImagesCollectionViewCell.identifier)
//        collectionView.layer.borderColor = UIColor.systemGray.cgColor
//        collectionView.layer.borderWidth = 1
        collectionView.backgroundColor = .systemBackground
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    private let introductionLabel: UILabel = {
        let label = UILabel()
        label.text = "Gathering Introduction"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 20, weight: UIFont.Weight.medium)
        label.numberOfLines = 1
        label.sizeToFit()
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private let introductionContentLabel: UILabel = {
        let label = UILabel()
//        label.text = "Gathering IntroductionGathering IntroductionGathering IntroductionGathering IntroductionGathering IntroductionGathering Introduction"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 17, weight: UIFont.Weight.regular)
        label.numberOfLines = 0
//        label.sizeToFit()
        return label
    }()
    
    private let kindOfPersonLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Please apply this kind of person"
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 20, weight: UIFont.Weight.medium)
        label.numberOfLines = 1
//        label.sizeToFit()
//        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private let kindOfPersonContentLabel: UILabel = {
        let label = UILabel()
//        label.text = "Gathering IntroductionGathering IntroductionGathering IntroductionGathering IntroductionGathering IntroductionGathering Introduction"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 17, weight: UIFont.Weight.regular)
        label.numberOfLines = 0
        label.sizeToFit()
        return label
    }()
    
    private let mapLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Location"
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 20, weight: UIFont.Weight.medium)
        label.numberOfLines = 1
        label.sizeToFit()
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private let mapAddressLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Address"
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 17, weight: UIFont.Weight.regular)
        label.numberOfLines = 0
        label.sizeToFit()
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        
        [self.boardImagesScrollView,
         self.boardImagesPageControl,
         self.titleLabel,
         self.placeBoardInfoView,
         self.dateBoardInfoView,
         self.footerView1,
         self.hostLabel,
         self.hostImageView,
         self.hostNameLabel,
         self.memberLabel,
         self.imagesCollectionView,
         self.footerView2,
         self.introductionLabel,
         self.introductionContentLabel,
//         self.lineView,
         self.kindOfPersonLabel,
         self.kindOfPersonContentLabel,
         self.footerView3,
         self.mapLabel,
         self.mapAddressLabel,
         self.mapView].forEach { view.addSubview($0) }
        return view
    }()
    
    private let memberNumberLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Address"
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 17, weight: UIFont.Weight.regular)
        label.numberOfLines = 0
        label.sizeToFit()
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private lazy var boardBottomView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(joinBoardButton)
        view.addSubview(clipBoardButton)
        view.addSubview(withdrawalButton)
        view.addSubview(joinListJoinListButton)
        return view
    }()
    
//    private let lineView: UIView = {
//        let view = UIView()
//        view.backgroundColor = UIColor(rgb: 0xF5F5F5, alpha: 1.0)
//        view.translatesAutoresizingMaskIntoConstraints = false
//        return view
//    }()
    
    private lazy var joinBoardButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(rgb: 0x3232FF, alpha: 1.0)
//        button.setImage(UIImage(named: "Apply")?.withTintColor(.white, renderingMode: .alwaysTemplate), for: .normal)
        button.setTitle("Join", for: .normal)
//        button.setTitle("Applied", for: .disabled)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: UIFont.Weight.semibold)
        button.tintColor = .white
        button.setTitleColor(.white, for: .normal) // 이렇게 해야 적용된다!
        button.layer.cornerRadius = 8
        button.isEnabled = true
        button.isHidden = true
        button.addTarget(self, action: #selector(self.joinBoardButtonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var withdrawalButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemBackground
//        button.setImage(UIImage(named: "Apply")?.withTintColor(.white, renderingMode: .alwaysTemplate), for: .normal)
        button.setTitle("Cancel join", for: .normal)
//        button.setTitle("Applied", for: .disabled)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: UIFont.Weight.semibold)
        button.tintColor = UIColor(rgb: 0x3232FF, alpha: 1.0)
        button.setTitleColor(UIColor(rgb: 0x3232FF, alpha: 1.0), for: .normal) // 이렇게 해야 적용된다!
        button.layer.cornerRadius = 8
        button.layer.borderColor = UIColor(rgb: 0x3232FF, alpha: 1.0).cgColor
        button.layer.borderWidth = 2
        button.isEnabled = true
        button.isHidden = true
        button.addTarget(self, action: #selector(self.withdrawalButtonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var joinListJoinListButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemBackground
//        button.setImage(UIImage(named: "Apply")?.withTintColor(.white, renderingMode: .alwaysTemplate), for: .normal)
        button.setTitle("Join list", for: .normal)
//        button.setTitle("Applied", for: .disabled)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: UIFont.Weight.semibold)
        button.tintColor = UIColor(rgb: 0x3232FF, alpha: 1.0)
        button.setTitleColor(UIColor(rgb: 0x3232FF, alpha: 1.0), for: .normal) // 이렇게 해야 적용된다!
        button.layer.cornerRadius = 8
        button.layer.borderColor = UIColor(rgb: 0x3232FF, alpha: 1.0).cgColor
        button.layer.borderWidth = 2
        button.isEnabled = true
        button.isHidden = true
        button.addTarget(self, action: #selector(self.joinListJoinButtonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var clipBoardButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor(rgb: 0x3232FF, alpha: 1.0)
        button.layer.cornerRadius = 8
        button.tintColor = .white
        button.setImage(UIImage(named: "BoardClipBoard")?.withTintColor(.white, renderingMode: .alwaysTemplate), for: .normal)
        button.setTitle("Clip board", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: UIFont.Weight.semibold)
        button.setTitleColor(.white, for: .normal)
        button.isEnabled = true
        button.isHidden = true
        button.addTarget(self, action: #selector(self.clipBoardTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(boardContentScrollView)
        view.addSubview(boardBottomView)
        configureViewComponent()
        configureInteractionInfoComponent()
        boardImagesScrollView.delegate = self
        imagesCollectionView.delegate = self
        imagesCollectionView.dataSource = self
        mapView.delegate = self
        setViewWithMode(mode: boardWithMode.mode)
        
        // navigation back button change
//        let backButton = UIBarButtonItem(title: "Custom", style: .Plain, target: self, action: nil    )
//        //backButton.image = UIImage(named: "imageName") //Replaces title
//        backButton.setBackgroundImage(UIImage(named: "imageName"), forState: .Normal, barMetrics: .Default) // Stretches image
//        navigationItem.setLeftBarButtonItem(backButton, animated: false)
    }
    
    private func configureViewComponent() {
        self.view.backgroundColor = .systemBackground
        self.navigationItem.rightBarButtonItem = self.rightButton
    }
    
    private func setViewWithMode(mode: Mode?) {
        if mode == .refresh {
            DispatchQueue.main.async(qos: .userInteractive, execute: { [self] in
                viewBinding(data: boardWithMode)
            })
        } else {
            getBoardDetail()
        }
    }
    
    func configureInteractionInfoComponent() {
        self.placeBoardInfoView.infoLabel.text = "Place infoLabel"
        self.placeBoardInfoView.leftImageView.image = UIImage(named: "BoardPlace")?.withTintColor(.placeholderText, renderingMode: .alwaysOriginal)
        self.placeBoardInfoView.rightImageView.image = UIImage(named: "push")?.withTintColor(.placeholderText, renderingMode: .alwaysOriginal)
        self.dateBoardInfoView.infoLabel.text = "Date infoLabel"
        self.dateBoardInfoView.leftImageView.image = UIImage(named: "BoardDate")?.withTintColor(.placeholderText, renderingMode: .alwaysOriginal)
        self.placeBoardInfoView.isUserInteractionEnabled = true
        self.placeBoardInfoView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.copyAddressTapped(_:))))
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        boardContentScrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
//        contentView.frame = CGRect(x: 0, y: boardContentScrollView.bounds.minY, width: view.frame.size.width, height: contentView.frame.size.width)
        contentView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.centerX.bottom.equalToSuperview()
//            $0.top.equalTo(boardContentScrollView.bounds.minY)
            $0.top.equalToSuperview()
        }
        boardImagesScrollView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(view.frame.size.width * 2/3)
//            $0.bottom.equalToSuperview()
        }
        boardImagesPageControl.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(boardImagesScrollView.snp.bottom).inset(10)
            $0.height.equalTo(10)
        }
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(boardImagesScrollView.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        placeBoardInfoView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(54)
        }
        dateBoardInfoView.snp.makeConstraints {
            $0.top.equalTo(placeBoardInfoView.snp.bottom)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(54)
        }
        footerView1.snp.makeConstraints {
            $0.top.equalTo(dateBoardInfoView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(6)
        }
        hostLabel.snp.makeConstraints {
            $0.top.equalTo(footerView1.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        hostImageView.snp.makeConstraints {
            $0.top.equalTo(hostLabel.snp.bottom).offset(10)
            $0.leading.equalToSuperview().inset(20)
            $0.width.height.equalTo(48)
        }
        hostImageView.layer.cornerRadius = 22
        
        hostNameLabel.snp.makeConstraints {
//            $0.top.equalTo(hostLabel.snp.bottom).offset(10)
            $0.centerY.equalTo(hostImageView)
            $0.leading.equalTo(hostImageView.snp.trailing).offset(10)
            $0.trailing.equalToSuperview().inset(20)
        }
        memberLabel.snp.makeConstraints {
            $0.top.equalTo(hostImageView.snp.bottom).offset(22)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        imagesCollectionView.snp.makeConstraints {
            $0.top.equalTo(memberLabel.snp.bottom).offset(0)
            $0.leading.trailing.equalToSuperview().inset(10)
            $0.height.equalTo(68)
        }
        footerView2.snp.makeConstraints {
            $0.top.equalTo(imagesCollectionView.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(6)
        }
        introductionLabel.snp.makeConstraints {
            $0.top.equalTo(footerView2.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        introductionContentLabel.snp.makeConstraints {
            $0.top.equalTo(introductionLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
//        lineView.snp.makeConstraints {
//            $0.top.equalTo(introductionContentLabel.snp.bottom).offset(15)
//            $0.height.equalTo(1)
//            $0.leading.trailing.equalToSuperview().inset(20)
//        }
//        introductionContentLabel.layer.addBorderWithMargin(arr_edge: [.bottom], marginLeft: 20, marginRight: 20, color: UIColor(rgb: 0xF5F5F5, alpha: 1.0), width: 1, marginTop: 10)
        kindOfPersonLabel.snp.makeConstraints {
            $0.top.equalTo(introductionContentLabel.snp.bottom).offset(21)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        kindOfPersonContentLabel.snp.makeConstraints {
            $0.top.equalTo(kindOfPersonLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        footerView3.snp.makeConstraints {
            $0.top.equalTo(kindOfPersonContentLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(6)
        }
        mapLabel.snp.makeConstraints {
            $0.top.equalTo(footerView3.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        mapAddressLabel.snp.makeConstraints {
            $0.top.equalTo(mapLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        mapView.snp.makeConstraints {
            $0.top.equalTo(mapAddressLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(200)
            $0.bottom.equalToSuperview().inset(80)
        }
        mapView.layer.cornerRadius = 6
        boardBottomView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(100)
            $0.bottom.equalToSuperview()
        }
        joinBoardButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(30)
            $0.height.equalTo(50)
        }
        withdrawalButton.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.width.equalTo((view.frame.width-60)/2)
            $0.bottom.equalToSuperview().inset(30)
            $0.height.equalTo(50)
        }
        joinListJoinListButton.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.width.equalTo((view.frame.width-60)/2)
            $0.bottom.equalToSuperview().inset(30)
            $0.height.equalTo(50)
        }
//        clipBoardButton.snp.makeConstraints {
//            $0.trailing.equalToSuperview().inset(20)
//            $0.bottom.equalToSuperview().inset(30)
//            $0.height.equalTo(50)
//            $0.width.equalTo((view.frame.width-60)/2)
//        }
//        placeBoardInfoView.addToViewBottomBorderWithColor(color: UIColor(rgb: 0xF5F5F5, alpha: 1.0), width: 1)
        placeBoardInfoView.layer.addBorderWithMargin(arr_edge: [.bottom], marginLeft: 0, marginRight: 0, color: UIColor(rgb: 0xF5F5F5, alpha: 1.0), width: 1, marginTop: 0)
        memberLabel.layer.addBorderWithMargin(arr_edge: [.top], marginLeft: 0, marginRight: 0, color: UIColor(rgb: 0xF5F5F5, alpha: 1.0), width: 1, marginTop: 10)
//        introductionContentLabel.layoutIfNeeded()
        kindOfPersonLabel.layer.addBorderWithMargin(arr_edge: [.top], marginLeft: 0, marginRight: 0, color: UIColor(rgb: 0xF5F5F5, alpha: 1.0), width: 1, marginTop: 10)
    }
    
    @objc func joinBoardButtonTapped(_ sender: UIButton) {
        bulletinManager.showBulletin(above: self)
//        guard let userItem = try? KeychainManager.getUserItem() else { return }
//
//
//        if userItem.userId != boardWithMode.hostId { // hostId
//            let alert = UIAlertController(title: "Join", message: "Would you like to join the gathering?", preferredStyle: .alert)
//            let cancel = UIAlertAction(title: "Cancel", style: .cancel)
//            let ok = UIAlertAction(title: "OK", style: .default) { (ok) in
//                self.joinBoardRequest()
//            }
//            alert.addAction(cancel)
//            alert.addAction(ok)
//            DispatchQueue.main.async {
//                self.present(alert, animated: true, completion: nil)
//            }
//        }
    }
    
    @objc func withdrawalButtonTapped(_ sender: UIButton) {
//        guard let userItem = try? KeychainManager.getUserItem() else { return }
//        if userItem.userId != boardWithMode.hostId { // hostId
//            let alert = UIAlertController(title: "Withdrawal", message: "Are you sure you want to withdraw the gathering?", preferredStyle: .alert)
//            let cancel = UIAlertAction(title: "Cancel", style: .cancel)
//            let ok = UIAlertAction(title: "OK", style: .destructive) { (ok) in
//                self.withdrawalBoardRequest()
//            }
//            alert.addAction(cancel)
//            alert.addAction(ok)
//            DispatchQueue.main.async {
//                self.present(alert, animated: true, completion: nil)
//            }
//        }
    }
    
    @objc func joinListJoinButtonTapped(_ sender: UIButton) {
        // 대기 리스트
    }
    
    func joinBoardRequest() {
        guard let userItem = try? KeychainManager.getUserItem() else { return }
//        guard let boardId = boardId else { return }
        guard let boardId = boardWithMode.boardId else { return }
        let boardUserReq = BoardUserReq(boardId: boardId, refreshToken: userItem.refresh_token, userId: userItem.userId)
        AlamofireManager.shared.session
            .request(BoardUserRouter.joinGatheringBoard(parameters: boardUserReq))
            .validate(statusCode: 200..<501)
            .responseDecodable(of: APIResponse<BoardUserRes>.self) { response in // 서버 반영 필요
                switch response.result {
                case .success:
                    guard let value = response.value else { return }
                    if value.httpCode == 200 {
                        self.bulletinManager.dismissBulletin(animated: true)
                    }
                case let .failure(error):
                    print(error)
                }
            }
        
        
//        AF.request(API.BASE_URL + "boardusers",
//                   method: .post,
//                   parameters: getAllBoardsReq,
//                   encoder: JSONParameterEncoder.default) // default set body and Content-Type HTTP header field of an encoded request is set to application/json
//        .validate(statusCode: 200..<500)
//        .response { response in // reponseData
//            switch response.result {
//            case .success:
//                debugPrint(response)
//                self.applyButton.isEnabled = false
//                self.applyButton.backgroundColor = .placeholderText
//            case .failure(let error):
//                debugPrint(response)
//                print(error)
//            }
//        }
    }
    
    func withdrawalBoardRequest() {
        guard let userItem = try? KeychainManager.getUserItem() else { return }
//        guard let boardId = boardId else { return }
        guard let boardId = boardWithMode.boardId else { return }
        let boardUserReq = BoardUserReq(boardId: boardId, refreshToken: userItem.refresh_token, userId: userItem.userId)
        AlamofireManager.shared.session
            .request(BoardUserRouter.withdrawalGatheringBoard(parameters: boardUserReq))
            .validate(statusCode: 200..<501)
            .responseDecodable(of: APIResponse<BoardUserRes>.self) { response in // 서버 반영 필요
                switch response.result {
                case .success:
                    guard let value = response.value else { return }
                    if value.httpCode == 200 {
                       
                    }
                case let .failure(error):
                    print(error)
                }
            }
        
        
//        AF.request(API.BASE_URL + "boardusers",
//                   method: .post,
//                   parameters: getAllBoardsReq,
//                   encoder: JSONParameterEncoder.default) // default set body and Content-Type HTTP header field of an encoded request is set to application/json
//        .validate(statusCode: 200..<500)
//        .response { response in // reponseData
//            switch response.result {
//            case .success:
//                debugPrint(response)
//                self.applyButton.isEnabled = false
//                self.applyButton.backgroundColor = .placeholderText
//            case .failure(let error):
//                debugPrint(response)
//                print(error)
//            }
//        }
    }
    
    @objc func clipBoardTapped(_ sender: UITapGestureRecognizer) {
        print("clipBoardTapped")
        moveToClipBoard()
    }
    
    func moveToClipBoard() {
        DispatchQueue.main.async {
//            guard let userItem = try? KeychainManager.getUserItem() else { return }
//            guard let displayName = userItem.userName else { return }
            let CBVC = ClipBoardViewController2() // ClipBoardViewController() currentUser: Sender(senderId: "\(userItem.userId)", displayName: displayName)
            CBVC.boardId = self.boardWithMode.boardId //self.boardId
            self.navigationController?.pushViewController(CBVC, animated: true)
        }
    }
    // https://www.google.com/maps/place/서울특별시+광진구+능동로+209+세종대학교/@37.5518018,127.0736345,17z/data=!4m6!3m5!1s0x357ca4d0720eecc1:0x1a7ad975c6b5e4eb!8m2!3d37.5518018!4d127.0736345!16s%2Fm%2F0ddhhlj?hl=ko
    @objc func copyAddressTapped(_ sender: UITapGestureRecognizer) {
        print("searchPlaceTapped")
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
//        alert.view.tintColor = UIColor.label
        guard let latitude = self.boardWithMode.latitude else { return }
        guard let longitude = self.boardWithMode.longitute else { return }
        let zoom = 15
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let copy = UIAlertAction(title: "Copy", style: .default) { (action) in
            guard let address = self.boardWithMode.address else { return }
            UIPasteboard.general.string = address
        }
        // 애플맵은 앱에서만 작동
        let appleMap = UIAlertAction(title: "Apple Map", style: .default) { (action) in
            guard let appUrl = URL(string:"maps://?q=\(latitude),\(longitude)") else { return }
            UIApplication.shared.open(appUrl, options: [:], completionHandler: nil)
        }
        let googleMap = UIAlertAction(title: "Google Map", style: .default) { (action) in
//            guard let url = URL(string: "comgooglemaps://?q=세종대학교&center=\(latitude),\(longitude)") else { return }
//            UIApplication.shared.open(url, options: [:], completionHandler: nil)
            guard let address = self.boardWithMode.address else { return }
            let allowedCharacterSet = CharacterSet.urlQueryAllowed
            let encodedString = address.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet)
            if UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!) {
                guard let appUrl = URL(string: "comgooglemaps://?q=\(encodedString ?? "")&center=\(latitude),\(longitude)&zoom=\(zoom)") else { return } // 좌표에 핀찍기
                UIApplication.shared.open(appUrl, options: [:], completionHandler: nil)
            } else {
                guard let webUrl = URL(string: "https://www.google.com/maps/search/?api=1&query=\(encodedString ?? "")&center=\(latitude),\(longitude)&z=\(zoom)") else { return }
                UIApplication.shared.open(webUrl, options: [:], completionHandler: nil)
            }
        }
        // 카카오맵은 앱에서만 작동
        let kakaoMap = UIAlertAction(title: "Kakao Map", style: .default) { (action) in
            if UIApplication.shared.canOpenURL(URL(string:"kakaomap://")!){
                guard let appUrl = URL(string:"kakaomap://look?p=\(latitude),\(longitude)") else { return }
                UIApplication.shared.open(appUrl, options: [:], completionHandler: nil)
            } else {
                guard let webUrl =  URL(string:"https://map.kakao.com/?q=\(latitude),\(longitude)") else { return }
                UIApplication.shared.open(webUrl, options: [:], completionHandler: nil)
                print("can't use kakao map")
            }
        }
        alert.addAction(cancel)
        alert.addAction(copy)
        alert.addAction(kakaoMap)
        alert.addAction(googleMap)
        alert.addAction(appleMap)
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
//        guard let boardInfoView = sender.view as? BoardInfoView else { return }
//        UIPasteboard.general.string = boardInfoView.infoLabel.text // 텍스트가 복사됨
    }
    
    @objc private func pageControlDidChange(_ sender: UIPageControl) {
        let current = sender.currentPage
        boardImagesScrollView.setContentOffset(CGPoint(x: CGFloat(current) * boardImagesScrollView.frame.size.width, y: 0), animated: true)
    }
    
    @objc private func rightButtonPressed(_ sender: Any) {
        // bottom view
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.view.tintColor = UIColor.label
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        guard let userItem = try? KeychainManager.getUserItem() else { return }
        if userItem.userId != boardWithMode.hostId { // hostId
            let report = UIAlertAction(title: "Report", style: .default) { (action) in self.reportAlert() }
            alert.addAction(report)
        } else {
            let edit = UIAlertAction(title: "Edit", style: .default) { (action) in self.editBoard() }
            let delete = UIAlertAction(title: "Delete", style: .default) { (action) in self.deleteAlert() }
            alert.addAction(edit)
            alert.addAction(delete)
        }
        alert.addAction(cancel)
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func reportAlert() {
        let alert = UIAlertController(title: "Report", message: "Please enter the reason for reporting", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Reason for report"
        }
        let cancel = UIAlertAction(title: "cancel", style: .cancel)
        let ok = UIAlertAction(title: "OK", style: .default) { (ok) in
            guard let content = alert.textFields?[0].text else { return }
            self.reportBoard(content: content)
        }
        alert.addAction(cancel)
        alert.addAction(ok)
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func deleteAlert() {
        let alert = UIAlertController(title: "Delete", message: "Would you want to delete a board?", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "cancel", style: .cancel)
        let ok = UIAlertAction(title: "OK", style: .default) { (ok) in
            self.deleteBoard()
        }
        alert.addAction(cancel)
        alert.addAction(ok)
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func editBoard() {
        DispatchQueue.main.async(qos: .userInteractive, execute: { [self] in
            let GBCVC = GatheringBoardCategoryViewController()
            boardWithMode.mode = .edit
//            boardWithMode.hostId = hostId
            boardWithMode.title = titleLabel.text
            boardWithMode.address = placeBoardInfoView.infoLabel.text
            boardWithMode.addressDetail = placeBoardInfoView.subInfoLabel.text
//            boardWithMode.longitute = coordinate?.longitude
//            boardWithMode.latitude = coordinate?.latitude
            boardWithMode.introduction = introductionContentLabel.text
            boardWithMode.kindOfPerson = kindOfPersonContentLabel.text
//            boardWithMode.boardId = boardId
            boardWithMode.downloadImages = boardImages
            GBCVC.categoryId = (boardWithMode.categoryId ?? 0) - 1
            GBCVC.boardWithMode = self.boardWithMode
            self.navigationController?.pushViewController(GBCVC, animated: true)
        })
    }
    
    func deleteBoard() {
        guard let userItem = try? KeychainManager.getUserItem() else { return }
//        guard let boardId = boardId else { return }
        guard let hostId = boardWithMode.hostId else { return }
        guard let boardId = boardWithMode.boardId else { return }
        let deleteBoardReq = DeleteBoardReq(boardId: boardId, refreshToken: userItem.refresh_token, hostId: hostId) // hostId
        AlamofireManager.shared.session
            .request(BoardRouter.deleteBoard(parameters: deleteBoardReq))
            .validate(statusCode: 200..<501)
            .responseDecodable(of: APIResponse<BoardDetail>.self) { response in // 서버 반영 필요
                switch response.result {
                case .success:
                    guard let value = response.value else { return }
                    if value.httpCode == 200 {
                        DispatchQueue.main.async(qos: .userInteractive, execute: { [self] in
//                            NotificationCenter.default.post(name: NSNotification.Name("DeleteBoardRefresh"), object: nil) // 홈화면 전달 하지만 다른 화면일때도 전달 해야함
                            self.navigationController?.popViewController(animated: true)
                        })
                    }
                case let .failure(error):
                    print(error)
                }
            }
        
        
        
//        AF.request(API.BASE_URL + "boards/status",
//                   method: .patch,
//                   parameters: deleteBoardReq,
//                   encoder: JSONParameterEncoder.default) // default set body and Content-Type HTTP header field of an encoded request is set to application/json
//        .validate(statusCode: 200..<500)
//        .response { response in // reponseData
//            switch response.result {
//            case .success:
//                debugPrint(response)
//                if let data = response.data {
//                    DispatchQueue.main.async {
//                        self.navigationController?.popViewController(animated: true)
//                    }
//                }
//            case .failure(let error):
//                debugPrint(response)
//                print(error)
//            }
//        }
        
    }
    
    func reportBoard(content: String) {
        guard let userItem = try? KeychainManager.getUserItem() else { return }
//        guard let hostId = hostId else { return }
        guard let hostId = boardWithMode.hostId else { return }
//        guard let boardId = boardId else { return }
        guard let boardId = boardWithMode.boardId else { return }
        let boardReport = BoardReport(content: content, refreshToken: userItem.refresh_token, reportType: "PORNOGRAPHY", reportedBoardID: boardId, reportedUserID: hostId, reportingUserID: userItem.userId)
        
        AlamofireManager.shared.session
            .request(ReportRouter.reportBoard(parameters: boardReport))
            .validate(statusCode: 200..<501)
            .responseDecodable(of: APIResponse<[String:Int64]>.self) { response in // 서버 반영 필요
                switch response.result {
                case .success:
                    guard let value = response.value else { return }
                    if value.httpCode == 200 {
                        print("Success - Report Board")
                    }
                case let .failure(error):
                    print(error)
                }
            }
        
//        AF.request(API.BASE_URL + "boardreports",
//                   method: .post,
//                   parameters: boardReport,
//                   encoder: JSONParameterEncoder.default) // default set body and Content-Type HTTP header field of an encoded request is set to application/json
//        .validate(statusCode: 200..<500)
//        .response { response in // reponseData
//            switch response.result {
//            case .success:
//                debugPrint(response)
//            case .failure(let error):
//                debugPrint(response)
//                print(error)
//            }
//        }
    }
    
    private func configureScrollView() {
//        self.boardImagesScrollView.contentSize.width = UIScreen.main.bounds.width * CGFloat(boardImages.count)
        // CGSize(width: UIScreen.main.bounds.width * CGFloat(boardImages.count))
        DispatchQueue.main.async(qos: .userInteractive, execute: {
            self.boardImagesScrollView.isPagingEnabled = true
            for x in 0..<self.boardImages.count {
                print("configure")
                let imageView = UIImageView(frame: CGRect(x: CGFloat(x) * self.boardImagesScrollView.frame.width, y: self.boardImagesScrollView.bounds.minY, width: self.boardImagesScrollView.frame.width, height: self.boardImagesScrollView.frame.width*2/3))
    //            self.boardImagesScrollView.bounds.minY
                self.boardImagesScrollView.contentSize.width = imageView.frame.width * CGFloat(self.boardImages.count)
                    imageView.backgroundColor = .systemGray
                print(self.boardImages[x].size)
                imageView.clipsToBounds = true
                imageView.contentMode = .scaleAspectFill
//                imageView.image = self.boardImages[x]
                imageView.setImage(with: self.boardImages[x])
                self.boardImagesScrollView.addSubview(imageView)
            }
        })
    }
    
//    func getBoardDetail() {
//        guard let userItem = try? KeychainManager.getUserItem() else { return }
//        guard let boardId = boardId else { return }
//        let getBoardDetailReq = GetBoardDetail(boardId: boardId, refreshToken: userItem.refresh_token, userId: userItem.userId)
//        AF.request(API.BASE_URL + "boards/get/detail",
//                   method: .post,
//                   parameters: getBoardDetailReq,
//                   encoder: JSONParameterEncoder.default) // default set body and Content-Type HTTP header field of an encoded request is set to application/json
//        .validate(statusCode: 200..<500)
//        .responseData { response in
//            switch response.result {
//            case .success:
//                debugPrint(response)
//                guard let data = response.value else { return }
//                do{
//                    let decodedData = try JSONDecoder().decode(APIResponse<BoardDetail>.self, from: data)
//                    guard let myData = decodedData.data else { return }
//                    print("APIResponse<BoardDetail>", myData)
//
//
//
//
//
//
//                    var boardImages: [UIImage] = []
//                    var hostImage: UIImage?
//                    var memberImages: [UIImage] = []
//                    DispatchQueue.global().async {
//                        for imageUrl in myData.imageUrls {
//                            imageUrl.urlToImage { (image) in
//                                guard let image = image else {
//                                    print("imageUrls can't read")
//                                    return
//                                }
//                                boardImages.append(image)
//                            }
//                        }
//                        myData.profileImgUrl.urlToImage { (image) in
//                            guard let image = image else {
//                                print("profileImgUrl can't read")
//                                return
//                            }
//                            hostImage = image
//                        }
//                        if let userImages = myData.userImageUrls {
//                            for userImage in userImages {
//                                userImage.urlToImage { (image) in
//                                    guard let image = image else {
//                                        print("imageUrls can't read")
//                                        return
//                                    }
//                                    memberImages.append(image)
//                                }
//                            }
//                        }
////                        memberImages.append(UIImage(named: "user2")!)
////                        memberImages.append(UIImage(named: "user1")!)
////                        memberImages.append(UIImage(named: "user3")!)
//                        print("print(memberImages)", memberImages)
//                        DispatchQueue.main.async() {
//                            self.boardImages = boardImages
//                            self.memberImages = memberImages
//                            self.hostImageView.image = hostImage
//                            self.titleLabel.text = myData.title
//                            self.placeBoardInfoView.infoLabel.text = myData.address
//                            self.placeBoardInfoView.subInfoLabel.text = myData.addressDetail
//                            self.dateBoardInfoView.infoLabel.text = myData.date.stringToDate()?.dateToStringUser() //?.dateToString()
//                            self.hostNameLabel.text = myData.hostName
//                            self.hostId = myData.hostId
//                            self.memberLabel.text = "\(self.memberLabel.text ?? "") (\(myData.currentMember)/\(myData.totalMember))"
//                            self.introductionContentLabel.text = myData.introduction
//                            self.kindOfPersonContentLabel.text = myData.kindOfPerson
//                            self.mapAddressLabel.text = myData.address
//                            let coordinate = CLLocationCoordinate2D(latitude: 37.5510763, longitude: 127.075836)
//                            self.moveLocation(latitudeValue: coordinate.latitude, longtudeValue: coordinate
//                                .longitude, delta: 0.01)
//                            self.setAnnotation(latitudeValue: coordinate.latitude, longitudeValue: coordinate.longitude, delta: 0.01, title: "", subtitle: myData.address)
//                        }
//                    }
//                }
//                catch{
//                    print("catch can't read")
//                    print(error.localizedDescription)
//                }
//            case let .failure(error):
//                print(error)
//            }
//        }
//    }
    
    func bindBoardDetail(data: BoardDetail) {
        // boardDetail로 화면 뿌려줌 & boardWithMode 저장
        boardWithMode.hostId = data.hostId // hostId로 신고 설정
        boardWithMode.boardId = data.boardId // boardId로 BoardDetail API 요청
        boardWithMode.currentMember = data.currentMember
        boardWithMode.memberImages = data.userImageUrls
        boardWithMode.hostName = data.hostName
        boardWithMode.hostImage = data.profileImgUrl
        boardWithMode.title = data.title
        boardWithMode.address = data.address
        boardWithMode.addressDetail = data.addressDetail
        boardWithMode.introduction = data.introduction
        boardWithMode.kindOfPerson = data.kindOfPerson
        boardWithMode.downloadImages = data.imageUrls
        boardWithMode.categoryId = data.categoryId
        boardWithMode.notice = data.notice
        boardWithMode.cityName = data.cityName
        boardWithMode.totalMember = data.totalMember
        boardWithMode.imageIds = data.imageIds
        boardWithMode.date = data.date
        boardWithMode.latitude = data.latitude
        boardWithMode.longitute = data.longitute
        boardWithMode.isJoinedUser = data.isJoinedUser
    }
    
    func viewBinding(data: BoardWithMode) {
        boardImages = data.downloadImages
        memberImages = data.memberImages!
        hostImageView.setImage(with: data.hostImage!)
        titleLabel.text = data.title
        placeBoardInfoView.infoLabel.text = data.address
        placeBoardInfoView.subInfoLabel.text = data.addressDetail
        dateBoardInfoView.infoLabel.text = data.date?.stringToDate()?.dateToStringUser() //?.dateToString()
        hostNameLabel.text = data.hostName
        memberLabel.text = "\(memberLabel.text ?? "") (\(data.currentMember ?? 0)/\(data.totalMember ?? 1))"
        introductionContentLabel.text = data.introduction
        kindOfPersonContentLabel.text = data.kindOfPerson
        mapAddressLabel.text = data.address
        moveLocation(latitudeValue: data.latitude!, longtudeValue: data.longitute!, delta: 0.01)
        setAnnotation(latitudeValue: data.latitude!, longitudeValue: data.longitute!, delta: 0.01, title: "", subtitle: data.address!)
        mapView.isUserInteractionEnabled = false
        rightButton.isHidden = false
        joinBoardButton.isHidden = data.isJoinedUser
        guard let userItem = try? KeychainManager.getUserItem() else { return }
        if boardWithMode.hostId == userItem.userId {
            clipBoardButton.snp.makeConstraints {
                $0.trailing.equalToSuperview().inset(20)
                $0.bottom.equalToSuperview().inset(30)
                $0.height.equalTo(50)
                $0.width.equalTo((view.frame.width-60)/2)
            }
            joinListJoinListButton.isHidden = !joinBoardButton.isHidden
        } else {
            clipBoardButton.snp.makeConstraints {
                $0.trailing.equalToSuperview().inset(20)
                $0.bottom.equalToSuperview().inset(30)
                $0.height.equalTo(50)
                $0.width.equalTo((view.frame.width-60)/2)
            }
            withdrawalButton.isHidden = !joinBoardButton.isHidden
        }
        clipBoardButton.isHidden = !joinBoardButton.isHidden
        // 신청 버튼 (신청 / 취소)
//        _applyButton = !data.isJoinedUser
    }
    
    func getBoardDetail() {
        // boardWithMode 미리 정해짐 (read/refresh)
         guard let userItem = try? KeychainManager.getUserItem() else { return }
//        guard let boardId = boardId else {
//            print("getBoardDetail - boardId is nil")
//            return
//        }
        guard let boardId = boardWithMode.boardId else {
            print("getBoardDetail - boardId is nil")
            return
        }
        let getBoardDetailReq = GetBoardDetail(boardId: boardId, refreshToken: userItem.refresh_token, userId: userItem.userId)
        AlamofireManager.shared.session
            .request(BoardRouter.readBoardDetail(parameters: getBoardDetailReq))
            .validate(statusCode: 200..<501)
            .responseDecodable(of: APIResponse<BoardDetail>.self) { response in
                switch response.result {
                case .success:
                    guard let value = response.value else { return }
                    if value.httpCode == 200 {
                        guard let data = value.data else { return }
                        DispatchQueue.global().async(qos: .userInteractive, execute: {
                            self.bindBoardDetail(data: data)
                            DispatchQueue.main.async(qos: .userInteractive, execute: { [self] in
                                viewBinding(data: boardWithMode)
    //                        boardImages = data.imageUrls
    //                        memberImages = data.userImageUrls // boardWithMode에 불필요
    //                        hostImageView.setImage(with: data.profileImgUrl)
    //                        titleLabel.text = data.title
    //                        placeBoardInfoView.infoLabel.text = data.address
    //                        placeBoardInfoView.subInfoLabel.text = boardWithMode.addressDetail
    //                        dateBoardInfoView.infoLabel.text = data.date.stringToDate()?.dateToStringUser() //?.dateToString()
    //                        hostNameLabel.text = data.hostName
    ////                        hostId = data.hostId
    //                        memberLabel.text = "\(memberLabel.text ?? "") (\(data.currentMember)/\(data.totalMember))"
    //                        introductionContentLabel.text = data.introduction
    //                        kindOfPersonContentLabel.text = data.kindOfPerson
    //                        mapAddressLabel.text = data.address
    //                        moveLocation(latitudeValue: data.latitude, longtudeValue: data.longitute, delta: 0.01)
    //                        setAnnotation(latitudeValue: data.latitude, longitudeValue: data.longitute, delta: 0.01, title: "", subtitle: data.address)
    //                        boardWithMode.hostId = data.hostId
    //                        boardWithMode.boardId = data.boardId
    //                        rightButton.isHidden = false
    //                        boardWithMode.categoryId = data.categoryId
    //                        boardWithMode.notice = data.notice
    //                        boardWithMode.cityName = data.cityName
    //                        boardWithMode.totalMember = data.totalMember
    //                        boardWithMode.imageIds = data.imageIds
    //                        boardWithMode.date = data.date
    //                        boardWithMode.latitude = data.latitude
    //                        boardWithMode.longitute = data.longitute
                            })
                        })
                    }
                case let .failure(error):
                    print(error)
                }
            }
        
        
        
        
        
        
        
        
        
//        guard let userItem = try? KeychainManager.getUserItem() else { return }
//        guard let boardId = boardId else { return }
//        let getBoardDetailReq = GetBoardDetail(boardId: boardId, refreshToken: userItem.refresh_token, userId: userItem.userId)
//        AF.request(API.BASE_URL + "boards/get/detail",
//                   method: .post,
//                   parameters: getBoardDetailReq,
//                   encoder: JSONParameterEncoder.default) // default set body and Content-Type HTTP header field of an encoded request is set to application/json
//        .validate(statusCode: 200..<500)
//        .responseData { response in
//            switch response.result {
//            case .success:
//                debugPrint(response)
//                guard let data = response.value else { return }
//                do{
//                    let decodedData = try JSONDecoder().decode(APIResponse<BoardDetail>.self, from: data)
//                    guard let myData = decodedData.data else { return }
//                    print("APIResponse<BoardDetail>", myData)
//                    
//                    
//                    
//                    
//                    
//                    
//                    var boardImages: [UIImage] = []
//                    var hostImage: UIImage?
//                    var memberImages: [UIImage] = []
//                    DispatchQueue.global().async {
//                        for imageUrl in myData.imageUrls {
//                            imageUrl.urlToImage { (image) in
//                                guard let image = image else {
//                                    print("imageUrls can't read")
//                                    return
//                                }
//                                boardImages.append(image)
//                            }
//                        }
//                        myData.profileImgUrl.urlToImage { (image) in
//                            guard let image = image else {
//                                print("profileImgUrl can't read")
//                                return
//                            }
//                            hostImage = image
//                        }
//                        if let userImages = myData.userImageUrls {
//                            for userImage in userImages {
//                                userImage.urlToImage { (image) in
//                                    guard let image = image else {
//                                        print("imageUrls can't read")
//                                        return
//                                    }
//                                    memberImages.append(image)
//                                }
//                            }
//                        }
////                        memberImages.append(UIImage(named: "user2")!)
////                        memberImages.append(UIImage(named: "user1")!)
////                        memberImages.append(UIImage(named: "user3")!)
//                        print("print(memberImages)", memberImages)
//                        DispatchQueue.main.async() {
//                            self.boardImages = boardImages
//                            self.memberImages = memberImages
//                            self.hostImageView.image = hostImage
//                            self.titleLabel.text = myData.title
//                            self.placeBoardInfoView.infoLabel.text = myData.address
//                            self.placeBoardInfoView.subInfoLabel.text = myData.addressDetail
//                            self.dateBoardInfoView.infoLabel.text = myData.date.stringToDate()?.dateToStringUser() //?.dateToString()
//                            self.hostNameLabel.text = myData.hostName
//                            self.hostId = myData.hostId
//                            self.memberLabel.text = "\(self.memberLabel.text ?? "") (\(myData.currentMember)/\(myData.totalMember))"
//                            self.introductionContentLabel.text = myData.introduction
//                            self.kindOfPersonContentLabel.text = myData.kindOfPerson
//                            self.mapAddressLabel.text = myData.address
//                            let coordinate = CLLocationCoordinate2D(latitude: 37.5510763, longitude: 127.075836)
//                            self.moveLocation(latitudeValue: coordinate.latitude, longtudeValue: coordinate
//                                .longitude, delta: 0.01)
//                            self.setAnnotation(latitudeValue: coordinate.latitude, longitudeValue: coordinate.longitude, delta: 0.01, title: "", subtitle: myData.address)
//                        }
//                    }
//                }
//                catch{
//                    print("catch can't read")
//                    print(error.localizedDescription)
//                }
//            case let .failure(error):
//                print(error)
//            }
//        }
    }
}

extension GatheringDetailBoardViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
         boardImagesPageControl.currentPage = Int(floorf(Float(scrollView.contentOffset.x) / Float(scrollView.frame.size.width)))
        print("scrollViewDidScroll")
    }
}

extension GatheringDetailBoardViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        print("Tapped gatherging board collectionview image")
        
        
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

extension GatheringDetailBoardViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return 10
        return memberImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("ProfileImages indexpath update \(indexPath)")
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier:  MemberImagesCollectionViewCell.identifier, for: indexPath) as? MemberImagesCollectionViewCell else { return UICollectionViewCell() }
//        cell.configure(image: self.memberImages[indexPath.row])
        cell.configure(imageString: memberImages[indexPath.row])
        return cell
    }
}

extension GatheringDetailBoardViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
//        let size: CGFloat = imagesCollectionView.frame.size.width/2
////        CGSize(width: size, height: size)
//
//        CGSize(width: view.frame.width / 5, height: view.frame.width / 5)
        print("Sizing collectionView")
        return CGSize(width: collectionView.frame.height - 20, height: collectionView.frame.height - 20)
    }
}

extension GatheringDetailBoardViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        print("annotation st")
        if !(annotation is MKPointAnnotation) {
            print("annotationfafadfasdf")
            return nil
        }
        
        let annotationIdentifier = "AnnotationIdentifier"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier)
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            annotationView?.canShowCallout = true
        }
        else {
            annotationView?.annotation = annotation
        }
        
        let pinImage = UIImage(named: "Pin")
        
        annotationView?.image = pinImage?.coustomPinSize(width: 30, height: 30)
        
        return annotationView
    }
    
    // move camera
    func moveLocation(latitudeValue: CLLocationDegrees, longtudeValue: CLLocationDegrees, delta span: Double) {
        let pLocation = CLLocationCoordinate2DMake(latitudeValue, longtudeValue)
        let pSpanValue = MKCoordinateSpan(latitudeDelta: span, longitudeDelta: span)
        let pRegion = MKCoordinateRegion(center: pLocation, span: pSpanValue)
        self.mapView.setRegion(pRegion, animated: true)
    }
    
    // set pin
    func setAnnotation(latitudeValue: CLLocationDegrees, longitudeValue: CLLocationDegrees, delta span :Double, title strTitle: String, subtitle strSubTitle:String) {
        mapView.removeAnnotations(mapView.annotations)
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2DMake(latitudeValue, longitudeValue)
        annotation.title = strTitle
        annotation.subtitle = strSubTitle
        mapView.addAnnotation(annotation)
    }
}

//extension Notification.Name {
//    static let deleteBoardRefresh = Notification.Name("DeleteBoardRefresh")
//}
