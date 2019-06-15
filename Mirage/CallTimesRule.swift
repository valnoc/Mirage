//
//  CallTimesRule.swift
//  Mirage
//
//  Created by Valeriy Bezuglyy on 15/06/2019.
//

import Foundation

public enum CallTimesRule {
    case never, once, times(Int), atLeast(Int), atMost(Int)
    
    func isValid(_ callTimes: Int) -> Bool {
        switch self {
        case .never:
            return callTimes == 0
            
        case .once:
            return callTimes == 1
            
        case .times(let times):
            return callTimes == times
            
        case .atLeast(let times):
            return callTimes >= times
            
        case .atMost(let times):
            return callTimes <= times
        }
    }
}
