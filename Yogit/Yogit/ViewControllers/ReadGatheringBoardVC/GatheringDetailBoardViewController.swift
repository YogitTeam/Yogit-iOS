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
import ProgressHUD
import SkeletonView

enum GatheringUserState: Int {
    case none = 0, join, withdrawl
}

class GatheringDetailBoardViewController: UIViewController {
    
    var boardWithMode = BoardWithMode()
 
    var isClipBoardAlarm: Bool? = false {
        didSet {
            if isClipBoardAlarm == true { moveToClipBoard() }
        }
    }
    
    private var boardImages: [String] = [] {
        didSet {
            if boardImages.count >= 2 {
                boardImagesPageControl.numberOfPages = boardImages.count
            }
        }
    }
    
    private var memberImages: [String] = [] {
        didSet {
            self.imagesCollectionView.reloadData()
        }
    }
    
    private var userIds = [Int64]()
    
    private let mapView: MKMapView = {
        let view = MKMapView()
        view.isUserInteractionEnabled = false
        view.isSkeletonable = true
        return view
    }()

    private let placeBoardInfoView: BoardInfoView = {
        let view = BoardInfoView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemBackground
        view.isSkeletonable = true
        return view
    }()
    
    private let dateBoardInfoView: BoardInfoView = {
        let view = BoardInfoView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemBackground
        view.isSkeletonable = true
        return view
    }()
    
    private lazy var joinBulletinManager: BLTNItemManager = {
        
        let item = BLTNPageItem(title: "JOIN_GATHERING_TITLE".localized())
        item.image = "👋".stringToImage(width: 100, height: 100)//UIImage(named: "pro1")
        
        item.actionButtonTitle = "JOIN".localized()

        item.descriptionText = "JOIN_GATHERING_DESCRIPTION".localized()
        item.appearance.actionButtonColor = ServiceColor.primaryColor
//        item.appearance.alternativeButtonTitleColor = .gray
        item.actionHandler = { _ in
            self.joinBoardRequest() // 분기처리 요구됨
        }

        return BLTNItemManager(rootItem: item)
    }()
    
    private lazy var joinedBulletinManager: BLTNItemManager = {
        
        let page = BLTNPageItem(title: "JOINED_GATHERING_TITLE".localized())
        page.image = UIImage(named: "COMPLETION")?.withTintColor(ServiceColor.primaryColor)
        page.actionButtonTitle = "CLIPBOARD".localized()
        page.descriptionText = "\("💬") \("JOINED_GATHERING_DESCRIPTION".localized())"
        page.appearance.actionButtonColor = ServiceColor.primaryColor
        
        page.actionHandler = { item in
            item.manager?.dismissBulletin(animated: true)
            self.moveToClipBoard()
        }
        
        
        return BLTNItemManager(rootItem: page)
    }()
    
    private lazy var withDrawedBulletinManager: BLTNItemManager = {
        
        let page = BLTNPageItem(title: "WITHDRAWAL_GATHERING_TITLE".localized())
        page.image = UIImage(named: "COMPLETION")?.withTintColor(.systemGray)
        page.descriptionText = "WITHDRAWAL_GATHERING_DESCRIPTION".localized()

        return BLTNItemManager(rootItem: page)
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
        pageControl.currentPageIndicatorTintColor = .white//ServiceColor.primaryColor
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
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.bounces = true // 경계지점에서 bounce될건지 체크 (첫 or 마지막 페이지에서 바운스 스크롤 효과 여부)
        scrollView.isSkeletonable = true
        return scrollView
    }()
    
    private lazy var boardContentScrollView: UIScrollView = {
       let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.isScrollEnabled = true
        scrollView.addSubview(contentView)
        scrollView.isSkeletonable = true
        return scrollView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 20, weight: UIFont.Weight.semibold)
        label.numberOfLines = 0
        label.sizeToFit()
        label.isSkeletonable = true
        return label
    }()
    

    private lazy var rightButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(systemName: "ellipsis"), style: .plain, target: self, action: #selector(rightButtonPressed(_:))) //
        button.isHidden = true
        button.tintColor = UIColor.white
        return button
    }()
    
    private let footerView1: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6//.systemGray6
        return view
    }()

    private let footerView2: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        return view
    }()
    
    private let footerView3: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        return view
    }()
    
    private lazy var hostImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
//        imageView.backgroundColor = .placeholderText
//        imageView.layer.cornerRadius = 55
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        imageView.contentMode = .scaleAspectFill
        imageView.isSkeletonable = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.hostImageViewTapped(_:))))
        return imageView
    }()
    
    private let hostLabel: UILabel = {
        let label = UILabel()
        label.text = "HOST".localized()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 20, weight: UIFont.Weight.medium)
        label.numberOfLines = 1
        label.sizeToFit()
        label.isSkeletonable = true
        return label
    }()
    
