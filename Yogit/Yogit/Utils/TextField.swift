//
//  TextField.swift
//  Yogit
//
//  Created by Junseo Park on 2022/11/12.
//

import Foundation
import UIKit

extension UITextField {
  func addLeftPadding() {
      let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: self.frame.height))
      self.leftView = paddingView
//      self.leftViewMode = .always
      self.leftViewMode = ViewMode.always
  }
    func addRightPadding() {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: self.frame.height))
        self.rightView = paddingView
  //      self.leftViewMode = .always
        self.rightViewMode = ViewMode.always
    }
  func addLeftimage(image: UIImage?) {
      guard let image = image else { return }
      let leftImage = UIImageView(frame: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
      leftImage.image = image
      self.leftView = leftImage
      self.leftViewMode = .always
  }
    func addrightimage(image: UIImage?) {
        guard let image = image else { return }
        let rightimage = UIImageView(frame: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
        rightimage.image = image
        self.rightView = rightimage
        self.rightViewMode = .always
    }
    
    func addrightView(view: UIView?) {
        guard let view = view else { return }
        let rightView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
//        rightImage.image = view
        self.rightView = view
        self.rightViewMode = .always
    }
}
