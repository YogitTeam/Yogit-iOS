//
//  GatheringDetailBoardViewController.swift
//  Yogit
//
//  Created by Junseo Park on 2022/12/01.

import UIKit
import SnapKit
import Alamofire

// total scrollview
// contentview

// scrollview
// stackview
// collection view

class GatheringDetailBoardViewController: UIViewController {

    var boardId: Int? {
        didSet {
            print("boardId \(boardId)")
        }
    }
    
    private var boardImages: [UIImage] = [] {
        didSet(oldVal){
            DispatchQueue.main.async {
                self.boardImagesPageControl.numberOfPages = self.boardImages.count
                self.configureScrollView()
//                if self.BoardImagesScrollView.subviews.count == 2 {
//                    self.configureScrollView()
//                }
            }
            print("Profile images update")
        }
    }
    
    let images = [UIImage(named: "1")!, UIImage(named: "1")!, UIImage(named: "1")!]
//    private var boardImages: [UIImage] = [UIImage(named: "1")!, UIImage(named: "1")!]
    
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
        scrollView.backgroundColor = .blue
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
        scrollView.backgroundColor = .yellow
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.isScrollEnabled = true
        scrollView.addSubview(contentView)
//        scrollView.addSubview(boardImagesScrollView)
//        scrollView.addSubview(contentView)
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .brown
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(boardImagesScrollView)
        view.addSubview(boardImagesPageControl)
        view.addSubview(subView)
//        view.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.width)
//        view.addSubview(boardImagesScrollView)
        return view
    }()
    
    private let subView: UIView = {
        let view = UIView()
        view.backgroundColor = .blue
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var rightButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(systemName: "ellipsis"), style: .plain, target: self, action: #selector(buttonPressed(_:))) //
//        let button = UIBarButtonItem(title: "adfadsfads", style: .plain, target: self, action: #selector(buttonPressed(_:)))
//        button.tintColor = .black
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(boardContentScrollView)
        configureViewComponent()
        boardImagesScrollView.delegate = self
        getBoardDetail()
    }
    
    func configureViewComponent() {
        self.view.backgroundColor = .systemBackground
        self.navigationItem.rightBarButtonItem = self.rightButton
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
        
        subView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo(100)
            $0.top.equalTo(boardImagesScrollView.snp.bottom)
            $0.bottom.equalToSuperview()
        }
//        boardContentScrollView.frame = CGRect(x: 0, y: contentView.bounds.minY, width: view.frame.size.width, height: view.frame.width)
        
//        boardImagesScrollView.snp.makeConstraints {
////            $0.edges.equalTo(cont)
////            $0.width.height.equalTo(view.frame.size.width)
////            $0.top.leading.trailing.equalToSuperview()
//        }
    }
    
    @objc private func pageControlDidChange(_ sender: UIPageControl) {
        let current = sender.currentPage
        boardImagesScrollView.setContentOffset(CGPoint(x: CGFloat(current) * boardImagesScrollView.frame.size.width, y: 0), animated: true)
    }
    
    @objc private func buttonPressed(_ sender: Any) {
        print("신고")
    }
    
    private func configureScrollView() {
//        self.boardImagesScrollView.contentSize.width = UIScreen.main.bounds.width * CGFloat(boardImages.count)
        // CGSize(width: UIScreen.main.bounds.width * CGFloat(boardImages.count))
        boardImagesScrollView.isPagingEnabled = true
        for x in 0..<boardImages.count {
            print("configure")
            let imageView = UIImageView(frame: CGRect(x: CGFloat(x) * boardImagesScrollView.frame.width, y: self.boardImagesScrollView.bounds.minY, width: boardImagesScrollView.frame.width, height: boardImagesScrollView.frame.width*2/3))
//            self.boardImagesScrollView.bounds.minY
            self.boardImagesScrollView.contentSize.width = imageView.frame.width * CGFloat(boardImages.count)
                imageView.backgroundColor = .systemRed
                print(boardImages[x].size)
                imageView.clipsToBounds = true
                imageView.contentMode = .scaleAspectFill
                imageView.image = boardImages[x]
                boardImagesScrollView.addSubview(imageView)
        }
    }
    
    func getBoardDetail() {
        guard let userItem = try? KeychainManager.getUserItem() else { return }
        guard let boardId = boardId else { return }
        let getBoardDetailReq = GetBoardDetail(boardId: boardId, refreshToken: userItem.refresh_token, userId: userItem.userId)
        AF.request(API.BASE_URL + "boards/get/detail",
                   method: .post,
                   parameters: getBoardDetailReq,
                   encoder: JSONParameterEncoder.default) // default set body and Content-Type HTTP header field of an encoded request is set to application/json
        .validate(statusCode: 200..<500)
        .responseData { response in
            switch response.result {
            case .success:
                debugPrint(response)
                guard let data = response.value else { return }
                do{
                    let decodedData = try JSONDecoder().decode(APIResponse<BoardDetail>.self, from: data)
                    DispatchQueue.global().async {
                        guard let imageUrls = decodedData.data?.imageUrls else {
                            print("imageUrls null")
                            return
                        }
                        var getImages: [UIImage] = []
                        print("get imageUrls \(imageUrls)")
                        for imageUrl in imageUrls {
                            imageUrl.urlToImage { (image) in
                                guard let image = image else { return }
                                getImages.append(image)
                            }
                        }
                        self.boardImages = getImages
                    }
                }
                catch{
                    print(error.localizedDescription)
                }
            case let .failure(error):
                print(error)
            }
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension GatheringDetailBoardViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
         boardImagesPageControl.currentPage = Int(floorf(Float(scrollView.contentOffset.x) / Float(scrollView.frame.size.width)))
//        boardImagesPageControl.currentPage = Int(floorf(Float(scrollView.contentOffset.x) / Float(boardImagesScrollView.frame.size.width)))
        print("scrollViewDidScroll")
    }
}

