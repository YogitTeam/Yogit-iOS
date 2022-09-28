//
//  TokenSource.swift
//  Yogit
//
//  Created by Junseo Park on 2022/09/22.
//

import Foundation

enum TokenSource: String {
    case apple = "apple", facebook = "facebook"
    
    func toString() -> String {
        return self.rawValue
    }
}
