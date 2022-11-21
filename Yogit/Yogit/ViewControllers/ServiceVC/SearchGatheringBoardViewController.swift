//
//  SecondSetUpUserInfoViewController.swift
//  Yogit
//
//  Created by Junseo Park on 2022/09/23.
//

import UIKit
import SnapKit

class SearchGatheringBoardController: UIViewController {

    private lazy var boardButton: UIButton = {
        let button = UIButton()
//        button.setTitle("", for: .normal)
//        button.imageView?.image = UIImage(named: "imageNULL")
        button.setImage(UIImage(named: "imageNULL"), for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 24
        button.isEnabled = true
        button.backgroundColor = UIColor(rgb: 0x3232FF, alpha: 1.0)
        button.addTarget(self, action: #selector(self.boardButtonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(boardButton)
        configureViewComponent()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        boardButton.snp.makeConstraints { make in
            make.width.height.equalTo(48)
            make.bottom.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
    
    private func configureViewComponent() {
        view.backgroundColor = .systemBackground
        
    }
    
    @objc func boardButtonTapped(_ sender: UIButton) {
        DispatchQueue.main.async(execute: {
            let GBCVC = GatheringBoardCategoryViewController()
            self.navigationController?.pushViewController(GBCVC, animated: true)
        })
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
