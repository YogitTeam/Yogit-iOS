//
//  ClipBoardRouter.swift
//  Yogit
//
//  Created by Junseo Park on 2023/01/02.
//

import Foundation
import Alamofire

enum ClipBoardRouter: URLRequestConvertible {
    case createBoard(parameters: CreateClipBoardReq)
    case readBoard(parameters: GetAllClipBoardsReq) // another
    
    var baseURL: URL {
        return URL(string: API.BASE_URL + "clipboards/")! // 밑에 Auth 수정해야댐
    }

    var method: HTTPMethod {
        switch self {
        case .createBoard:
            return .post 
        case .readBoard:
            return .post
        }
    }

    var endPoint: String {
        switch self {
        case .createBoard:
            return ""
        case let .readBoard(parameters):
            return "all/board/\(parameters.boardId)/user/\(parameters.userId)"
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        
        let url = baseURL.appendingPathComponent(endPoint)
    
        print("ClipBoardRouter - asURLRequest() url : \(url)")
        
        var request = URLRequest(url: url)
        
        request.method = method
        
        switch self {
        case let .createBoard(parameters):
            request = try JSONParameterEncoder().encode(parameters, into: request)
        case let .readBoard(parameters):
            request = try JSONParameterEncoder().encode(parameters, into: request)
        } 
        return request
    }
}
