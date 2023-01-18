//
//  ImageManger.swift
//  Yogit
//
//  Created by Junseo Park on 2023/01/19.
//

import Foundation
import Kingfisher


private func downloadImage(with urlString: String) {
      guard let url = URL(string: urlString) else { return }
      let resource = ImageResource(downloadURL: url)
      KingfisherManager.shared.retrieveImage(with: resource,
                                             options: nil,
                                             progressBlock: nil) { result in
        switch result {
        case .success(let value):
          print(value.image)
        case .failure(let error):
          print("Error: \(error)")
        }
      }
}


extension UIImageView {
  func setImage(with urlString: String) {
    ImageCache.default.retrieveImage(forKey: urlString, options: nil) { result in
      switch result {
      case .success(let value):
        if let image = value.image {
          //캐시가 존재하는 경우
          self.image = image
        } else {
          //캐시가 존재하지 않는 경우
          guard let url = URL(string: urlString) else { return }
          let resource = ImageResource(downloadURL: url, cacheKey: urlString)
          self.kf.setImage(with: resource)
        }
      case .failure(let error):
        print(error)
      }
    }
  }
    
    
}

//let url = URL(string: "https://example.com/image.jpg")
//let task = URLSession.shared.dataTask(with: url!) { data, response, error in
//    guard let data = data, error == nil else { return }
//    DispatchQueue.main.async() {
//        let image = UIImage(data: data)
//    }
//}
//task.resume()
//
//let imageView = UIImageView()
//let url = URL(string: "https://example.com/image.jpg")
//imageView.sd_setImage(with: url, completed: nil)
//
//let url = URL(string: "https://example.com/image.jpg")
//let data = try Data(contentsOf: url!)
//let image = UIImage(data: data)
