//
//  Image.swift
//  Yogit
//
//  Created by Junseo Park on 2022/11/11.
//

import Foundation
import UIKit

enum ImageFormat {
    case png
    case jpeg(CGFloat)
}

extension UIImage {
    func toBase64(format: ImageFormat) -> String? {
        var imageData: Data?

        switch format {
        case .png:
            imageData = self.pngData()
        case .jpeg(let compression):
            imageData = self.jpegData(compressionQuality: compression)
        }
        return imageData?.base64EncodedString()
    }
    
    func toFile(format: ImageFormat) -> Data? {
        var imageData: Data?
        switch format {
        case .png:
            imageData = self.pngData()
        case .jpeg(let compression):
            imageData = self.jpegData(compressionQuality: compression)
        }
        return imageData
    }
    
    func resize(targetSize: CGSize) -> UIImage {
        let size = self.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0) // 0.0 test 해봐야함
        self.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    func coustomPinSize(width: CGFloat, height: CGFloat) -> UIImage? {
        let newImageRect = CGRect(x: 0, y: 0, width: width, height: height)
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: width, height: height), false, 0.0)
        
        self.draw(in: newImageRect)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()?.withRenderingMode(.alwaysOriginal)
        
        UIGraphicsEndImageContext()
        
        return newImage
    }
}
