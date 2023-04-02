//
//  UIViewController+Extensions.swift
//  Yogit
//
//  Created by Junseo Park on 2023/01/12.
//

import UIKit

//extension UIViewController {
//    func hideKeyboardWhenTappedAroundInVC() {
//        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
//        tap.cancelsTouchesInView = false
//        view.addGestureRecognizer(tap)
//    }
//    
//    @objc private func dismissKeyboard() {
//        view.endEditing(true)
//    }
//}

extension UIViewController {
    func setAuthAlertAction(_ type: String) {
        let authAlertController = UIAlertController(title: "\(type) 사용 권한이 필요합니다.", message: "\(type) 권한을 허용하여야 해당 기능을 사용하실 수 있습니다.", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let getAuthAction = UIAlertAction(title: "Setting", style: .default, handler: { (UIAlertAction) in
            if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(appSettings,options: [:],completionHandler: nil)
            }
        })

        authAlertController.addAction(cancel)
        authAlertController.addAction(getAuthAction)

        self.present(authAlertController, animated: true, completion: nil)
    }
}

