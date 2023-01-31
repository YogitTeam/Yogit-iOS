//
//  ClipBoardRouter.swift
//  Yogit
//
//  Created by Junseo Park on 2023/01/02.
//

import Foundation
import Alamofire

enum ProfileRouter: URLRequestConvertible {
    case readProfile(parameters: GetUserProfile)
    case uploadEssentialProfile(parameters: UserProfile)
    case uploadImages(parameters: PatchUserImages)
    case downLoadImages(parameters: GetUserImages)

    var baseURL: URL {
        return URL(string: API.BASE_URL + "users/")! // 밑에 Auth 수정해야댐
    }

    var method: HTTPMethod {
        switch self {
        case .uploadEssentialProfile, .uploadImages:
            return .patch
        case .downLoadImages, .readProfile:
            return .post
        }
    }

    var endPoint: String {
        switch self {
        case .readProfile, .uploadEssentialProfile:
            return "profile"
        case .uploadImages:
            return "image"
        case let .downLoadImages(parameters):
            return "image/\(parameters.userId)"
        }
    }
        
    var toDictionary: [String: Any]? {
        switch self {
        case let .uploadEssentialProfile(parameters):
            return mirroringDictionary(parameter: parameters)
        case let .uploadImages(parameters):
            return mirroringDictionary(parameter: parameters)
        case let .downLoadImages(parameters):
            return mirroringDictionary(parameter: parameters)
        default: return nil
        }
    }
    
//    func asURL() throws -> URL {
//        let url = baseURL.appendingPathComponent(endPoint)
//        print("UpdateProfileRouter - asURL() url : \(url)")
//        return url
//    }
    
    func asURLRequest() throws -> URLRequest {
        
        let url = baseURL.appendingPathComponent(endPoint)
    
        print("ProfileRouter - asURLRequest() url : \(url)")
        
        var request = URLRequest(url: url)
        
        request.method = method
        
        switch self {
        case let .readProfile(parameters):
            request = try URLEncodedFormParameterEncoder(destination: .httpBody).encode(parameters, into: request)
        default: break
        }

        return request
    }
}

