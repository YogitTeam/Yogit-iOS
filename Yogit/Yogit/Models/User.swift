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
    var userId: Int64?
    var userName: String? 
    
    init(gender: String? = nil, nationality: String? = nil, userAge: Int? = nil, userId: Int64? = nil, userName: String? = nil) {
        self.gender = gender
        self.nationality = nationality
        self.userAge = userAge
        self.userId = userId
        self.userName = userName
    }
}
