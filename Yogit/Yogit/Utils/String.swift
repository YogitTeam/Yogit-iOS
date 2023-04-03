//
//  String.swift
//  Yogit
//
//  Created by Junseo Park on 2022/11/29.
//

import Foundation
import UIKit

extension String {
    func stringToImage(width: CGFloat, height: CGFloat) -> UIImage? {
        let size = CGSize(width: width, height: height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        UIColor.white.set()
        let rect = CGRect(origin: .zero, size: size)
        UIRectFill(CGRect(origin: .zero, size: size))
        (self as AnyObject).draw(in: rect, withAttributes: [.font: UIFont.systemFont(ofSize: height*0.9)])
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    func localized(comment: String = "") -> String {
        return NSLocalizedString(self, comment: comment)
    }
    
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
    
    func loadImage(completion: @escaping (UIImage?) -> ()) {
        guard let url = URL(string: self) else {
            print("Invalid URL")
            completion(nil)
            return
        }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
                completion(nil)
                return
            }

            if let data = data, let image = UIImage(data: data) {
                completion(image)
            }
        }.resume()
    }
    
//    // 클로저 사용
//    let urlString = "https://example.com/image.jpg"
//    urlString.loadImage { (image) in
//        guard let image = image else {
//            print("Error loading image")
//            return
//        }
//        // Use the image here
//    }
    
    func loadImageAsync() -> UIImage? {
       guard let url = URL(string: self) else {
           print("Invalid URL")
           return nil
       }
       let semaphore = DispatchSemaphore(value: 0)
       var image: UIImage?
       URLSession.shared.dataTask(with: url) { (data, response, error) in
           if let error = error {
               print(error.localizedDescription)
               return
           }

           if let data = data {
               image = UIImage(data: data)
           }
           semaphore.signal()
       }.resume()
       semaphore.wait()
       return image
   }
// await, async 코드 사용
//    let urlString = "https://example.com/image.jpg"
//    if let image = urlString.loadImage() {
//        // Use the image here
//    } else {
//        print("Error loading image")
//    }
//




    
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
    
    
    // string을 데이트로는 utc로 저장
    func stringToDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd HH:mm:ss" // "YYYY-MM-dd HH:mm:ss" // yyyy-MM-dd HH:mm:ss
        // yyyy-MM-dd'T'HH:mm:ssZ
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
//        dateFormatter.timeZone = TimeZone(identifier: "GMT")
        return dateFormatter.date(from: self)
    }
}
