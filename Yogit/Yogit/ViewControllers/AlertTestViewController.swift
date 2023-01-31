//
//  AlertTestViewController.swift
//  Yogit
//
//  Created by Junseo Park on 2023/01/31.
//

import UIKit
import BLTNBoard
import SnapKit
//import CustomBulletins

/**
 * A view controller displaying a set of images.
 *
 * This demonstrates how to set up a bulletin manager and present the bulletin.
 */

class AlertTestViewController: UIViewController {

    private lazy var testButton: UIButton = {
        let button = UIButton()
//        button.setTitle("Done", for: .normal)
//        button.setImage(UIImage(named: "push")?.withTintColor(.white, renderingMode: .alwaysOriginal), for: .normal)
        button.tintColor = .white
        button.setTitle("Test", for: .normal)
        button.layer.cornerRadius = 25
        button.isHidden = false
        button.backgroundColor = .blue
        button.addTarget(self, action: #selector(self.testButtonTapped(_:)), for: .touchUpInside)
        return button
    }()

    lazy var bulletinManager: BLTNItemManager = {
        
        let item = BLTNPageItem(title: "Apply group")
        item.image = "👋".stringToImage(width: 100, height: 100)//UIImage(named: "pro1")
//        item.imageAccessibilityLabel = "👋"
        item.actionButtonTitle = "Apply"
        item.alternativeButtonTitle = "Cancel"
        item.descriptionText = "Would you want to join this group?"
        item.appearance.actionButtonColor = .blue
        item.appearance.alternativeButtonTitleColor = .gray
        item.actionHandler = { _ in
            self.didTapped()
        }
        item.alternativeHandler = { _ in
            print("Tap alter ")
        }
        return BLTNItemManager(rootItem: item)
    }()
    

    // MARK: - View

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(testButton)
    }

    override func viewDidLayoutSubviews() {
        testButton.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalTo(100)
        }
    }
    
    func didTapped() {
        print("Did tapped")
    }

    @objc func testButtonTapped(_ sender: UIButton) {
        print("Tap testButtonTapped")
        bulletinManager.showBulletin(above: self)
    }
    
}


extension String {
    func stringToImage(width: CGFloat, height: CGFloat) -> UIImage? {
        let size = CGSize(width: width, height: height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        UIColor.white.set()
        let rect = CGRect(origin: .zero, size: size)
        UIRectFill(CGRect(origin: .zero, size: size))
        (self as AnyObject).draw(in: rect, withAttributes: [.font: UIFont.systemFont(ofSize: height*0.9)])
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
