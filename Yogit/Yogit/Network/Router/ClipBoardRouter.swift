//
//  ClipBoardRouter.swift
//  Yogit
//
//  Created by Junseo Park on 2023/01/02.
//

import Foundation
import Alamofire

//public typealias ClipBoard = CreateClipBoardReq & GetAllClipBoardsReq

enum ClipBoardRouter: URLRequestConvertible {
//    typealias ClipBoard = CreateClipBoardReq & CreateClipBoardReq
    
    case createBoard(parameter: CreateClipBoardReq)
    case readBoard(parameter: GetAllClipBoardsReq) // another
    
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
        case let .readBoard(parameter):
            return "all/board/\(parameter.boardId)/user/\(parameter.userId)"
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        
        let url = baseURL.appendingPathComponent(endPoint)
    
        print("ClipBoardRouter - asURLRequest() url : \(url)")
        
        var request = URLRequest(url: url)
        
        request.method = method
        
        switch self {
        case let .createBoard(parameter):
            request = try JSONParameterEncoder().encode(parameter, into: request)
        case let .readBoard(parameter):
            request = try JSONParameterEncoder().encode(parameter, into: request)
        } 
        return request
    }
}
