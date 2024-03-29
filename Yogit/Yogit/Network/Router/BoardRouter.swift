//
//  BoardRouter.swift
//  Yogit
//
//  Created by Junseo Park on 2023/01/23.
//

import Foundation
import Alamofire

enum BoardRouter: URLRequestConvertible {
    case createBoard(parameters: UpdateBoard)
    case readBoardDetail(parameters: GetBoardDetail)
    case updateBoard(parameters: UpdateBoard)
    case readAllBoards(parameters: GetAllBoardsReq)
    case deleteBoard(parameters: DeleteBoardReq)
    case readCategoryBoards(parameters: GetBoardsByCategoryReq)
    case readCategoryBoardsByCity(parameters: GetBoardsByCategoryCityReq)
    case readMyBoards(parameters: GetMyClub)

    var baseURL: URL {
        return URL(string: API.BASE_URL + "boards/")! 
    }

    var method: HTTPMethod {
        switch self {
        case .createBoard, .readBoardDetail, .readAllBoards, .readCategoryBoards, .readMyBoards, .readCategoryBoardsByCity:
            return .post
        case .updateBoard, .deleteBoard:
            return .patch
        }
    }
    
    var endPoint: String {
        switch self {
        case .createBoard, .updateBoard:
            return ""
        case .readBoardDetail:
            return "get/detail"
        case .readAllBoards:
            return "get/categories"
        case .readCategoryBoards:
            return "get/category"
        case .readCategoryBoardsByCity:
            return "get/category/city"
        case .readMyBoards:
            return "get/myclub"
        case .deleteBoard:
            return "status"
        }
    }
    
    var body: Parameters {
        switch self {
        case let .createBoard(parameters):
            return mirroringDictionary(parameter: parameters)
        case let .updateBoard(parameters):
            return mirroringDictionary(parameter: parameters)
        default: fatalError("BoardRouter Body - Not Suppport Data Type")
        }
    }
    
    var multipartFormData: MultipartFormData {
        return multipartAppendParameters(parameters: body)
    }
    
    func asURLRequest() throws -> URLRequest {
        
        let url = baseURL.appendingPathComponent(endPoint)
    
        print("BoardRouter - asURLRequest() url : \(url)")
        
        var request = URLRequest(url: url)
        
        request.method = method
        
        switch self {
        case let .readBoardDetail(parameters):
            request = try JSONParameterEncoder().encode(parameters, into: request)
        case let .readAllBoards(parameters):
            request = try JSONParameterEncoder().encode(parameters, into: request)
        case let .readCategoryBoards(parameters):
            request = try JSONParameterEncoder().encode(parameters, into: request)
        case let .readCategoryBoardsByCity(parameters):
            request = try JSONParameterEncoder().encode(parameters, into: request)
        case let .readMyBoards(parameters):
            request = try JSONParameterEncoder().encode(parameters, into: request)
        case let .deleteBoard(parameters):
            request = try JSONParameterEncoder().encode(parameters, into: request)
        default: break
        }
        return request
    }
}

