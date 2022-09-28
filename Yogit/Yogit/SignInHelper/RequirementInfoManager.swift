//
//  SignInManager.swift
//  Yogit
//
//  Created by Junseo Park on 2022/09/20.
//

import Foundation

// Bool requirement data
// when delete accout, delete value user default
// when 
struct RequirementInfoManager {
    static let isFullRequirementInfoKey = "isFullRequirementInfo"
    
    static func checkIsFullRequirementInfo(completion: @escaping (AuthState.RequirementInfoState) -> ()) {
        let isFullData = UserDefaults.standard.bool(forKey: isFullRequirementInfoKey)
        
        switch isFullData {
            case true:
                completion(.full) // auth 있으면 >> home
            case false:
                completion(.notFull) // login View
        }
    }
    
//    enum RequirementState: Int {
//        case full = 1
//        case notFull = 0
//
//        func toInt() -> Int {
//            return self.rawValue
//        }
//    }
    
//    guard UserDefaults.standard.bool(forKey: isFullRequirementInfoKey) != nil else {
//        print("RequirementInfo")
//        completion(.notFull)
//        return
//    }
    
    
    
//    static func checkIsFullRequirementInfo(completion: @escaping (RequirementInfoState) -> ()) {
//        guard UserDefaults.standard.bool(forKey: isFullRequirementInfoKey) != nil else {
//            print("RequirementInfo")
//            completion(.notFull)
//            return
//        }
//
//
////        switch RequirementInfoState.self {
////        case .full:
////            break
////        case .notFull:
////            break
////        default:
////            <#code#>
////        }
//
//
//    }

}
