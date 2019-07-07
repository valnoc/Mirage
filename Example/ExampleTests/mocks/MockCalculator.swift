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
    override func sum(_ left: Int, _ right: Int) -> Int {
        let args = SumArgs(left: left, right: right)
        return mock_sum.handle(args)
    }
}

extension MockCalculator{
    //MARK: - sum
    class SumArgs {
        let left: Int
        let right: Int
        
        init(left: Int, right: Int) {
            self.left = left
            self.right = right
        }
    }
    fileprivate func super_sum(_ args: SumArgs) -> Int {
        return super.sum(args.left, args.right)
    }
}
