//
//  User.swift
//  Yogit
//
//  Created by Junseo Park on 2022/09/11.
//

import Foundation

// click sign up >> post
struct UserProfile {
    var gender: String?
    var languageNames: [String]?
    var languageLevels: [String]?
    var nationality: String?
    var userAge: Int?
    var userId: Int?
    var userName: String? 
    
    init(gender: String? = nil, nationality: String? = nil, userAge: Int? = nil, userId: Int? = nil, userName: String? = nil) {
        self.gender = gender
        self.nationality = nationality
        self.userAge = userAge
        self.userId = userId
        self.userName = userName
    }

//    // key 대칭
//    enum Codingkeys: String, CodingKey {
//        case gender
//        case languageNames
//        case languageLevels
//        case nationality
//        case userAge
//        case userId
//        case userName
//    }
//
//    // JSON파일 Swift 오브젝트로 변환 (decode) 할때 실패할수 있는 함수 있므로 throws init 필요 (중간에 개입 할수 잇게 함)
//    // 변환시 KeyedDecodingContainer 중간단계 결과물
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: Codingkeys.self)
//        self.gender = try container.decode(String.self, forKey: Codingkeys.gender)
//        self.languageNames = try container.decode([String].self, forKey: Codingkeys.languageNames)
//        self.languageLevels = try container.decode([String].self, forKey: Codingkeys.languageLevels)
//        self.nationality = try container.decode(String.self, forKey: Codingkeys.nationality)
//        self.userAge = try container.decode(Int.self, forKey: Codingkeys.userAge)
//        self.userId = try container.decode(Int64.self, forKey: Codingkeys.userId)
//        self.userName = try container.decode(String.self, forKey: Codingkeys.userName)
//    }
}
