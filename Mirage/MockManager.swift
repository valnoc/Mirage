//
//  MockManager.swift
//  MirageExample
//
//  Created by Valeriy Bezuglyy on 02/09/2017.
//  Copyright © 2017 Valeriy Bezuglyy. All rights reserved.
//

import Foundation

class MockManager {
    
    var callHistory: [String: [[Any?]]]
    
    init() {
        callHistory = [:]
    }
    
    @discardableResult
    func handle(_ functionName:String, withDefaultReturnValue defaultReturnValue:Any?, withArgs args:Any?...) -> Any? {
        if callHistory[functionName] == nil { callHistory[functionName] = [] }
        callHistory[functionName]?.append(args)
        return defaultReturnValue
    }
    
    func verify(_ functionName:String, _ callTimesVerificator:CallTimesVerificator) throws {
        try callTimesVerificator.verify(functionName, callHistoryTimes: callTimes(functionName))
    }
    
    func callTimes(_ functionName:String) -> Int {
        let history = callHistory[functionName] ?? []
        let times = history.count
        return times
    }
    
    func argsOf(_ functionName:String, callTime:Int) throws {
        
    }
}
