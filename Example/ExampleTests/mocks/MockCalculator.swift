//
//  MockCalculator.swift
//  ExampleTests
//
//  Created by Valeriy Bezuglyy on 02/07/2019.
//  Copyright © 2019 Valeriy Bezuglyy. All rights reserved.
//

import Foundation
@testable import Example
import Mirage

class MockCalculator: Calculator {
    //MARK: - sum
    class SumArgs {
        let arg1: Int
        let arg2: Int
        
        init(arg1: Int, arg2: Int) {
            self.arg1 = arg1
            self.arg2 = arg2
        }
    }
    lazy var mock_sum = FuncCallHandler<SumArgs, Int>(returnValue: anyInt(),
                                                      callRealFuncClosure: { [weak self] (args) -> Int in
                                                        guard let __self = self else { return anyInt() }
                                                        return __self.sum(args.arg1, args.arg2)
    })
    override func sum(_ arg1: Int, _ arg2: Int) -> Int {
        return mock_sum.handle(MockCalculator.SumArgs(arg1: arg1, arg2: arg2))
    }
}


func anyInt() -> Int {
    return 4
}
