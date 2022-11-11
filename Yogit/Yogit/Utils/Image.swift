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
}
