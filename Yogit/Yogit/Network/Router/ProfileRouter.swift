//
//  ClipBoardRouter.swift
//  Yogit
//
//  Created by Junseo Park on 2023/01/02.
//

import Foundation
import Alamofire

enum ProfileRouter: URLConvertible {
//    case createEssentialProfile(parameter: UserProfile)
    case readServiceProfile(parameter: GetUserProfile)
    case uploadEssentialProfile(parameter: UserProfile)
    case uploadImages(parameter: PatchUserImages)
    case downLoadImages(parameter: GetUserImages)

    var baseURL: URL {
        return URL(string: API.BASE_URL + "users/")! // 밑에 Auth 수정해야댐
    }

    var method: HTTPMethod {
        switch self {
        case .readServiceProfile:
            return .post
        case .uploadEssentialProfile, .uploadImages:
            return .patch
        case .downLoadImages:
            return .post
        }
    }

    var endPoint: String {
        switch self {
        case .readServiceProfile:
            return "profile"
        case .uploadEssentialProfile:
            return "essential-profile"
        case .uploadImages:
            return "image"
        case let .downLoadImages(parameter):
            return "image/\(parameter.userId)"
        }
    }
        
    var toDictionary: [String: Any]? {
        switch self {
//        case let .uploadProfileImages(parameter):
//            return mirroringDictionary(parameter: parameter)
        case let .uploadEssentialProfile(parameter):
            return mirroringDictionary(parameter: parameter)
        case let .uploadImages(parameter):
            return mirroringDictionary(parameter: parameter)
        case let .downLoadImages(parameter):
            return mirroringDictionary(parameter: parameter)
        default: return nil
        }
    }
    
    func asURL() throws -> URL {
        let url = baseURL.appendingPathComponent(endPoint)
        print("ProfileRouter - asURL() url : \(url)")
        return url
    }
}

