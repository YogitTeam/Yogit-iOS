//
//  UINavigationController+Extensions.swift
//  Yogit
//
//  Created by Junseo Park on 2023/01/09.
//

import Foundation
import UIKit

extension UITabBarController {
//    func setBackgroundColor() {
//        navigationBar.barTintColor = UIColor.white
//        navigationBar.isTranslucent = false
//    }
    
    func makeNaviTopLabel(title: String) {
        let titleLabel = UILabel()
        titleLabel.textColor = .label
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: titleLabel)
    }
    
    func makeNaviTopButton(_ target: Any?, action: Selector, named: String) -> UIBarButtonItem {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: named), for: .normal)
        button.addTarget(target, action: action, for: .touchUpInside)
        button.tintColor = .label
            
        let barButtonItem = UIBarButtonItem(customView: button)
        barButtonItem.customView?.translatesAutoresizingMaskIntoConstraints = false
        barButtonItem.customView?.heightAnchor.constraint(equalToConstant: 24).isActive = true
        barButtonItem.customView?.widthAnchor.constraint(equalToConstant: 24).isActive = true
        
        return barButtonItem
    }
}
