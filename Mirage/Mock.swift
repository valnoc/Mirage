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


extension Mock {
    
    func verify(_ functionName:String, _ callTimesVerificator:CallTimesVerificator) throws {
        try mockManager.verify(functionName, callTimesVerificator)
    }
    
    func argsOf(_ functionName:String) throws {
        try argsOfLastCall(functionName)
    }
    func argsOfFirstCall(_ functionName:String) throws {
        try argsOf(functionName, callTime: 1)
    }
    func argsOfLastCall(_ functionName:String) throws {
        try argsOf(functionName, callTime: mockManager.callTimes(functionName))
    }
    func argsOf(_ functionName:String, callTime:Int) throws {
        try mockManager.argsOf(functionName, callTime: callTime)
    }
}