//    private let hostNameLabel: UILabel = {
//        let label = UILabel()
//        label.text = "hostName"
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.textAlignment = .left
//        label.font = .systemFont(ofSize: 20, weight: UIFont.Weight.regular)
//        label.numberOfLines = 1
////        label.sizeToFit()
////        label.adjustsFontSizeToFitWidth = true
//        return label
//    }()
    
    private let memberLabel: UILabel = {
        let label = UILabel()
        label.text = "MEMBER".localized()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 20, weight: UIFont.Weight.medium)
        label.numberOfLines = 1
        label.sizeToFit()
        label.isSkeletonable = true
        return label
    }()
    
    private let imagesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(MemberImagesCollectionViewCell.self, forCellWithReuseIdentifier: MemberImagesCollectionViewCell.identifier)
        collectionView.backgroundColor = .systemBackground
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isSkeletonable = true
        return collectionView
    }()
    
    private lazy var introductionStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .leading
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.backgroundColor = .systemBackground
        stackView.isSkeletonable = true
        [introductionLabel, introductionContentTextView].forEach { stackView.addArrangedSubview($0) }
        return stackView
    }()
    
    private let introductionLabel: UILabel = {
        let label = UILabel()
        label.text = "GATHERING_INTRODUCTION_HEADER".localized()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 20, weight: UIFont.Weight.medium)
        label.numberOfLines = 1
        label.sizeToFit()
        return label
    }()
    
    private let introductionContentTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = .systemBackground
        textView.isScrollEnabled = false
        textView.textContainerInset = UIEdgeInsets(top: 0, left: -4, bottom: 0, right: 4)
        textView.sizeToFit()
        textView.isEditable = false
        textView.font = .systemFont(ofSize: 17, weight: UIFont.Weight.regular)
        textView.textColor = .label
        return textView
    }()
    
    private lazy var kindOfPersonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .leading
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.backgroundColor = .systemBackground
        stackView.isSkeletonable = true
        [kindOfPersonLabel, kindOfPersonContentTextView].forEach { stackView.addArrangedSubview($0) }
        return stackView
    }()
    
    private let kindOfPersonLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "GATHERING_KINDOFPERSON_HEADER".localized()
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 20, weight: UIFont.Weight.medium)
        label.numberOfLines = 1
        label.sizeToFit()
        return label
    }()
    
    private let kindOfPersonContentTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = .systemBackground
        textView.isScrollEnabled = false
        textView.textContainerInset = UIEdgeInsets(top: 0, left: -4, bottom: 0, right: 4)
        textView.sizeToFit()
        textView.isEditable = false
        textView.font = .systemFont(ofSize: 17, weight: UIFont.Weight.regular)
        textView.textColor = .label
        return textView
    }()
    
    private lazy var mapStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .leading
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.backgroundColor = .systemBackground
        stackView.isSkeletonable = true
        [mapLabel, mapAddressLabel].forEach { stackView.addArrangedSubview($0) }
        return stackView
    }()
    
    private let mapLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "LOCATION".localized()
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 20, weight: UIFont.Weight.medium)
        label.numberOfLines = 1
        label.sizeToFit()
        return label
    }()
    
    private let mapAddressLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 17, weight: UIFont.Weight.regular)
        label.numberOfLines = 0
        label.sizeToFit()
        return label
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isSkeletonable = true
        [self.boardImagesScrollView,
         self.boardImagesPageControl,
         self.titleLabel,
         self.placeBoardInfoView,
         self.dateBoardInfoView,
         self.footerView1,
         self.hostLabel,
         self.hostImageView,
         self.memberLabel,
         self.imagesCollectionView,
         self.footerView2,
         self.introductionStackView,
         self.kindOfPersonStackView,
         self.footerView3,
         self.mapStackView,
         self.mapView].forEach { view.addSubview($0) }
        return view
    }()

    private lazy var boardBottomView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(joinBoardButton)
        view.addSubview(clipBoardButton)
        view.addSubview(withdrawalButton)
        view.isSkeletonable = true
