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

    var baseURL: URL {
        return URL(string: API.BASE_URL + "boards/")! // 밑에 Auth 수정해야댐
    }

    var method: HTTPMethod {
        switch self {
        case .createBoard, .readBoardDetail, .readAllBoards, .readCategoryBoards:
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
        case .deleteBoard:
            return "status"
        }
    }

    var toDictionary: [String: Any]? {
        switch self {
        case let .createBoard(parameters):
            return mirroringDictionary(parameter: parameters)
        case let .updateBoard(parameters):
            return mirroringDictionary(parameter: parameters)
        default: return nil
        }
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
        case let .deleteBoard(parameters):
            request = try JSONParameterEncoder().encode(parameters, into: request)
        default: break
        }
        return request
    }
}

