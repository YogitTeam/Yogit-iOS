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

enum Kind: Int {
    case profile = 0
    case boardSelectDetail
    case boardTextDetail
}

enum ProfileSectionData: Int {
    case name = 0
    case age
    case languages
    case gender
    case nationality
}

enum BoardSelectDetailSectionData: Int {
    case numberOfMember = 0
    case dateTime
    case location
}