//        view.addSubview(joinListButton)
        return view
    }()
    
    
    private lazy var joinBoardButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = ServiceColor.primaryColor
        button.setTitle("JOIN".localized(), for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: UIFont.Weight.semibold)
        button.tintColor = .white
        button.setTitleColor(.white, for: .normal) // 이렇게 해야 적용된다!
        button.layer.cornerRadius = 8
        button.isEnabled = true
        button.isHidden = true
        button.isSkeletonable = true
        button.addTarget(self, action: #selector(self.joinBoardButtonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var withdrawalButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemBackground
        button.setTitle("WITHDRAWAL".localized(), for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: UIFont.Weight.semibold)
        button.tintColor = .placeholderText
        button.setTitleColor(.placeholderText, for: .normal) // 이렇게 해야 적용된다!
        button.setTitleColor(.placeholderText, for: .disabled)
        button.layer.cornerRadius = 8
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.placeholderText.cgColor
        button.isEnabled = true
        button.isHidden = true
        button.isSkeletonable = true
        button.addTarget(self, action: #selector(self.withdrawalButtonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
//    private lazy var joinListButton: UIButton = {
//        let button = UIButton()
//        button.backgroundColor = .systemBackground
////        button.setImage(UIImage(named: "Apply")?.withTintColor(.white, renderingMode: .alwaysTemplate), for: .normal)
//        button.setTitle("Join list", for: .normal)
////        button.setTitle("Applied", for: .disabled)
//        button.titleLabel?.font = .systemFont(ofSize: 17, weight: UIFont.Weight.semibold)
//        button.tintColor = ServiceColor.primaryColor
//        button.setTitleColor(ServiceColor.primaryColor, for: .normal) // 이렇게 해야 적용된다!
//        button.layer.cornerRadius = 8
//        button.layer.borderColor = ServiceColor.primaryColor.cgColor
//        button.layer.borderWidth = 2
//        button.isEnabled = true
//        button.isHidden = true
//        button.addTarget(self, action: #selector(self.oinButtonTapped(_:)), for: .touchUpInside)
//        return button
//    }()
    
    private lazy var clipBoardButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = ServiceColor.primaryColor
        button.layer.cornerRadius = 8
        button.tintColor = .white
        button.setImage(UIImage(named: "BoardClipBoard")?.withTintColor(.white, renderingMode: .alwaysTemplate), for: .normal)
        button.setTitle("CLIPBOARD".localized(), for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: UIFont.Weight.semibold)
        button.setTitleColor(.white, for: .normal)
        button.isEnabled = true
        button.isHidden = true
        button.isSkeletonable = true
        button.addTarget(self, action: #selector(self.clipBoardTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNav()
        configureView()
        configureInteractionInfoComponent()
        configureScrollView()
        configureCollectionView()
        configureMap()
        initProgressHUD()
        setViewWithMode(mode: boardWithMode.mode)
        configureNotification()
//        joinBulletinManager.backgroundViewStyle = .blurred(style: .systemUltraThinMaterialLight, isDark: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.tintColor = .white
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.tintColor = .label
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        boardContentScrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        contentView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.centerX.bottom.equalToSuperview()
            $0.top.equalTo(boardContentScrollView.bounds.minY)
        }
        boardImagesScrollView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(view.frame.size.width)
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
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
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
            $0.height.equalTo(5)
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
        
//        hostNameLabel.snp.makeConstraints {
////            $0.top.equalTo(hostLabel.snp.bottom).offset(10)
//            $0.centerY.equalTo(hostImageView)
//            $0.leading.equalTo(hostImageView.snp.trailing).offset(10)
//            $0.trailing.equalToSuperview().inset(20)
//        }
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
        introductionStackView.snp.makeConstraints {
            $0.top.equalTo(footerView2.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        kindOfPersonStackView.snp.makeConstraints {
            $0.top.equalTo(introductionStackView.snp.bottom).offset(31)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        kindOfPersonLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview()
        }
        footerView3.snp.makeConstraints {
            $0.top.equalTo(kindOfPersonStackView.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(6)
        }
        mapStackView.snp.makeConstraints {
            $0.top.equalTo(footerView3.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        mapView.snp.makeConstraints {
            $0.top.equalTo(mapStackView.snp.bottom).offset(10)
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
//        joinListButton.snp.makeConstraints {
//            $0.leading.equalToSuperview().inset(20)
//            $0.width.equalTo((view.frame.width-60)/2)
//            $0.bottom.equalToSuperview().inset(30)
//            $0.height.equalTo(50)
//        }
        
        placeBoardInfoView.layer.addBorderWithMargin(arr_edge: [.bottom], marginLeft: 0, marginRight: 0, color: .systemGray6, width: 1, marginTop: 0)
        memberLabel.layer.addBorderWithMargin(arr_edge: [.top], marginLeft: 0, marginRight: 0, color: .systemGray6, width: 1, marginTop: 10)
        kindOfPersonLabel.layer.addBorderWithMargin(arr_edge: [.top], marginLeft: 0, marginRight: 0, color: .systemGray6, width: 1, marginTop: 15)
    }
    
    private func configureMap() {
        mapView.delegate = self
    }
    
    private func configureScrollView() {
        boardContentScrollView.delegate = self
        boardImagesScrollView.delegate = self
    }
    
    private func configureCollectionView() {
        imagesCollectionView.delegate = self
        imagesCollectionView.dataSource = self
    }
    
    private func configureView() {
        view.addSubview(boardContentScrollView)
        view.addSubview(boardBottomView)
        view.backgroundColor = .systemBackground
    }
    
    private func configureNav() {
        navigationItem.rightBarButtonItem = self.rightButton
        navigationItem.backButtonTitle = "" // remove back button title
    }
    
    private func configureNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(didlBaordDetailRefreshForBlock(_:)), name: .baordDetailRefreshForBlock, object: nil)
    }
    
    private func setViewWithMode(mode: Mode?) {
        if mode == .refresh {
            DispatchQueue.main.async(qos: .userInteractive, execute: { [self] in
                viewBinding(data: boardWithMode)
            })
        } else {
            getBoardDetail(state: .none)
        }
    }
    
    private func initProgressHUD() {
        ProgressHUD.colorAnimation = ServiceColor.primaryColor
    }
    
    private func configureInteractionInfoComponent() {
        self.placeBoardInfoView.leftImageView.image = UIImage(named: "Place")?.withTintColor(.systemGray4, renderingMode: .alwaysOriginal)
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .medium)
        let image = UIImage(systemName: "chevron.right", withConfiguration: imageConfig)?.withTintColor(.systemGray4, renderingMode: .alwaysOriginal)
        self.placeBoardInfoView.rightImageView.image = image
        self.dateBoardInfoView.leftImageView.image = UIImage(named: "Date")?.withTintColor(.systemGray4, renderingMode: .alwaysOriginal)
        self.placeBoardInfoView.isUserInteractionEnabled = true
        self.placeBoardInfoView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.copyAddressTapped(_:))))
    }
    
    @objc private func didlBaordDetailRefreshForBlock(_ notification: Notification) {
        getBoardDetail(state: .none)
    }
    
    @objc func joinBoardButtonTapped(_ sender: UIButton) {
        joinBulletinManager.showBulletin(above: self)
    }
    
    @objc func withdrawalButtonTapped(_ sender: UIButton) {
        guard let identifier = UserDefaults.standard.object(forKey: SessionManager.currentServiceTypeIdentifier) as? String, let userItem = try? KeychainManager.getUserItem(serviceType: identifier) else { return }
        if userItem.userId != boardWithMode.hostId { // hostId
            let alert = UIAlertController(title: "WITHDRAWAL".localized(), message: "WITHDRAWAL_ALERT".localized(), preferredStyle: .alert)
            let cancel = UIAlertAction(title: "CANCEL".localized(), style: .cancel)
            let ok = UIAlertAction(title: "OK".localized(), style: .destructive) { (ok) in
                self.withdrawalBoardRequest()
            }
            alert.addAction(cancel)
            alert.addAction(ok)
            DispatchQueue.main.async {
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    @objc func joinListButtonTapped(_ sender: UIButton) {
        // 대기 리스트
    }
    
    private func joinBoardRequest() {
        guard let identifier = UserDefaults.standard.object(forKey: SessionManager.currentServiceTypeIdentifier) as? String, let userItem = try? KeychainManager.getUserItem(serviceType: identifier) else { return }
//        guard let boardId = boardId else { return }
        guard let boardId = boardWithMode.boardId else { return }
        
        self.joinBulletinManager.dismissBulletin(animated: true)
        
        ProgressHUD.colorAnimation = ServiceColor.primaryColor
        ProgressHUD.animationType = .circleStrokeSpin
        ProgressHUD.show(interaction: false)
        
        let boardUserReq = BoardUserReq(boardId: boardId, refreshToken: userItem.refresh_token, userId: userItem.userId)
        AlamofireManager.shared.session
            .request(BoardUserRouter.joinGatheringBoard(parameters: boardUserReq))
            .validate(statusCode: 200..<501)
            .responseDecodable(of: APIResponse<BoardUserRes>.self) { response in // 서버 반영 필요
                switch response.result {
                case .success:
                    if let value = response.value {
                        DispatchQueue.main.async {
                            ProgressHUD.dismiss()
                        }
                        if value.httpCode == 200 || value.httpCode == 201 {
                            self.getBoardDetail(state: .join)
                        } else if value.httpCode == 400, value.errorCode == "B003" {
                            // 경고창 띄우고 리프레시 해야함 (멤버 꽉차면, 조인 버튼 disable, 텍스트 마감), 보드 리프레시
                            let alert = UIAlertController(title: "MEMBER_FULL_ALERT_TITLE".localized(), message: "MEMBER_FULL_ALERT_MESSAGE".localized(), preferredStyle: .alert)
                            let cancel = UIAlertAction(title: "CANCEL".localized(), style: .cancel)
                            let ok = UIAlertAction(title: "OK".localized(), style: .default)
                            alert.addAction(cancel)
                            alert.addAction(ok)
                            DispatchQueue.main.async {
                                self.present(alert, animated: true)
                            }
                        }
                    }
                case let .failure(error):
                    print(error)
                    DispatchQueue.main.async {
                        self.joinBulletinManager.dismissBulletin(animated: true)
                        ProgressHUD.dismiss()
                    }
                }
            }
    }
    
    func withdrawalBoardRequest() {
        guard let identifier = UserDefaults.standard.object(forKey: SessionManager.currentServiceTypeIdentifier) as? String, let userItem = try? KeychainManager.getUserItem(serviceType: identifier) else { return }
        guard let boardId = boardWithMode.boardId else { return }
        
        ProgressHUD.colorAnimation = ServiceColor.primaryColor
        ProgressHUD.animationType = .circleStrokeSpin
        ProgressHUD.show(interaction: false)
        let boardUserReq = BoardUserReq(boardId: boardId, refreshToken: userItem.refresh_token, userId: userItem.userId)
        AlamofireManager.shared.session
            .request(BoardUserRouter.withdrawalGatheringBoard(parameters: boardUserReq))
            .validate(statusCode: 200..<501)
            .responseDecodable(of: APIResponse<BoardUserRes>.self) { response in // 서버 반영 필요
                switch response.result {
                case .success:
                    if let value = response.value, value.httpCode == 200 || value.httpCode == 201 {
                        print("취소 성공")
                        DispatchQueue.main.async {
                            ProgressHUD.dismiss()
                        }
                        self.getBoardDetail(state: .withdrawl)
                    } else {
                        print("취소 실패")
                    }
                case let .failure(error):
                    print(error)
                    DispatchQueue.main.async {
                        ProgressHUD.dismiss()
                    }
                }
            }
    }
    
    func moveToClipBoard() {
        DispatchQueue.main.async {
            let CBVC = ClipBoardViewController()
            CBVC.boardId = self.boardWithMode.boardId
            self.navigationController?.pushViewController(CBVC, animated: true)
        }
    }
    
    @objc func clipBoardTapped(_ sender: UITapGestureRecognizer) {
        moveToClipBoard()
    }
    
    @objc func hostImageViewTapped(_ sender: UITapGestureRecognizer) {
        guard let userIdToRead = boardWithMode.hostId else { return }
        readProfile(userIdToRead: userIdToRead)
    }
    // https://www.google.com/maps/place/서울특별시+광진구+능동로+209+세종대학교/@37.5518018,127.0736345,17z/data=!4m6!3m5!1s0x357ca4d0720eecc1:0x1a7ad975c6b5e4eb!8m2!3d37.5518018!4d127.0736345!16s%2Fm%2F0ddhhlj?hl=ko
    @objc func copyAddressTapped(_ sender: UITapGestureRecognizer) {
        print("searchPlaceTapped")
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
//        alert.view.tintColor = UIColor.label
        guard let latitude = self.boardWithMode.latitude else { return }
        guard let longitude = self.boardWithMode.longitute else { return }
        let zoom = 15
        let cancel = UIAlertAction(title: "CANCEL".localized(), style: .cancel, handler: nil)
        let copy = UIAlertAction(title: "COPY".localized(), style: .default) { (action) in
            guard let address = self.boardWithMode.address else { return }
            UIPasteboard.general.string = address
        }
        // 애플맵은 앱에서만 작동
        let appleMap = UIAlertAction(title: "APPLE_MAP".localized(), style: .default) { (action) in
            guard let appUrl = URL(string:"maps://?q=\(latitude),\(longitude)") else { return }
            UIApplication.shared.open(appUrl, options: [:], completionHandler: nil)
        }
        let googleMap = UIAlertAction(title: "GOOGLE_MAP".localized(), style: .default) { (action) in
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
        let kakaoMap = UIAlertAction(title: "KAKAO_MAP".localized(), style: .default) { (action) in
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
//        alert.view.tintColor = UIColor.label
        let cancel = UIAlertAction(title: "CANCEL".localized(), style: .cancel, handler: nil)
        guard let identifier = UserDefaults.standard.object(forKey: SessionManager.currentServiceTypeIdentifier) as? String, let userItem = try? KeychainManager.getUserItem(serviceType: identifier) else { return }
        if userItem.userId != boardWithMode.hostId { // hostId
            let report = UIAlertAction(title: "REPORT".localized(), style: .destructive) { (action) in
                guard let reportBoardId = self.boardWithMode.boardId else { return }
                guard let reportedUserId = self.boardWithMode.hostId else { return }
                self.reportAlert(reportBoardId: reportBoardId, reportedUserId: reportedUserId)
            }
            alert.addAction(report)
        } else {
            let edit = UIAlertAction(title: "EDIT".localized(), style: .default) { (action) in self.editBoard() }
            let delete = UIAlertAction(title: "DELETE".localized(), style: .default) { (action) in self.deleteAlert() }
            alert.addAction(edit)
            alert.addAction(delete)
        }
        alert.addAction(cancel)
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    private func reportAlert(reportBoardId: Int64, reportedUserId: Int64) {
        DispatchQueue.main.async(qos: .userInteractive) {
            let RVC = ReportViewController()
            RVC.reportedBoardId = reportBoardId
            RVC.reportedUserId = reportedUserId
            RVC.reportKind = .boardReport
            let NC = UINavigationController(rootViewController: RVC)
            NC.modalPresentationStyle = .fullScreen
            self.present(NC, animated: true, completion: nil)
        }
    }
    
    private func deleteAlert() {
        let alert = UIAlertController(title: "DELETE".localized(), message: "DELETE_GATHERING_ALERT_MESSAGE".localized(), preferredStyle: .alert)
        let cancel = UIAlertAction(title: "CANCEL".localized(), style: .cancel)
        let ok = UIAlertAction(title: "OK".localized(), style: .default) { (ok) in
            self.deleteBoard()
        }
        alert.addAction(cancel)
        alert.addAction(ok)
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    private func editBoard() {
        DispatchQueue.main.async(qos: .userInteractive, execute: { [self] in
            let GBCVC = GatheringBoardCategoryViewController()
            boardWithMode.mode = .edit
            GBCVC.categoryId = (boardWithMode.categoryId ?? 0) - 1
            GBCVC.boardWithMode = boardWithMode
            print("editBoard boardwithmode", boardWithMode)
            self.navigationController?.pushViewController(GBCVC, animated: true)
        })
    }
    
    private func deleteBoard() {
        guard let identifier = UserDefaults.standard.object(forKey: SessionManager.currentServiceTypeIdentifier) as? String, let userItem = try? KeychainManager.getUserItem(serviceType: identifier) else { return }
//        guard let boardId = boardId else { return }
        guard let hostId = boardWithMode.hostId else { return }
        guard let boardId = boardWithMode.boardId else { return }
        let deleteBoardReq = DeleteBoardReq(boardId: boardId, refreshToken: userItem.refresh_token, hostId: hostId) // hostId
        AlamofireManager.shared.session
            .request(BoardRouter.deleteBoard(parameters: deleteBoardReq))
            .validate(statusCode: 200..<501)
            .responseDecodable(of: APIResponse<DeleteBoardRes>.self) { response in // 서버 반영 필요
                switch response.result {
                case .success:
                    guard let value = response.value else { return }
                    if value.httpCode == 200 {
                        DispatchQueue.main.async(qos: .userInteractive, execute: { [self] in
                            navigationController?.popViewController(animated: true)
                        })
                    }
                case let .failure(error):
                    print(error)
                }
            }
    }
    
    
    private func isDeletedAlert() {
        let alert = UIAlertController(title: "BOARD_DELETED_ALERT_TITLE".localized(), message: "BOARD_DELETED_ALERT_MESSAGE".localized(), preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK".localized(), style: .default) { (ok) in
            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: true)
            }
        }
        alert.addAction(ok)
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    private func configureAsyncImageScrollView() async {
        boardImagesScrollView.contentSize.width = view.frame.width * CGFloat(boardImages.count)
        boardImagesScrollView.isPagingEnabled = true
        await withTaskGroup(of: Void.self, body: { taskGroup in
            for x in 0..<boardImages.count {
                taskGroup.addTask {
                    let imageURL = await self.boardImages[x]
                    let imageView = await UIImageView(frame: CGRect(x: CGFloat(x) * self.boardImagesScrollView.frame.width, y: self.boardImagesScrollView.frame.minY, width: self.boardImagesScrollView.frame.width, height: self.boardImagesScrollView.frame.width))
                    await MainActor.run {
                        imageView.clipsToBounds = true
                        imageView.isSkeletonable = true
                        imageView.contentMode = .scaleAspectFill
                        imageView.backgroundColor = .systemGray
                    }
                    await imageView.setImage(with: imageURL)
                    await MainActor.run {
                        self.boardImagesScrollView.insertSubview(imageView, at: x)
                    }
                }
            }
        })
    }
    
    
    private func configureImagesScrollView() {
        boardImagesScrollView.contentSize.width = view.frame.width * CGFloat(boardImages.count)
        boardImagesScrollView.isPagingEnabled = true
        for x in 0..<boardImages.count {
            let imageView = UIImageView(frame: CGRect(x: CGFloat(x) * boardImagesScrollView.frame.width, y: boardImagesScrollView.frame.minY, width: boardImagesScrollView.frame.width, height: boardImagesScrollView.frame.width))
            imageView.clipsToBounds = true
            imageView.contentMode = .scaleAspectFill
            imageView.backgroundColor = .systemGray
            imageView.setImage(with: boardImages[x])
            boardImagesScrollView.addSubview(imageView)
        }
    }
    
    private func configureImagesScrollView2() {
        boardImagesScrollView.contentSize.width = view.frame.width * CGFloat(boardImages.count)
        boardImagesScrollView.isPagingEnabled = true
        for x in 0..<boardImages.count {
            let imageView = UIImageView(frame: CGRect(x: CGFloat(x) * boardImagesScrollView.frame.width, y: boardImagesScrollView.frame.minY, width: boardImagesScrollView.frame.width, height: boardImagesScrollView.frame.width))
            imageView.clipsToBounds = true
            imageView.contentMode = .scaleAspectFill
            imageView.backgroundColor = .systemGray
            let image = boardImages[x].loadImageAsync()
            imageView.image = image
            boardImagesScrollView.addSubview(imageView)
        }
    }

    func bindBoardDetail(data: BoardDetail) {
        // boardDetail로 화면 뿌려줌 & boardWithMode 저장
        boardWithMode.userIds = data.userIds
        boardWithMode.hostId = data.hostId // hostId로 신고 설정
        boardWithMode.boardId = data.boardId // boardId로 BoardDetail API 요청
        boardWithMode.currentMember = data.currentMember
        boardWithMode.memberImages = data.userImageUrls
//        boardWithMode.hostName = data.hostName
        boardWithMode.hostImage = data.profileImgUrl
        boardWithMode.title = data.title
        boardWithMode.address = data.address
        boardWithMode.addressDetail = data.addressDetail
        boardWithMode.introduction = data.introduction
        boardWithMode.kindOfPerson = data.kindOfPerson
        boardWithMode.downloadImages = data.imageUrls
        boardWithMode.categoryId = data.categoryId
        boardWithMode.notice = data.notice
        boardWithMode.city = data.cityName
        boardWithMode.totalMember = data.totalMember
        boardWithMode.imageIds = data.imageIds
        boardWithMode.date = data.date
        boardWithMode.latitude = data.latitude
        boardWithMode.longitute = data.longitute
        boardWithMode.isJoinedUser = data.isJoinedUser
    }
    
    // textview 업데이트 안됨
    func viewBinding(data: BoardWithMode) {
        guard let userIds = data.userIds else { return }
        self.userIds = userIds
        boardImages = data.downloadImages
        guard let memberImages = data.memberImages else { return }
        self.memberImages = memberImages
        
        if let imageString = data.hostImage {
            if imageString.contains("null") {
                hostImageView.image = UIImage(named: "PROFILE_IMAGE_NULL")
            } else {
                hostImageView.setImage(with: imageString)
            }
        }
        
    
        Task.detached(priority: .high) { [weak self] in
            await self?.configureAsyncImageScrollView()
        }
        
        introductionContentTextView.text = data.introduction
        kindOfPersonContentTextView.text = data.kindOfPerson
        
        placeBoardInfoView.infoLabel.text = data.address
        placeBoardInfoView.subInfoLabel.text = data.addressDetail
        dateBoardInfoView.infoLabel.text = data.date?.stringToDate()?.dateToStringUser() //?.dateToString()
        
        moveLocation(latitudeValue: data.latitude!, longtudeValue: data.longitute!, delta: 0.01)
        setAnnotation(latitudeValue: data.latitude!, longitudeValue: data.longitute!, delta: 0.01, title: "", subtitle: data.address!)
    
        joinBoardButton.isHidden = data.isJoinedUser
        
        guard let identifier = UserDefaults.standard.object(forKey: SessionManager.currentServiceTypeIdentifier) as? String, let userItem = try? KeychainManager.getUserItem(serviceType: identifier) else { return }
        
        clipBoardButton.snp.removeConstraints()
        if boardWithMode.hostId == userItem.userId {
            clipBoardButton.snp.updateConstraints {
                $0.leading.trailing.equalToSuperview().inset(20)
                $0.bottom.equalToSuperview().inset(30)
                $0.height.equalTo(50)
            }
//            joinListButton.isHidden = !joinBoardButton.isHidden
        } else {
            clipBoardButton.snp.updateConstraints() {
                $0.trailing.equalToSuperview().inset(20)
                $0.bottom.equalToSuperview().inset(30)
                $0.height.equalTo(50)
                $0.width.equalTo((view.frame.width-60)/2)
            }
            withdrawalButton.isHidden = !joinBoardButton.isHidden
        }
        clipBoardButton.isHidden = !joinBoardButton.isHidden
        
        guard let boardDate = data.date?.stringToDate() else { return }
        guard let currentDate = Date().dateToStringUTC().stringToDate() else { return }
        let timeInterval = boardDate.timeIntervalSince(currentDate)
        
        if timeInterval < 0 { // 날짜 지남
            withdrawalButton.isEnabled = false
            joinBoardButton.isEnabled = false
            joinBoardButton.backgroundColor = .placeholderText
            withdrawalButton.backgroundColor = .placeholderText
            if timeInterval < -259200 { // 3일: 259200초
                clipBoardButton.isEnabled = false
                clipBoardButton.backgroundColor = .placeholderText
            }
        } else {
            withdrawalButton.isEnabled = true
            joinBoardButton.isEnabled = true
            joinBoardButton.backgroundColor = ServiceColor.primaryColor
            withdrawalButton.backgroundColor = .systemBackground
        }
        
        guard let hostId = boardWithMode.hostId else { return }
        
        if GatheringBoardManager.isHostBlocked(userId: hostId) {
            // 차단된 호스트의 게시글 입니다.
            let alert = UIAlertController(title: "BLOCKED_HOST_ALERT_TITLE".localized(), message: "", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK".localized(), style: .default) { _ in
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
                }
            }
            alert.addAction(ok)
            DispatchQueue.main.async {
                self.present(alert, animated: true, completion: nil)
            }
            return
        }
        
        view.layoutIfNeeded()
        view.stopSkeletonAnimation()
        view.hideSkeleton(reloadDataAfter: true)
        
        rightButton.isHidden = false
        memberLabel.text = "MEMBER".localized() + "(\(data.currentMember ?? 0)/\(data.totalMember ?? 1))"
        titleLabel.text = data.title
        mapAddressLabel.text = data.address
        
        // 신청 버튼 (신청 / 취소)
//        _applyButton = !data.isJoinedUser
    }

    
    private func getBoardDetail(state: GatheringUserState) {

        guard let identifier = UserDefaults.standard.object(forKey: SessionManager.currentServiceTypeIdentifier) as? String, let userItem = try? KeychainManager.getUserItem(serviceType: identifier) else { return }
        guard let boardId = boardWithMode.boardId else {
            print("getBoardDetail - boardId is nil")
            return
        }

        let skeletonAnimation = SkeletonAnimationBuilder().makeSlidingAnimation(withDirection: .leftRight)
        contentView.showAnimatedGradientSkeleton(usingGradient: .init(colors: [.systemGray6, .systemGray5]), animation: skeletonAnimation, transition: .none)
        boardBottomView.showAnimatedGradientSkeleton(usingGradient: .init(colors: [.systemGray6, .systemGray5]), animation: skeletonAnimation, transition: .none)
        let getBoardDetailReq = GetBoardDetail(boardId: boardId, refreshToken: userItem.refresh_token, userId: userItem.userId)
        AlamofireManager.shared.session
            .request(BoardRouter.readBoardDetail(parameters: getBoardDetailReq))
            .validate(statusCode: 200..<501)
            .responseDecodable(of: APIResponse<BoardDetail>.self) { response in
            switch response.result {
            case .success:
                guard let value = response.value else { return }
                if value.httpCode == 200 || value.httpCode == 201,
                    let data = value.data, data.status == Status.active.rawValue {
                    DispatchQueue.global().async(qos: .userInitiated) { [weak self] in
                        self?.bindBoardDetail(data: data)
                        DispatchQueue.main.async(qos: .userInteractive) { [weak self] in
                            if state == .join { self?.joinedBulletinManager.showBulletin(above: self!) }
                            else if state == .withdrawl { self?.withDrawedBulletinManager.showBulletin(above: self!) }
                            self?.viewBinding(data: self!.boardWithMode)
                        }
                    }
                } else if value.httpCode == 400, let message = value.message, message.contains("보드 인원") { // 멤버수 증가에 따른 에러 처리 (httpCode:400, message: 보드 인원이 다 찼습니다.)
                    let alert = UIAlertController(title: "MEMBER_FULL_ALERT_TITLE".localized(), message: "MEMBER_FULL_ALERT_MESSAGE".localized(), preferredStyle: .alert)
                    let ok = UIAlertAction(title: "OK".localized(), style: .default)
                    alert.addAction(ok)
                    DispatchQueue.main.async {
                        self.present(alert, animated: true, completion: nil)
                    }
                    if let data = value.data {
                        DispatchQueue.global().async(qos: .userInitiated) { [weak self] in
                            self?.bindBoardDetail(data: data)
                            DispatchQueue.main.async(qos: .userInteractive) { [weak self] in
                                self?.viewBinding(data: self!.boardWithMode)
                            }
                        }
                    }
                } else if value.httpCode == 404, value.errorCode == "B0001" { // 삭제되 데이터 조회시
                    self.isDeletedAlert()
                }
            case let .failure(error):
                print(error)
            }
        }
    }
    
    func readProfile(userIdToRead: Int64) {
        DispatchQueue.main.async(execute: {
            let GPVC = GetProfileViewController()
            GPVC.getUserId = userIdToRead
            let NC = UINavigationController(rootViewController: GPVC)
            NC.modalPresentationStyle = .fullScreen
            self.present(NC, animated: true, completion: nil)
        })
    }
}

extension GatheringDetailBoardViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == boardContentScrollView {
            if scrollView.contentOffset.y <= 0 {
                DispatchQueue.main.async {
                    self.navigationController?.navigationBar.tintColor = .white // scroll down: change back button color to red
                    self.rightButton.tintColor = .white
                }
            } else {
                DispatchQueue.main.async {
                    self.navigationController?.navigationBar.tintColor = UIColor.label // scroll up: change back button color to blue
                    self.rightButton.tintColor = .label
                }
            }
        } else if scrollView == boardImagesScrollView {
            boardImagesPageControl.currentPage = Int(floorf(Float(scrollView.contentOffset.x) / Float(scrollView.frame.size.width)))
        }
    }
}

extension GatheringDetailBoardViewController: SkeletonCollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        readProfile(userIdToRead: userIds[indexPath.row])
    }
}

extension GatheringDetailBoardViewController: SkeletonCollectionViewDataSource {
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> SkeletonView.ReusableCellIdentifier {
        return MemberImagesCollectionViewCell.identifier
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       return UICollectionView.automaticNumberOfSkeletonItems
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memberImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MemberImagesCollectionViewCell.identifier, for: indexPath) as? MemberImagesCollectionViewCell else { return UICollectionViewCell() }
        cell.configure(imageString: memberImages[indexPath.row])
        return cell
    }
}

extension GatheringDetailBoardViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
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

