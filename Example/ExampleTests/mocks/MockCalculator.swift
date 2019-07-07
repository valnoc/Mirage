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
    lazy var mock_sum = FuncCallHandler<SumArgs, Int>(returnValue: anyInt(),
                                                      callRealFunc: { [weak self] (args) -> Int in
                                                        guard let __self = self else { return anyInt() }
                                                        return __self.super_sum(args)
    })
    override func sum(_ arg1: Int, _ arg2: Int) -> Int {
        let args = SumArgs(arg1: arg1, arg2: arg2)
        return mock_sum.handle(args)
    }
}

extension MockCalculator{
    //MARK: - sum
    class SumArgs {
        let arg1: Int
        let arg2: Int
        
        init(arg1: Int, arg2: Int) {
            self.arg1 = arg1
            self.arg2 = arg2
        }
    }
    fileprivate func super_sum(_ args: SumArgs) -> Int {
        return super.sum(args.arg1, args.arg2)
    }
}
