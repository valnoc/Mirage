//
//  MockFirstService.swift
//  Example
//
//  Created by Valeriy Bezuglyy on 02/09/2017.
//  Copyright © 2017 Valeriy Bezuglyy. All rights reserved.
//

import Foundation
import Mirage

@testable import Example

class MockFirstService: FirstService, Mock {

    lazy var mockManager: MockManager = MockManager(self, callRealFuncClosure: { [weak self] (funcName, args) -> Any? in
        guard let __self = self else { return nil }
        return __self.callRealFunc(funcName, args)
    })
    fileprivate func callRealFunc(_ funcName: String, _ args:[Any?]?) -> Any? {
        switch funcName {
        case sel_performCalculation:
            return super.performCalculation(arg1: args![0] as! Int, arg2: args![1] as! Int)
        default:
            return nil
        }
    }

    // MARK: - mocked calls
    let sel_performCalculation = "performCalculation(arg1:arg2:)"
    override func performCalculation(arg1: Int, arg2: Int) -> Int {
        return mockManager.handle(sel_performCalculation, withDefaultReturnValue: 0, withArgs: arg1, arg2) as! Int
    }
}
