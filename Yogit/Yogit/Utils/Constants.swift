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
    case loginView, homeView, setProfileView
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
    static let LOCATION: String = "LocationAuthorization"
    static let LiBRARY: String = "LibraryAuthorization"
    static let PUSH_NOTIFICATION: String = "PushNotificationAuthorization"
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
        switch self {
        case .name: return "Name"
        case .age: return "Age"
        case .languages: return "Languages"
        case .nationality: return "Nationality"
        case .gender: return "Gender"
        case .job: return "Job"
        case .aboutMe: return "AboutMe"
        case .interests: return "Intersts"
        }
    }
  
    func placeHolder() -> String {
        switch self {
        case .name: return "Nick name"
        case .age: return "International age"
        case .languages: return "Add conversational language"
        case .nationality: return "Select nationaltiy"
        case .gender: return "Select gender"
        case .job: return "What do you do?"
        case .aboutMe: return "Who are you?"
        case .interests: return "What's your interests"
        }
    }
}

enum LanguageLevels: Int {
    case beginner = 0
    case intermediate
    case fluent
    case native
    
    func toString() -> String {
        switch self.rawValue {
        case 0: return "Beginner"
        case 1: return "Intermediate"
        case 2: return "Fluent"
        case 3: return "Natvie"
        default: fatalError("Not exist language level")
        }
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
    case myClub = "My Gathering"
    case profile = "Profile"
    case notification = "Notification"
}


enum Status: String {
    case active = "ACTIVE"
    case inactive = "INACTIVE"
}
