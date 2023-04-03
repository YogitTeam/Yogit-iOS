//
//  UIImageView+Extension.swift
//  Yogit
//
//  Created by Junseo Park on 2023/01/19.
//

import Foundation
import Kingfisher

extension UIImageView {
    func setImage(with urlString: String) {
        ImageCache.default.retrieveImage(forKey: urlString, options: nil) { result in
            switch result {
                case .success(let value):
                    if let image = value.image { // 캐시가 존재하는 경우
                      self.image = image
                    } else { // 캐시가 존재하지 않는 경우
                        guard let url = URL(string: urlString) else { return }
                        let resource = ImageResource(downloadURL: url, cacheKey: urlString)
        //                  self.kf.setImage(with: resource)
//                        self.kf.indicatorType = .activity
                        self.kf.setImage(
                            with: resource,
                            placeholder: nil,
                            options: [.transition(.none)],
                            completionHandler: nil
                        )
                        // options .fade(1.2)
                    }
                case .failure(let error):
                    print(error)
            }
        }
    }
    
    func removeCache() {
      //모든 캐시 삭제
      ImageCache.default.clearMemoryCache()
      ImageCache.default.clearDiskCache { print("done clearDiskCache") }
      
      //만료된 캐시만 삭제
      ImageCache.default.cleanExpiredMemoryCache()
      ImageCache.default.cleanExpiredDiskCache { print("done cleanExpiredDiskCache") }
    }
}
