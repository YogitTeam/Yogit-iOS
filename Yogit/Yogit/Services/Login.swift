//
//  Login.swift
//  Yogit
//
//  Created by Junseo Park on 2022/09/11.
//

import Foundation

enum LoginResult {
    case success
    case failure
}

enum LoginState {
    case sucess
    case failure
}

// when I save login state
// notification center / userdefault
// notification >> subcription >> value changed
// userDefualt >>
//func saveLoginState(loginState:LoginState) -> Bool {
//    let userDefault = UserDefaults()
//    userDefault.set(loginState, forKey: "LoginState")
//}
//
//func getLoginState() -> Bool {
//
//}

// func: Load login state from UserDefault
// func: Save login state into UserDefault




