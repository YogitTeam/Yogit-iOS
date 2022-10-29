//
//  ImageViewController.swift
//  Yogit
//
//  Created by Junseo Park on 2022/10/04.
//

import UIKit

class ImageViewController: UIViewController {
    let picker = UIImagePickerController()

    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.profileImageViewTapped(_:))))
        imageView.layer.borderColor = UIColor.systemBlue.cgColor
        imageView.layer.borderWidth = 1
        return imageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(profileImageView)
        configureViewComponent()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        profileImageView.snp.makeConstraints { make in
            make.left.right.equalTo(view).inset(100)
            make.height.equalTo(100)
            make.top.equalTo(view.snp.top).inset(100)
        }
    }
    
    private func configureViewComponent() {
        view.backgroundColor = .systemBackground
    }
    
    @objc func profileImageViewTapped(_ sender: UITapGestureRecognizer) {
        print("imageview tapped")
        let alert = UIAlertController(title: "원하는 타이틀", message: "원하는 메세지", preferredStyle: .actionSheet)
        let library = UIAlertAction(title: "사진앨범", style: .default) { (action) in self.openLibrary() }
        let camera = UIAlertAction(title: "카메라", style: .default) { (action) in self.openCamera()}
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        [library, camera, cancel].forEach { alert.addAction($0) }
        present(alert, animated: true, completion: nil)
    }
    
    func openLibrary() {
        picker.sourceType = .photoLibrary
        present(picker, animated: false, completion: nil)
    }
    
    func openCamera() {
        picker.sourceType = .camera
        present(picker, animated: false, completion: nil)
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
