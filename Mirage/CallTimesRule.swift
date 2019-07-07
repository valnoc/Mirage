//
//  CallTimesRule.swift
//  Mirage
//
//  Created by Valeriy Bezuglyy on 15/06/2019.
//

import Foundation

public enum CallTimesRule {
    case never, once, times(Int), atLeast(Int), atMost(Int)
    
    func verify(_ callTimes: Int) throws {
        var isOK = false
        
        switch self {
        case .never:
            isOK = callTimes == 0
            
        case .once:
            isOK = callTimes == 1
            
        case .times(let times):
            isOK = callTimes == times
            
        case .atLeast(let times):
            isOK = callTimes >= times
            
        case .atMost(let times):
            isOK = callTimes <= times
        }
        
        if !isOK { throw CallTimesRuleIsBroken() }
    }
}

public struct CallTimesRuleIsBroken: Error { }
