//
//  TextField.swift
//  Yogit
//
//  Created by Junseo Park on 2022/11/12.
//

import Foundation
import UIKit
import SnapKit
extension UITextField {
    func addLeftPadding(width: CGFloat) {
      let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: self.frame.height))
      self.leftView = paddingView
//      self.leftViewMode = .always
      self.leftViewMode = ViewMode.always
  }
    func addRightPadding(width: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: self.frame.height))
        self.rightView = paddingView
  //      self.leftViewMode = .always
        self.rightViewMode = ViewMode.always
    }
  func addLeftImage(image: UIImage?) {
      guard let image = image else { return }
      let leftImage = UIImageView(frame: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
      leftImage.image = image
      self.leftView = leftImage
      self.leftViewMode = .always
  }
    
    func addLeftImageWithMargin(image: UIImage?, width: CGFloat, height: CGFloat, margin: CGFloat) {
        guard let image = image else { return }
        let imageContainerView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: self.frame.height))
        imageContainerView.layer.borderColor = UIColor.blue.cgColor
        imageContainerView.layer.borderWidth = 1
        imageContainerView.translatesAutoresizingMaskIntoConstraints = false
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
//        imageView.translatesAutoresizingMaskIntoConstraints = false

        imageContainerView.addSubview(imageView)
        
        imageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.width.equalTo(width)
            $0.height.equalTo(height)
        }
        imageContainerView.snp.makeConstraints {
            $0.width.equalTo(width+margin)
            $0.height.equalTo(self.frame.size.height)
        }
        
        self.leftView = imageContainerView
  //      self.leftViewMode = .always
        self.leftViewMode = .always
//        self.borderStyle = .roundedRect
    }
    
    func addRightImage(image: UIImage?) {
        guard let image = image else { return }
        let rightimage = UIImageView(frame: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
        rightimage.image = image
        self.rightView = rightimage
        self.rightViewMode = .always
    }
    
//    func addrightView(view: UIView?) {
//        guard let view = view else { return }
//
//        let rightView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
////        rightImage.image = view
//        self.rightView = view
//        self.rightViewMode = .always
//    }
//
    func addBottomBorderWithColor(color: UIColor, width: CGFloat) {
        self.layoutIfNeeded()
        let border = CALayer()
        border.backgroundColor = color.cgColor
//        border.borderWidth = width
//        border.frame = CGRect(x: bounds.minX,
//                              y: bounds.maxX - width,
//                              width: bounds.width,
//                              height: width)
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width: self.frame.size.width, height: width)
        self.layer.addSublayer(border)
//        self.layer.masksToBounds = true
//        return border
    }
    
    func addHeaderView(title: String) {
        let view = MyHeaderView()
        view.contentNameLabel.text = title
        view.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: view.frame.size.height)
        self.addSubview(view)
//        return border
    }
}

