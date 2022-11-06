//
//  Layer.swift
//  Yogit
//
//  Created by Junseo Park on 2022/10/09.
//

import Foundation
import UIKit

extension CALayer {
    func addBorder(arr_edge: [UIRectEdge], color: UIColor?, width: CGFloat) {
        for edge in arr_edge {
            let border = CALayer()
            switch edge {
                case UIRectEdge.top: border.frame = CGRect.init(x: 0, y: 0, width: frame.width, height: width)
                break
                case UIRectEdge.bottom: border.frame = CGRect.init(x: 0, y: self.frame.height - width, width: self.frame.width, height: width)
                    break
                case UIRectEdge.left: border.frame = CGRect.init(x: 0, y: 0, width: width, height: frame.height)
                break
                case UIRectEdge.right: border.frame = CGRect.init(x: frame.width - width, y: 0, width: width, height: frame.height)
                break
                default:
                break
            }
            border.backgroundColor = color?.cgColor
            self.addSublayer(border)
        }
    }
}

extension CALayer {

    enum ViewSide {
        case Left, Right, Top, Bottom
    }

    func addViewBorder(withColor color: UIColor, width: CGFloat) {
       
        let border = CALayer()
        border.backgroundColor = color.cgColor
        // origin
//        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width: self.frame.size.width, height:width)
        
        // coustom
        border.frame = CGRect(x: 20, y: self.frame.size.height - width, width: self.frame.size.width - 40, height: width)
        self.addSublayer(border)
//        self.layer.addSublayer(border)
    }
    
    func removeViewBorder(withColor color: UIColor, width: CGFloat) {
       
        let border = CALayer()
        border.backgroundColor = color.cgColor
        // origin
//        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width: self.frame.size.width, height:width)
        
        // coustom
        border.frame = CGRect(x: 20, y: self.frame.size.height - width, width: self.frame.size.width - 40, height: width)
        border.removeFromSuperlayer()
//        self.layer.addSublayer(border)
    }
    
//    func addBottomBorder(withColor color: UIColor, toLayer layer: CALayer, onFrame frame: CGRect, withWidth width: CGFloat) {
//        let border = CALayer()
//        border.borderColor = color.cgColor
//        border.frame = CGRect(x: 0, y: self.frame.size.height + width*4, width: self.frame.size.width, height: self.frame.size.height)
//        border.borderWidth = width
//        layer.addSublayer(border)
//        layer.masksToBounds = true
//    }
}
