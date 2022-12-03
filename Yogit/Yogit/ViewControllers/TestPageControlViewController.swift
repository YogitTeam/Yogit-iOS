//
//  TestPageControlViewController.swift
//  Yogit
//
//  Created by Junseo Park on 2022/12/01.
//

import UIKit
import SnapKit

class TestPageControlViewController: UIViewController,UIScrollViewDelegate {
    var images = [UIImage(named: "1")!, UIImage(named: "1")!]
    var imageViews = [UIImageView]()
    
    private lazy var pageControl: UIPageControl = {
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
        
        pageControl.addTarget(self, action: #selector(pageControlDidChange(_:)), for: .valueChanged)
        pageControl.frame = CGRect(x: 0, y: view.frame.size.width - 10, width: view.frame.size.width, height: 10)
//        profileImageView.image = u
        return pageControl
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.alwaysBounceVertical = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.isScrollEnabled = true
        scrollView.backgroundColor = .systemBackground
//        scrollView.isPagingEnabled = true
        scrollView.backgroundColor = .red
//        CGRect(origin: .zero, size: CGSize(width: view.frame.size.width, height: view.frame.size.width))
        scrollView.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.width)
//        scrollView.bounces = false // 경계지점에서 bounce될건지 체크 (첫 or 마지막 페이지에서 바운스 스크롤 효과 여부)
        return scrollView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(scrollView)
        view.addSubview(pageControl)
        scrollView.delegate = self
        addContentScrollView()
        setPageControl()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
    }

    override func viewDidLayoutSubviews() {
//        scrollView.snp.makeConstraints {
////            $0.top.equalTo(UIScreen.main.snp.top)
//            $0.top.leading.trailing.equalToSuperview()
//            $0.height.equalTo(view.frame.size.width)
//        }
//
//        pageControl.snp.makeConstraints {
////            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-30)
//            $0.center.equalToSuperview()
//            $0.height.equalTo(10)
//        }
    }
    
    private func addContentScrollView() {
        
        for i in 0..<images.count {
            let imageView = UIImageView()
            let xPos = scrollView.frame.width * CGFloat(i)
            imageView.frame = CGRect(x: xPos, y: scrollView.bounds.minY, width: scrollView.bounds.width, height: scrollView.bounds.height)
            imageView.image = images[i]
            scrollView.addSubview(imageView)
            scrollView.contentSize.width = imageView.frame.width * CGFloat(i + 1)
            scrollView.contentSize.height = imageView.frame.height
        }
        
    }
    
    private func setPageControl() {
        pageControl.numberOfPages = images.count
        
    }
    
    @objc private func pageControlDidChange(_ sender: UIPageControl) {
        let current = sender.currentPage
        scrollView.setContentOffset(CGPoint(x: CGFloat(current) * view.frame.size.width, y: 0), animated: true)
    }
    
    private func setPageControlSelectedPage(currentPage:Int) {
        pageControl.currentPage = currentPage
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let value = scrollView.contentOffset.x/scrollView.frame.size.width
        setPageControlSelectedPage(currentPage: Int(round(value)))
    }

}
