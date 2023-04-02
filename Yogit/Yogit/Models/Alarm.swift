//
//  Alarm.swift
//  Yogit
//
//  Created by Junseo Park on 2022/12/13.
//

import Foundation

struct Alarm {
    let type: String
    let title: String
    let body: String
    let args: [String]
    let id: Int64
    
    init(type: String, title: String, body: String, args: [String], id: Int64) {
        self.type = type
        self.title = title
        self.body = body
        self.args = args
        self.id = id
    }
}
