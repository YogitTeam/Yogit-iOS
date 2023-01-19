//
//  MoveVC.swift
//  Yogit
//
//  Created by Junseo Park on 2022/11/26.
//

//import UIKit
//import SnapKit
//
//class MoveVC: UIViewController {
//
//    private var profileImage: UIImage? = nil
//    
//    private lazy var moveButton: UIButton = {
//        let button = UIButton()
//        button.addTarget(self, action: #selector(moveButtonPress), for: .touchUpInside)
//        button.backgroundColor = .blue
//        return button
//    }()
//    
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.addSubview(moveButton)
//        view.backgroundColor = .systemBackground
//        // Do any additional setup after loading the view.
//    }
//    
//    override func viewDidLayoutSubviews() {
//        moveButton.snp.makeConstraints { make in
//            make.leading.trailing.equalToSuperview().inset(20)
//            make.height.equalTo(50)
//            make.center.equalToSuperview()
//        }
//    }
//    
//    @objc func moveButtonPress() {
////        DispatchQueue.main.async(execute: {
////            let PICV = ProfileImagesViewController()
////            PICV.delegate = self
////            self.navigationController?.pushViewController(PICV, animated: true)
////        })
//    }
//    
//    
//
//
//    /*
//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destination.
//        // Pass the selected object to the new view controller.
//    }
//    */
//
//}
//
//extension MoveVC: ImagesProtocol {
//    func imagesSend(profileImage: UIImage) {
//        self.profileImage = profileImage
//    }
//}
