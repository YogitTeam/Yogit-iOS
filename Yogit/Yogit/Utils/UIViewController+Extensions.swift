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
    func showPopUpTwo(title: String? = nil,
                   message: String? = nil,
                   attributedMessage: NSAttributedString? = nil,
                   leftActionTitle: String? = "취소",
                   rightActionTitle: String = "확인",
                   leftActionCompletion: (() -> Void)? = nil,
                   rightActionCompletion: (() -> Void)? = nil) {
        let popUpViewController = PopUpViewController(titleText: title,
                                                      messageText: message,
                                                      attributedMessageText: attributedMessage)
        showPopUpTwo(popUpViewController: popUpViewController,
                  leftActionTitle: leftActionTitle,
                  rightActionTitle: rightActionTitle,
                  leftActionCompletion: leftActionCompletion,
                  rightActionCompletion: rightActionCompletion)
    }
    
    func showPopUpTwo(contentView: UIView,
                   leftActionTitle: String? = "취소",
                   rightActionTitle: String = "확인",
                   leftActionCompletion: (() -> Void)? = nil,
                   rightActionCompletion: (() -> Void)? = nil) {
        let popUpViewController = PopUpViewController(contentView: contentView)

        showPopUpTwo(popUpViewController: popUpViewController,
                  leftActionTitle: leftActionTitle,
                  rightActionTitle: rightActionTitle,
                  leftActionCompletion: leftActionCompletion,
                  rightActionCompletion: rightActionCompletion)
    }
    
    func showPopUpOne(title: String? = nil,
                   message: String? = nil,
                   attributedMessage: NSAttributedString? = nil,
                  centerActionTitle: String = "확인",
                  centerActionCompletion: (() -> Void)? = nil) {
        let popUpViewController = PopUpViewController(titleText: title,
                                                      messageText: message,
                                                      attributedMessageText: attributedMessage)
        showPopUpOne(popUpViewController: popUpViewController,
                     centerActionTitle: centerActionTitle,
                     centerActionCompletion: centerActionCompletion)
    }

    func showPopUpOne(contentView: UIView,
                   centerActionTitle: String = "확인",
                   centerActionCompletion: (() -> Void)? = nil) {
        let popUpViewController = PopUpViewController(contentView: contentView)

        showPopUpOne(popUpViewController: popUpViewController,
                     centerActionTitle: centerActionTitle,
                     centerActionCompletion: centerActionCompletion)
    }
    
    

    private func showPopUpTwo(popUpViewController: PopUpViewController,
                           leftActionTitle: String?,
                           rightActionTitle: String,
                           leftActionCompletion: (() -> Void)?,
                           rightActionCompletion: (() -> Void)?) {
        popUpViewController.addActionToButton(title: leftActionTitle,
                                              titleColor: .systemGray,
                                              backgroundColor: .secondarySystemBackground) {
            popUpViewController.dismiss(animated: false, completion: leftActionCompletion)
        }

        popUpViewController.addActionToButton(title: rightActionTitle,
                                              titleColor: .white,
                                              backgroundColor: .blue) {
            popUpViewController.dismiss(animated: false, completion: rightActionCompletion)
        }
        present(popUpViewController, animated: false, completion: nil)
    }
    
    private func showPopUpOne(popUpViewController: PopUpViewController,
                              centerActionTitle: String,
                              centerActionCompletion: (() -> Void)?) {
        popUpViewController.addActionToButton(title: centerActionTitle,
                                              titleColor: .systemGray,
                                              backgroundColor: .secondarySystemBackground) {
            popUpViewController.dismiss(animated: false, completion: centerActionCompletion)
        }
        present(popUpViewController, animated: false, completion: nil)
    }
}
