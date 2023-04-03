//
//  URL.swift
//  Yogit
//
//  Created by Junseo Park on 2022/09/29.
//

import Foundation
import UIKit

enum FetchError: Error {
    case badResponse // unknowed: throw OS status
    case failureResponse
}

enum CreateError: Error {
    case badResponse // unknowed: throw OS status
    case failureResponse
}


enum RootViewState {
    case loginView, homeView //setProfileView
}

enum ServiceColor {
    static let primaryColor: UIColor = UIColor(rgb: 0x3232FF, alpha: 1.0)
}

enum GatheringKind: Int {
    case small = 0
    case club
    
    func memberNumber() -> Int {
        switch self {
        case .small: return 6
        case .club: return 50
        }
    }
}

//enum APIMethod {
//    case edit
//    case search
//    case upload
//    case delete
//}

enum Preferences {
    static let LOCATION: String = "LocationAuthorization" // 위치 권한 유무
    static let LiBRARY: String = "LibraryAuthorization" // 사진첩 권한 유무
    static let PUSH_NOTIFICATION: String = "PushNotificationAuthorization" // 알람 권한 유무 (디바이스 토큰)
}

enum PushNotificationKind {
    static let ApplyAlarmIdentifier = "ApplyAlarm"
    static let ClipBoardAlarmIdentifier = "ClipBoardAlarm"
}

// 권한 받은 유저
enum UserAuthorizationLocation: String {
    static let LOCATION: String = "UserAuthorizationLocation"
//    var locality: String? {
//        let localityName = UserDefaults.standard.object(forKey: UserAuthorizationLocation.LOCATION) as? String
//        return localityName
//    }
    case KR = "KR"



    func locality() -> String {
        switch self {
        case .KR: return "SEOUL"
        }
    }
}


//enum LocalizedLanguage {
//    static let LANGUAGE: String = "Language"
//}

enum API {
    static let BASE_URL: String = "https://yogit.world/"
    
//    func toString() -> String {
//        return self.rawValue
//    }
}

//enum Service {
//    static let APPLE_SIGNIN: String = "APPLE"
//    static let FACEBOOK_SIGNIN: String = "FACEBOOK"
//}

enum Kind: Int {
    case profile = 0
    case boardSelectDetail
    case boardTextDetail
}

enum ProfileSectionData: Int {
    case name = 0
    case age
    case languages
    case nationality
    case gender
    case job
    case aboutMe
    case interests
    
    func toString() -> String {
        let str: String
        switch self {
        case .name: str = "PROFILE_NAME"
        case .age: str = "PROFILE_AGE"
        case .languages: str = "PROFILE_LANGUAGE"
        case .nationality: str = "PROFILE_NATIONALIY"
        case .gender: str = "PROFILE_GENDER"
        case .job: str = "PROFILE_JOB"
        case .aboutMe: str = "PROFILE_ABOUTME"
        case .interests: str = "PROFILE_PESONALITY_INTERESTS"
        }
        return str.localized()
    }
  
    func placeHolder() -> String {
        let str: String
        switch self {
        case .name: str = "PROFILE_NAME_PLACEHOLDER"
        case .age: str = "PROFILE_AGE_PLACEHOLDER"
        case .languages: str = "PROFILE_LANGUAGE_PLACEHOLDER"
        case .nationality: str = "PROFILE_NATIONALIY_PLACEHOLDER"
        case .gender: str = "PROFILE_GENDER_PLACEHOLDER"
        case .job: str = "PROFILE_JOB_PLACEHOLDER"
        case .aboutMe: str = "PROFILE_ABOUTME_PLACEHOLDER"
        case .interests: str = "PROFILE_PESONALITY_INTERESTS_PLACEHOLDER"
        }
        return str.localized()
    }
}

enum LanguageLevels: Int {
    case elementary = 0
    case intermediate
    case advanced
    case bilingual
    case native

    func toString() -> String {
        let str: String
        switch self.rawValue {
        case 0: str = "PROFILE_LEVEL_0"
        case 1: str = "PROFILE_LEVEL_1"
        case 2: str = "PROFILE_LEVEL_2"
        case 3: str = "PROFILE_LEVEL_3"
        case 4: str = "PROFILE_LEVEL_4"
        default: fatalError("Not exist language level")
        }
        return str.localized()
    }
}

enum BoardSelectDetailSectionData: Int {
    case numberOfMember = 0
    case dateTime
    case location
    case locationDetail
}

enum BoardTextDetailData: Int {
    case title = 0
    case introduction
    case kindOfPerson
}

enum CategoryId: Int, CaseIterable {
//    case total = 0
    case socialParty = 1
    case languageCulture
    case natureOutdoor
    case exerciseSports
    case art
    case dance
    
    func toString() -> String {
        switch self.rawValue {
//        case 0: return "All"
        case 1: return "Party"
        case 2: return "Language"
        case 3: return "Outdoor"
        case 4: return "Exercise"
        case 5: return "Art"
        case 6: return "Dance"
        default: fatalError("Not exist categoryId")
        }
    }
}


enum TabBarKind: String {
    case home = "Home"
    case myClub = "My gathering"
    case profile = "My profile"
    case notification = "Notification"
}


enum Status: String {
    case active = "ACTIVE"
    case inactive = "INACTIVE"
}
