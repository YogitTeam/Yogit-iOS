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
        // Access to the 'Photos' app is required.
        // Access to the '%@' app is required.
        // '%@'앱의 접근 권한이 필요합니다.
        // AUTHORIZATION_ALERT_TITLE
        // AUTHORIZATION_ALERT_MESSAGE "\(type) 권한을 허용하여야 해당 기능을 사용하실 수 있습니다."
        
        let title = String(format: "AUTHORIZATION_ALERT_TITLE".localized(), "\(type)")
        let message = String(format: "AUTHORIZATION_ALERT_MESSAGE".localized(), "\(type)")
        let authAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "CANCEL".localized(), style: .cancel, handler: nil)
        let getAuthAction = UIAlertAction(title: "SET_AUTHORIZATION_SETTING".localized(), style: .default, handler: { (UIAlertAction) in
            if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(appSettings,options: [:],completionHandler: nil)
            }
        })

        authAlertController.addAction(cancel)
        authAlertController.addAction(getAuthAction)
        DispatchQueue.main.async {
            self.present(authAlertController, animated: true, completion: nil)
        }
    }
}

