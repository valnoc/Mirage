//
//  MockManager.swift
//  MirageExample
//
//  Created by Valeriy Bezuglyy on 02/09/2017.
//  Copyright © 2017 Valeriy Bezuglyy. All rights reserved.
//

import Foundation

class MockManager {
    
    var invocationHistory: [String: [[Any?]]]
    
    init() {
        invocationHistory = [:]
    }
    
    @discardableResult
    func handle(_ functionName:String, withDefaultReturnValue defaultReturnValue:Any?, withArgs args:Any?...) -> Any? {
        if invocationHistory[functionName] == nil { invocationHistory[functionName] = [] }
        invocationHistory[functionName]?.append(args)
        return defaultReturnValue
    }
    
    func verify(_ functionName:String, _ invocationTimesVerificator:InvocationTimesVerificator) throws {
        let history = invocationHistory[functionName] ?? []
        let times = history.count
        try invocationTimesVerificator.verify(functionName, invocationTimes: times)
    }
    
}
