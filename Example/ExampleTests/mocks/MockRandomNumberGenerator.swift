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

class MockRandomNumberGenerator: RandomNumberGenerator {
    //MARK: - sum
    class MakeIntArgs {
        init() {
        }
    }
    lazy var mock_makeInt = FuncCallHandler<MakeIntArgs, Int>(returnValue: anyInt(),
                                                      callRealFuncClosure: { [weak self] (args) -> Int in
                                                        guard let __self = self else { return anyInt() }
                                                        return __self.makeInt()
    })
    func makeInt() -> Int {
        return mock_makeInt.handle(MockRandomNumberGenerator.MakeIntArgs())
    }
}
