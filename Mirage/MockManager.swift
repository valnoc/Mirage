//
//  MockManager.swift
//  MirageExample
//
//  Created by Valeriy Bezuglyy on 02/09/2017.
//  Copyright © 2017 Valeriy Bezuglyy. All rights reserved.
//

import Foundation

typealias MockFunctionCallBlock = (_ functionName:String, _ args:[Any?]?) -> Any?

class MockManager {
    
    var callHistory: [String: [[Any?]]]
    
    var stubs: [Stub]
    let callRealFuncClosure: MockFunctionCallBlock
    
    let shouldCallRealFuncs:Bool
    
    init(_ mock: Mock, callRealFuncClosure:@escaping MockFunctionCallBlock) {
        self.callRealFuncClosure = callRealFuncClosure
        shouldCallRealFuncs = mock is PartialMock
        
        callHistory = [:]
        stubs = []
    }
    
    @discardableResult
    func handle(_ functionName:String, withDefaultReturnValue defaultReturnValue:Any?, withArgs args:Any?...) -> Any? {
        if callHistory[functionName] == nil { callHistory[functionName] = [] }
        callHistory[functionName]?.append(args)
        
        if let stub = stubForFunction(functionName) {
            return stub.executeNextAction(args)
        } else if shouldCallRealFuncs {
            return callRealFuncClosure(functionName, args)
        } else {
            return defaultReturnValue
        }
    }
    
    //MARK: verify
    func verify(_ functionName:String, _ callTimesVerificator:CallTimesVerificator) throws {
        try callTimesVerificator.verify(functionName, totalCallTimes: totalCallTimes(functionName))
    }
    
    //MARK: args
    func totalCallTimes(_ functionName:String) -> Int {
        let history = callHistory[functionName] ?? []
        let times = history.count
        return times
    }
    
    func argsOf(_ functionName:String, callTime:Int) -> [Any?]? {
        guard callTime > -1 else { return nil }
        guard callTime < totalCallTimes(functionName) else { return nil }
        return callHistory[functionName]![callTime]
    }
    
    //MARK: stub
    func when(_ functionName:String) -> Stub {
        if let oldStub = stubForFunction(functionName) {
            return oldStub
        }
        else {
            let stub = Stub(functionName: functionName, callRealFuncClosure: callRealFuncClosure)
            stubs.append(stub)
            return stub
        }
    }
    
    fileprivate func stubForFunction(_ functionName:String) -> Stub? {
        return stubs.filter({$0.functionName == functionName}).first
    }
    
    // MARK: partial mock

}

