//
//  ProfileImagesViewController.swift
//  Yogit
//
//  Created by Junseo Park on 2022/10/13.
//

import UIKit

class ProfileImagesViewController: UIViewController {

    let picker = UIImagePickerController()
    
    var imageViewIdx = 0
    
    // image
    private var images = [UIImage?](repeating: nil, count: 6)
    
//    private var imageViews = [UIImageView](repeating: nil, count: 6)
    
    // []    []
    //       []
    // [] [] []
    
    // imageview
//    private lazy var profileImageView: UIImageView = {
//        let imageView = UIImageView()
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//        imageView.backgroundColor = .placeholderText
//        imageView.isUserInteractionEnabled = true
//        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.imageViewTapped(_:))))
//        return imageView
//    }()
    
//    // imageview
    private lazy var imageView1: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .placeholderText
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.imageViewTapped(_:))))
        return imageView
    }()
    
    private lazy var imageView2: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .placeholderText
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.imageViewTapped(_:))))
        return imageView
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .placeholderText
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.imageViewTapped(_:))))
        return imageView
    }()
    
//    // imageview
//    private lazy var imageViews: [UIImageView] = {
//        let imageViews = [UIImageView](repeating: UIImageView(), count: 6)
////        imageViews.translatesAutoresizingMaskIntoConstraints = false
////        for imageView in imageViews {
////            imageView.backgroundColor = .placeholderText
////            imageView.isUserInteractionEnabled = true
////            imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.imageViewTapped(_:))))
////        }
//        imageViews.forEach {
//            $0.backgroundColor = .placeholderText
//            $0.isUserInteractionEnabled = true
//            $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.imageViewTapped(_:))))
//        }
////        imageViews.backgroundColor = .placeholderText
////        imageViews.isUserInteractionEnabled = true
////        imageViews.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.imageViewTapped(_:))))
//        return imageViews
//    }()
//
//    private lazy var imagesHorizontalStackView: UIStackView = {
//        let stackView = UIStackView()
//        stackView.layer.borderColor = UIColor.systemRed.cgColor
//        stackView.layer.borderWidth = 1
//        stackView.axis = .horizontal
//
////        stackView.alignment = .fill
////        stackView.distribution = .fill
//
//        stackView.spacing = 10
//
//        [self.imageViews[3],
//         self.imageViews[4]].forEach { stackView.addArrangedSubview($0) }
//        return stackView
//    }()
//
//    // Inculde big size profile imageView
//    private lazy var firstVerticalStackView: UIStackView = {
//        let stackView = UIStackView()
//        stackView.layer.borderColor = UIColor.systemRed.cgColor
//        stackView.layer.borderWidth = 1
//        stackView.axis = .vertical
//
////        stackView.alignment = .fill
////        stackView.distribution = .fill
//
//        stackView.spacing = 10
//
//        [self.imageViews[0],
//         self.imagesHorizontalStackView].forEach { stackView.addArrangedSubview($0) }
//        return stackView
//    }()
    
    // Inculde imageViews
    private lazy var secondVerticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.layer.borderColor = UIColor.systemRed.cgColor
        stackView.layer.borderWidth = 1
        stackView.axis = .vertical
        
//        stackView.alignment = .fill
//        stackView.distribution = .fill
        
        stackView.spacing = 10
        
        [self.imageView,
         self.imageView,
         self.imageView].forEach { stackView.addArrangedSubview($0) }
        return stackView
    }()
    
   
    
