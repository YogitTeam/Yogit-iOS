//
//  SearchProfileImagesViewController.swift
//  Yogit
//
//  Created by Junseo Park on 2022/11/26.
//

import UIKit
import SnapKit
import Alamofire

class GetProfileImagesViewController: UIViewController {

//    private var profileImages: [UIImage] = [] {
//        didSet {
//            DispatchQueue.main.async {
//                self.profileImagesPageControl.numberOfPages = self.profileImages.count
//                self.configureScrollView()
//            }
//            print("Profile images update")
//        }
//    }
//
    var profileImages: [String] = [] {
        didSet {
            if self.profileImages.count >= 2 {
                self.profileImagesPageControl.numberOfPages = self.profileImages.count
            }
            DispatchQueue.main.async { [weak self] in
                self?.configureScrollView()
            }
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
        // 현재 페이지 표시 색상
        pageControl.currentPageIndicatorTintColor = .white// ServiceColor.primaryColor
        pageControl.backgroundColor = .clear
        
        pageControl.addTarget(self, action: #selector(pageControlDidChange(_:)), for: .valueChanged)
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
        scrollView.bounces = true // 경계지점에서 bounce될건지 체크 (첫 or 마지막 페이지에서 바운스 스크롤 효과 여부)
        return scrollView
    }()
    
    private lazy var leftButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "DELETE")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.addTarget(self, action: #selector(leftButtonPressed(_:)), for: .touchUpInside)
        button.tintColor = .white
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewComponent()
        configureLayout()
//        getProfileImages()
    }
    
    private func configureViewComponent() {
        view.backgroundColor = .systemBackground
        view.addSubview(profileImagesScrollView)
        view.addSubview(profileImagesPageControl)
        view.addSubview(leftButton)
        view.backgroundColor = .systemBackground
    }
    
    private func configureLayout() {
        profileImagesScrollView.frame = view.bounds
        profileImagesPageControl.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-30)
            $0.centerX.equalToSuperview()
        }
        leftButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.height.width.equalTo(44)
        }
    }
    
    @objc private func pageControlDidChange(_ sender: UIPageControl) {
        let current = sender.currentPage
        profileImagesScrollView.setContentOffset(CGPoint(x: CGFloat(current) * view.frame.size.width, y: 0), animated: true)
    }
    
    @objc private func leftButtonPressed(_ sender: Any) {
        DispatchQueue.main.async {
            self.dismiss(animated: true)
        }
    }
    
    private func configureScrollView() {
        profileImagesScrollView.delegate = self
        profileImagesScrollView.contentSize = CGSize(width: view.frame.size.width * CGFloat(profileImages.count), height: profileImagesScrollView.frame.size.height)
        profileImagesScrollView.isPagingEnabled = true
        for x in 0..<profileImages.count {
            print("configure")
            let imageView = UIImageView(frame: CGRect(x: CGFloat(x) * view.frame.size.width, y: view.safeAreaInsets.top + leftButton.frame.size.height/2, width: view.frame.size.width, height: view.safeAreaLayoutGuide.layoutFrame.size.height - leftButton.frame.size.height))
            print(profileImages[x].size)
            imageView.clipsToBounds = true
            imageView.contentMode = .scaleAspectFit
//                imageView.image = profileImages[x]
            imageView.setImage(with: profileImages[x]) // caching 처리
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
    
//    func getProfileImages() {
//        guard let userItem = try? KeychainManager.getUserItem() else { return }
//        print(userItem.userId)
//        let getUserProfileImages = GetUserProfileImages(refreshToken: userItem.refresh_token, userId: userItem.userId)
////        AlamofireManager.shared.session
////            .request(SearchProfileRouter.searchProfileImages(parameters: getUserProfileImages))
////            .validate(statusCode: 200..<501)
////            .responseDecodable(of: APIResponse<SearchUserProfile>.self) { response in
////                switch response.result {
////                case .success:
////                    guard let value = response.value else { return }
////                    if value.httpCode == 200 {
////                        guard let data = value.data else { return }
////                        DispatchQueue.global(qos: .userInitiated).async {
////                            let langCnt = data.languageNames.count
////                            var langInfos: String = ""
////                            for i in 0..<langCnt {
////                                langInfos += "\(data.languageNames[i]) (\(data.languageLevels[i])), "
////                            }
////                            langInfos.removeLast()
////                            langInfos.removeLast()
////                            DispatchQueue.main.async(qos: .userInteractive, execute: { [self] in
////                                profileImages = data.
////
////                            })
////                            self.essentialProfile.profileImage = data.profileImg
////                            self.essentialProfile.userName = data.name
////                            self.essentialProfile.nationality = data.nationality
////                            self.essentialProfile.userAge = data.age
////                            self.essentialProfile.gender = data.gender
////                            self.essentialProfile.languageNames = data.languageNames
////                            self.essentialProfile.languageLevels = data.languageLevels
////                        }
////                    }
////                case let .failure(error):
////                    print("SearchProfileVC - upload response result Not return", error)
////                }
////            }
////
////
//        AF.request(API.BASE_URL + "users/image/\(userItem.userId)",
//                   method: .post,
//                   parameters: getUserProfileImages,
//                   encoder: URLEncodedFormParameterEncoder(destination: .httpBody))
//            .validate(statusCode: 200..<500)
//            .responseData { response in
//            switch response.result {
//            case .success:
//                debugPrint(response)
//                guard let data = response.value else { return }
//                do {
//                    let decodedData = try JSONDecoder().decode(APIResponse<FetchedUserImages>.self, from: data)
//                    DispatchQueue.global().async {
//                        print(decodedData.data?.imageUrls)
//                        guard let imageUrls = decodedData.data?.imageUrls else {
//                            print("imageUrls null")
//                            return
//                        }
//                        var getImages: [UIImage] = []
//                        print("get imageUrls \(imageUrls)")
//                        for imageUrl in imageUrls {
//                            imageUrl.urlToImage { (image) in
//                                guard let image = image else { return }
//                                getImages.append(image)
//                            }
//                        }
////                        getImages.append(UIImage(named: "pro1")!)
////                        getImages.append(UIImage(named: "pro2")!)
//                        self.profileImages = getImages
//                    }
//                }
//                catch{
//                    print(error.localizedDescription)
//                }
//            case let .failure(error):
//                print(error)
//            }
//        }
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

extension GetProfileImagesViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        profileImagesPageControl.currentPage = Int(floorf(Float(scrollView.contentOffset.x) / Float(scrollView.frame.size.width)))
        print("scrollViewDidScroll")
    }
}

