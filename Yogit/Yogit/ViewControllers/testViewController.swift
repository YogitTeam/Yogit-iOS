//
//  ProfileViewController.swift
//  Yogit
//
//  Created by Junseo Park on 2022/09/11.
//

// 셀업데이트 하면서 모든값 저장
// 피커뷰 donpress 누르면 값 저장 후 reload
// 피커뷰 나눠야댐 >> 누른 textfield 에따라 피커뷰 데이터 종류 구분

import UIKit

// click sign up >> post
//struct UserProfile {
//    var age: String?
//    var language1: String?
//    var level1: String?
//    var language2: String?
//    var level2: String?
//    var language3: String?
//    var level3: String?
//    var language4: String?
//    var level4: String?
//    var language5: String?
//    var level5: String?
//    var gender: String?
//    var nationality: String?
//    var name: String?
//}

//enum SectionData: Int {
//    case name = 0
//    case age
//    case languages
//    case gender
//    case nationality
//}

class testViewController: UIViewController, ImagesProtocol {
    
    private lazy var testButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(rgb: 0x3232FF, alpha: 1.0)
        button.setTitle("Save", for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 8
        button.backgroundColor = .placeholderText
        button.addTarget(self, action: #selector(self.moveButtonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(testButton)
        configureViewComponent()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        testButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(100)
            make.height.equalTo(44)
            make.width.equalToSuperview()
        }
    }
    
    @objc func moveButtonTapped(_ sender: UIButton) {
        DispatchQueue.main.async {
            let PICV = ProfileImagesViewController()
            PICV.delegate = self
            self.navigationController?.pushViewController(PICV, animated: true)
        }
    }
    
    private func configureViewComponent() {
        view.backgroundColor = .systemBackground
    }
    
    func imagesSend(profileImage: UIImage?) {
        print("imagesend")
    }
    
}
