//
//  SearchProfileImagesViewController.swift
//  Yogit
//
//  Created by Junseo Park on 2022/11/26.
//

import UIKit
import SnapKit
import Alamofire

class SearchProfileImagesViewController: UIViewController {

    private var profileImages: [UIImage] = [] {
        didSet(oldVal){
            DispatchQueue.main.async {
                self.profileImagesPageControl.numberOfPages = self.profileImages.count
                self.configureScrollView()
            }
            print("Profile images update")
        }
    }
    
    private lazy var profileImagesPageControl: UIPageControl = {
        let pageControl = UIPageControl()
        //페이지 컨트롤의 전체 페이지를 images 배열의 전체 개수 값으로 설정
        pageControl.numberOfPages = 0 // self.profileImages.count
        // 페이지 컨트롤의 현재 페이지를 0으로 설정
        pageControl.currentPage = 0
        // 페이지 표시 색상을 밝은 회색 설정
        pageControl.pageIndicatorTintColor = .placeholderText
        // 현재 페이지 표시 색상을 검정색으로 설정
        pageControl.currentPageIndicatorTintColor = UIColor(rgb: 0x3232FF, alpha: 1.0)
        pageControl.backgroundColor = .clear
        
        pageControl.addTarget(self, action: #selector(pageControlDidChange(_:)), for: .valueChanged)
//        profileImageView.image = u
        return pageControl
    }()
    
    private let profileImagesScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.alwaysBounceVertical = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.isScrollEnabled = true
        scrollView.isPagingEnabled = true
        scrollView.backgroundColor = .black
//        scrollView.bounces = false // 경계지점에서 bounce될건지 체크 (첫 or 마지막 페이지에서 바운스 스크롤 효과 여부)
        return scrollView
    }()
    
    private lazy var leftButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "delete")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        button.tintColor = .white
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(profileImagesScrollView)
        view.addSubview(profileImagesPageControl)
        view.addSubview(leftButton)
        profileImagesScrollView.delegate = self
        getProfileImages()
    }
    
    func configureViewComponent() {
        self.view.backgroundColor = .systemBackground
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        profileImagesScrollView.frame = view.bounds
        profileImagesPageControl.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-30)
            $0.centerX.equalToSuperview()
        }
        leftButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.height.width.equalTo(44)
        }
//        configureScrollView()
//        if profileImagesScrollView.subviews.count == 2 {
//            configureScrollView()
//        }
    }
    
    @objc private func pageControlDidChange(_ sender: UIPageControl) {
        let current = sender.currentPage
        profileImagesScrollView.setContentOffset(CGPoint(x: CGFloat(current) * view.frame.size.width, y: 0), animated: true)
    }
    
    @objc private func buttonPressed(_ sender: Any) {
        DispatchQueue.main.async {
            self.dismiss(animated: true)
        }
    }
    
    private func configureScrollView() {
        self.profileImagesScrollView.contentSize = CGSize(width: view.frame.size.width * CGFloat(profileImages.count), height: profileImagesScrollView.frame.size.height)
        profileImagesScrollView.isPagingEnabled = true
        for x in 0..<profileImages.count {
            print("configure")
            let imageView = UIImageView(frame: CGRect(x: CGFloat(x) * view.frame.size.width, y: view.safeAreaInsets.top + leftButton.frame.size.height/2, width: view.frame.size.width, height: view.safeAreaLayoutGuide.layoutFrame.size.height - leftButton.frame.size.height))
            print(profileImages[x].size)
            // view.safeAreaLayoutGuide.layoutFrame.size.height - leftButton.frame.size.height
                imageView.clipsToBounds = true
                imageView.contentMode = .scaleAspectFit
                imageView.image = profileImages[x]
                profileImagesScrollView.addSubview(imageView)
        }
    }
    
//    private func updateProfileImages() {
//        for x in 0..<profileImages.count {
//            print("configure update images")
//            let imageView = UIImageView(frame: CGRect(x: CGFloat(x) * view.frame.size.width, y: 0, width: view.frame.size.width, height: profileImagesScrollView.frame.size.height))
//                imageView.clipsToBounds = true
//                imageView.contentMode = .scaleAspectFit
//                imageView.image = profileImages[x]
//                print(imageView)
//                profileImagesScrollView.addSubview(imageView)
//        }
//    }
    
    func getProfileImages() {
        guard let userItem = try? KeychainManager.getUserItem() else { return }
        print(userItem.userId)
        AF.request(API.BASE_URL + "users/image/\(userItem.userId)",
                   method: .get,
                   parameters: nil,
                   encoding: JSONEncoding.default)
            .validate(statusCode: 200..<500)
            .responseData { response in
            switch response.result {
            case .success:
                debugPrint(response)
                guard let data = response.value else { return }
                do{
                    let decodedData = try JSONDecoder().decode(APIResponse<UserProfileImages>.self, from: data)
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
                        self.profileImages = getImages
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

extension SearchProfileImagesViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        profileImagesPageControl.currentPage = Int(floorf(Float(scrollView.contentOffset.x) / Float(scrollView.frame.size.width)))
        print("scrollViewDidScroll")
    }
}
