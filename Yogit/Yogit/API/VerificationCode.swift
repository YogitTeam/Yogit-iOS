//
//  Token.swift
//  Yogit
//
//  Created by Junseo Park on 2022/09/11.
//

import Foundation

class GetVerificationCode: Decodable {
    let needJoin: Bool?
    let verificationCode: String?
}
