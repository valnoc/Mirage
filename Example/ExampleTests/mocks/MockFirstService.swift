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

    enum Func: String {
        case performCalculation
    }
    
    lazy var callHandler = CallHandler<Func>()

    // MARK: - mocked calls
    class PerformCalculationArgs {
        let arg1: Int
        let arg2: Int
        
        init(arg1: Int, arg2: Int) {
            self.arg1 = arg1
            self.arg2 = arg2
        }
    }
    override func performCalculation(arg1: Int, arg2: Int) -> Int {
        return callHandler.handle(.performCalculation,
                                  withArgs: PerformCalculationArgs(arg1: arg1, arg2: arg2),
                                  defaultReturnValue: 0)
    }
}
