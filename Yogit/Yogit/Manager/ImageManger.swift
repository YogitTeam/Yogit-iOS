//
//  ImageManger.swift
//  Yogit
//
//  Created by Junseo Park on 2023/01/19.
//

import Foundation
import Kingfisher
import Photos
import UIKit

final class ImageManager {
    static let shared = ImageManager()
    
    weak var vc: UIViewController?
    
    func downloadImage(with urlString: String, completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: urlString) else { return completion(nil) }
        let resource = ImageResource(downloadURL: url)
        KingfisherManager.shared.retrieveImage(with: resource, options: nil, progressBlock: nil) { result in
            switch result {
            case .success(let value):
                print("Success - Downloaded Image", value.image)
                completion(value.image)
            case .failure(let error):
                print("Error - Downloaded Image:", error)
                completion(nil)
            }
        }
    }
    
    func requestPHPhotoLibraryAuthorization(completion: @escaping(Bool) -> Void) {
        if #available(iOS 14, *) {
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { authorizationStatus in
                switch authorizationStatus {
//                case .limited:
////                    completion()
//                    print("limited authorization granted")
//                case .authorized:
////                    completion()
//                    print("authorization granted")
//                case .notDetermined:
//                    print("notDetermined")
//                case .restricted:
//                    print("restricted")
                case .denied, .restricted:
                    completion(false)
                default:
                    completion(true)
                    print("Unimplemented")
                }
            }
        }
    }
}
