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
import AVFoundation

final class ImageManager {
    static let shared = ImageManager()
    
    static func downloadImage(with urlString: String, completion: @escaping (UIImage?) -> Void) {
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
    
    // let profileImage = try? await ImageManager.shared.downloadImageConcurrency(with: clipBoardList[i].profileImgURL)
    // withUnsafeThrowingContinuation 현재 실행 컨텍스트를 캡처하고 나중에 다시 시작하는 방법인 연속을 만드는 데 사용
//    func downloadImageConcurrency(with urlString: String) async -> UIImage? {
//        guard let url = URL(string: urlString) else { return nil }
//        let resource = ImageResource(downloadURL: url)
//        let image = try await withUnsafeThrowingContinuation { continuation in
//                KingfisherManager.shared.retrieveImage(with: resource, options: nil, progressBlock: nil) { result in
//                    switch result {
//                    case .success(let value):
//                        continuation.resume(returning: value.image)
//                    case .failure(let error):
//                        continuation.resume(throwing: error)
//                    }
//                }
//            }
//        return image
//    }
    
    static func downloadImageWait(with urlString: String) -> UIImage? {
        guard let url = URL(string: urlString) else { return nil }
        let semaphore = DispatchSemaphore(value: 0)
        let resource = ImageResource(downloadURL: url)
        var image: UIImage?
        KingfisherManager.shared.retrieveImage(with: resource, options: nil, progressBlock: nil) { result in
            switch result {
            case .success(let value):
                print("Success - Downloaded Image", value.image)
                image = value.image
            case .failure(let error):
                print("Error - Downloaded Image:", error)
                image = nil
            }
            semaphore.signal()
        }
        semaphore.wait()
        return image
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
    
    func checkCameraAuthorization(completion: @escaping(Bool) -> Void) {
        AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
          if granted {
              print("Camera: 권한 허용")
              completion(true)
          } else {
              print("Camera: 권한 거부")
              completion(false)
          }
       })
    }
}
