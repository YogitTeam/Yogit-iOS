//
//  Layer.swift
//  Yogit
//
//  Created by Junseo Park on 2022/10/09.
//

import Foundation
import UIKit

extension CALayer {
    func addBorderWithMargin(arr_edge: [UIRectEdge], marginLeft: CGFloat, marginRight: CGFloat,color: UIColor?, width: CGFloat, marginTop: CGFloat) {
        for edge in arr_edge {
            let border = CALayer()
            switch edge {
                case UIRectEdge.top: border.frame = CGRect.init(x: marginLeft, y: 0 - marginTop, width: frame.width - marginRight, height: width)
                case UIRectEdge.bottom: border.frame = CGRect.init(x: marginLeft, y: frame.height - width + marginTop, width: self.frame.width - marginRight, height: width)
                case UIRectEdge.left: border.frame = CGRect.init(x: 0, y: 0, width: width, height: frame.height)
                case UIRectEdge.right: border.frame = CGRect.init(x: frame.width - width, y: 0, width: width, height: frame.height)
                default: break
            }
            border.backgroundColor = color?.cgColor
            addSublayer(border)
        }
    }
    
//    func addBottomBorderWithColor(color: UIColor, width: CGFloat) -> CALayer {
//        let border = CALayer()
//        border.backgroundColor = color.cgColor
////        border.frame = CGRect(x: bounds.minX,
////                              y: bounds.maxX - width,
////                              width: bounds.width,
////                              height: width)
//        border.frame = CGRect(x: 20, y: self.frame.size.height - width, width: self.frame.size.width - 40, height:width)
//        self.layer.addSublayer(border)
//        return border
////        self.borderLayer = border
//    }
}

extension CALayer {

    enum ViewSide {
        case Left, Right, Top, Bottom
    }

    func addViewBottomBorderWithLeftMargin(withColor color: UIColor, width: CGFloat, margin: CGFloat) {
       
        let border = CALayer()
        border.backgroundColor = color.cgColor
        // origin
//        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width: self.frame.size.width, height:width)
        
        // coustom
        border.frame = CGRect(x: margin, y: self.frame.size.height - width, width: self.frame.size.width - margin, height: width)
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
