//
//  URL.swift
//  Yogit
//
//  Created by Junseo Park on 2022/09/29.
//

import Foundation

enum API {
    static let BASE_URL: String = "https://yogit.world/"
    
//    func toString() -> String {
//        return self.rawValue
//    }
}

enum Service {
    static let APPLE_SIGNIN: String = "apple"
    static let FACEBOOK_SIGNIN: String = "facebook"
}

enum ProfileSectionData: Int {
//    case image = 0
    case name = 0
    case age
    case languages
    case gender
    case nationality
}
