//
//  TimeMeasure.swift
//  Yogit
//
//  Created by Junseo Park on 2022/11/21.
//

import Foundation

public func progressTime(_ closure: () -> ()) -> TimeInterval {
    let startTime = Date()
//    let start = CFAbsoluteTimeGetCurrent()
    closure()
//    let diff = CFAbsoluteTimeGetCurrent() - start
    let endTime = Date()
    let timeInterval = endTime.timeIntervalSince(startTime)
//    return (diff)
    return timeInterval
}

//progressTime {
//    // put your func
//}
