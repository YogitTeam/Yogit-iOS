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
  func addleftimage(image: UIImage?) {
      guard let image = image else { return }
      let leftimage = UIImageView(frame: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
      
      leftimage.image = image
      self.leftView = leftimage
      self.leftViewMode = .always
  }
}