//    private let imageViews = Array(imageView)
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        imageViews.forEach { view.addSubview($0) }
//        view.addSubview(firstVerticalStackView)
        view.addSubview(secondVerticalStackView)
        picker.delegate = self
        configureViewComponent()
        // Do any additional setup after loading the view.
    }
    
    
    override func viewDidLayoutSubviews() {
//        configureImageViewsComponent()
        
//        imagesHorizontalStackView.snp.makeConstraints { make in
//            make.top.left.equalToSuperview().inset(20)
//        }
        
        imageView.snp.makeConstraints { make in
            make.width.height.equalTo(100)
        }
//        imageView2.snp.makeConstraints { make in
//            make.width.height.equalTo(100)
//        }
//        imageView3.snp.makeConstraints { make in
//            make.width.height.equalTo(100)
//        }
        
//        imageViews[0].snp.makeConstraints { make in
//            make.width.height.equalTo((view.frame.width - 40 - 10) * 2/3)
//        }
//
//        imageViews[1].snp.makeConstraints { make in
//            make.width.height.equalTo((view.frame.width - 40 - 10) * 1/3)
//        }
//
//        imageViews[2].snp.makeConstraints { make in
//            make.width.height.equalTo((view.frame.width - 40 - 10) * 1/3)
//        }
//
//        imageViews[3].snp.makeConstraints { make in
//            make.width.height.equalTo((view.frame.width - 40 - 10) * 1/3)
//        }
//
//        imageViews[4].snp.makeConstraints { make in
//            make.width.height.equalTo((view.frame.width - 40 - 10) * 1/3)
//        }
//
//        imageViews[5].snp.makeConstraints { make in
//            make.width.height.equalTo((view.frame.width - 40 - 10) * 1/3)
//        }
        
//        firstVerticalStackView.snp.makeConstraints { make in
//            make.top.left.equalToSuperview().inset(20)
//        }
        
        secondVerticalStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20)
            make.right.equalToSuperview().inset(20)
//            make.left.equalTo(firstVerticalStackView.snp.right).offset(10)
        }
        
//        imageView.snp.makeConstraints { make in
//            // width & height = super view 좌우 공백 20씩 뺴고 - 간격 10 * 2/3
//            make.width.height.equalTo((view.frame.width - 40 - 10) * 2/3)
//        }
//
//        imageView.snp.makeConstraints { make in
//            make.width.height.equalTo((view.frame.width - 40 - 10) * 1/3)
//        }
//
//        imageViews[0].snp.makeConstraints { make in
//            make.width.height.equalTo((view.frame.width - 40 - 10) * 1/3)
//        }
        
    }
    
    private func configureViewComponent() {
        view.backgroundColor = .systemBackground
    }
    
//    private func configureImageViewsComponent() {
////        profileImageView.layer.cornerRadius = 4
////        imageView.layer.cornerRadius = 4
////        profileImageView.clipsToBounds = true
////        imageView.clipsToBounds = true
//
//        print("View width: \(view.frame.width)")
//        print("View height: \(view.frame.height)")
//
//        for i in 0..<imageViews.count {
//            switch i {
//            case 0:
//                imageViews[i].snp.makeConstraints { make in
//                    make.width.height.equalTo((view.frame.width - 40 - 10) * 2/3)
//                }
//            default:
//                imageViews[i].snp.makeConstraints { make in
//                    make.width.height.equalTo((view.frame.width - 40 - 10) * 1/3)
//                }
//            }
//            print("imageViews[\(i)] width: \(imageViews[i].frame.width)")
//            print("imageViews[\(i)] height: \(imageViews[i].frame.height)")
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

extension ProfileImagesViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func openLibrary() {
        picker.sourceType = .photoLibrary
        present(picker, animated: false, completion: nil)
    }
    
    func openCamera() {
        picker.sourceType = .camera
        present(picker, animated: false, completion: nil)
    }
    
    // 터치 할때 인덱스 바꿔줌
    @objc func imageViewTapped(_ sender: UITapGestureRecognizer) {
        let alert = UIAlertController(title: "원하는 타이틀", message: "원하는 메세지", preferredStyle: .actionSheet)
        let library = UIAlertAction(title: "사진앨범", style: .default) { (action) in self.openLibrary()}
        let camera = UIAlertAction(title: "카메라", style: .default) { (action) in self.openCamera()}
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alert.addAction(library)
        alert.addAction(camera)
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
    }
    
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        // action 각기 다르게
//        if let img = info[UIImagePickerController.InfoKey.originalImage] {
////            let image = img as? UIImage
//            let image = img as? UIImage
//            images.append(image)
//            imageViews[images.count - 1].image = image
//        }
//        dismiss(animated: true, completion: nil)
//    }
}

