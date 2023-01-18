//
//  String.swift
//  Yogit
//
//  Created by Junseo Park on 2022/11/29.
//

import Foundation
import UIKit

extension String {
    func urlToImage2() -> UIImage? {
        guard let url = URL(string: self) else { return nil }
        guard let data = try? Data(contentsOf: url) else { return nil }
        guard let image = UIImage(data: data) else { return nil }
        return image
    }
    
    
    func urlToImage(completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: self) else { return completion(nil) }
        guard let data = try? Data(contentsOf: url) else { return completion(nil) }
        guard let image = UIImage(data: data) else { return completion(nil) }
        completion(image)
    }
    
    
    func urlToImage() async -> UIImage? {
        guard let url = URL(string: self) else { return nil }
        guard let data = try? Data(contentsOf: url) else { return nil }
        guard let image = UIImage(data: data) else { return nil }
        return image
    }
    
//    func urlToImage() -> UIImage {
//        var returnImage: UIImage?
//        DispatchQueue.global().async {
//            if let url = URL(string: self) {
//                if let data = try? Data(contentsOf: url) {
//                    if let image = UIImage(data: data) {
//                        return Image = image
//                    }
//                }
//            }
//        }
//        return image
//    }
    
//    func toImage(completion: @escaping (UIImage) -> Void) {
////        let image: UIImage?
//        DispatchQueue.global().async {
//            if let url = URL(string: self) {
//                if let data = try? Data(contentsOf: url) {
//                    if let image = UIImage(data: data) {
//
//                    }
//                }
//            }
//        }
//        
////        DispatchQueue.global().async {
////            guard let url = URL(string: self) else { return }
////            guard let data = try? Data(contentsOf: url) else { return }
////            guard let image = UIImage(data: data) else { return }
////        }
//        guard let url = URL(string: self) else { return nil }
//        guard let data = try? Data(contentsOf: url) else { return nil }
//        guard let image = UIImage(data: data) else { return nil }
//        return image
//    }
    
    func stringToDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd HH:mm:ss" // "YYYY-MM-dd HH:mm:ss" // yyyy-MM-dd HH:mm:ss
        // yyyy-MM-dd'T'HH:mm:ssZ
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
//        dateFormatter.timeZone = TimeZone(identifier: "GMT")
        return dateFormatter.date(from: self)
    }
}
