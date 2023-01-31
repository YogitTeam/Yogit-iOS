//
//  URL.swift
//  Yogit
//
//  Created by Junseo Park on 2022/09/29.
//

import Foundation

enum RootViewState {
    case loginView, homeView, setProfileView
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
    
    func toString() -> String {
        switch self {
        case .name: return "Name"
        case .age: return "Age"
        case .languages: return "Languages"
        case .nationality: return "Nationality"
        case .gender: return "Gender"
        case .job: return "Job"
        case .aboutMe: return "AboutMe"
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
        }
    }
}

enum LanguageLevel: Int {
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

enum CategoryId: Int {
    case dailySpot = 1
    case traditionalCulture
    case nature
    case languageExchange
    
    func toString() -> String {
        switch self.rawValue {
        case 1: return "Daily Spot"
        case 2: return "Traditional Culture"
        case 3: return "Nature"
        case 4: return "Language exchange"
        default: fatalError("Not exist categoryId")
        }
    }
}

enum NOTIFICATION {
    enum API {
        
    }
}

enum TabBarKind: String {
    case home = "Home"
    case myClub = "MyClub"
    case profile = "Profile"
    case notification = "Notification"
}
