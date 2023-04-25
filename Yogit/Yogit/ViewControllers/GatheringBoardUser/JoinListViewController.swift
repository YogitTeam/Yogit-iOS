//
//  JoinListViewController.swift
//  Yogit
//
//  Created by Junseo Park on 2023/02/02.
//

import UIKit
import BLTNBoard

class JoinListViewController: UIViewController {

//    private lazy var clipBoardButton: UIButton = {
//        let button = UIButton()
//        button.translatesAutoresizingMaskIntoConstraints = false
//        button.backgroundColor = ServiceColor.primaryColor
//        button.layer.cornerRadius = 8
//        button.tintColor = .white
//        button.setImage(UIImage(named: "BoardClipBoard")?.withTintColor(.white, renderingMode: .alwaysTemplate), for: .normal)
//        button.setTitle("CLIPBOARD".localized(), for: .normal)
//        button.titleLabel?.font = .systemFont(ofSize: 17, weight: UIFont.Weight.semibold)
//        button.setTitleColor(.white, for: .normal)
//        button.isEnabled = true
//        button.isHidden = true
//        button.isSkeletonable = true
//        button.addTarget(self, action: #selector(self.clipBoardTapped(_:)), for: .touchUpInside)
//        return button
//    }()
    
    private lazy var joinedBulletinManager: BLTNItemManager = {
        
        let page = BLTNPageItem(title: "JOINED_GATHERING_TITLE".localized())
        page.image = UIImage(named: "COMPLETION")?.withTintColor(ServiceColor.primaryColor)
        page.actionButtonTitle = "CLIPBOARD".localized()
        page.descriptionText = "\("💬") \("JOINED_GATHERING_DESCRIPTION".localized())"
        page.appearance.actionButtonColor = ServiceColor.primaryColor
        
    
        page.actionHandler = { item in
            item.manager?.dismissBulletin(animated: true)
        }
        return BLTNItemManager(rootItem: page)
    }()
    
    private lazy var withDrawedBulletinManager: BLTNItemManager = {
        
        let item = BLTNPageItem(title: "WITHDRAWAL_GATHERING_TITLE".localized())
        item.image = UIImage(named: "COMPLETION")?.withTintColor(ServiceColor.primaryColor)
        item.descriptionText = "WITHDRAWAL_GATHERING_DESCRIPTION".localized()

        return BLTNItemManager(rootItem: item)
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        joinedBulletinManager.showBulletin(above: self)
        // Do any additional setup after loading the view.
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
