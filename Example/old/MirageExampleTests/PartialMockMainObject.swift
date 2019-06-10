//
//  PartialMockMainObject.swift
//  MirageExample
//
//  Created by Valeriy Bezuglyy on 13/09/2017.
//  Copyright © 2017 Valeriy Bezuglyy. All rights reserved.
//

import Foundation

@testable import MirageExample

class PartialMockMainObject: MainObject, PartialMock {

    lazy var mockManager: MockManager = MockManager(self, callRealFuncClosure: { [weak self] (funcName, args) -> Any? in
        guard let __self = self else { return nil }
        return __self.callRealFunc(funcName, args)
    })
    fileprivate func callRealFunc(_ funcName: String, _ args:[Any?]?) -> Any? {
        switch funcName {
        case sel_makeFirstArg:
            return super.makeFirstArg()
        case sel_makeSecondArg:
            return super.makeSecondArg()
        default:
            return nil
        }
    }

    // MARK: - mocked calls
    let sel_makeFirstArg = "makeFirstArg"
    override func makeFirstArg() -> Int {
        return mockManager.handle(sel_makeFirstArg, withDefaultReturnValue: 0, withArgs: nil) as! Int
    }

    let sel_makeSecondArg = "makeSecondArg"
    override func makeSecondArg() -> Int {
        return mockManager.handle(sel_makeSecondArg, withDefaultReturnValue: 0, withArgs: nil) as! Int
    }
}
