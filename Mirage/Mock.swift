//
//  Mock.swift
//  MirageExample
//
//  Created by Valeriy Bezuglyy on 02/09/2017.
//  Copyright © 2017 Valeriy Bezuglyy. All rights reserved.
//

import Foundation

protocol Mock {
    var mockManager: MockManager {get set}
}

//MARK: verify
extension Mock {
    func verify(_ functionName:String, _ callTimesVerificator:CallTimesVerificator) throws {
        try mockManager.verify(functionName, callTimesVerificator)
    }
}

//MARK: args
extension Mock {
    func argsOf(_ functionName:String) -> [Any?]? {
        return argsOfFirstCall(functionName)
    }
    func argsOfFirstCall(_ functionName:String) -> [Any?]? {
        return argsOf(functionName, callTime: 0)
    }
    func argsOfLastCall(_ functionName:String) -> [Any?]? {
        return argsOf(functionName, callTime: mockManager.totalCallTimes(functionName) - 1)
    }
    func argsOf(_ functionName:String, callTime:Int) -> [Any?]? {
        return mockManager.argsOf(functionName, callTime: callTime)
    }
}

//MARK: stub 
extension Mock {
    func when(_ functionName:String) -> Stub {
        return mockManager.when(functionName)
    }
}
