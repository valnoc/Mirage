//
//  MockCalculator.swift
//  ExampleTests
//
//  Created by Valeriy Bezuglyy on 02/07/2019.
//  Copyright © 2019 Valeriy Bezuglyy. All rights reserved.
//

import Foundation
@testable import Example
import Mirage2

class MockRandomNumberGenerator: RandomNumberGenerator {
    //MARK: - makeInt
    lazy var mock_makeInt = FuncCallHandler<Void, Int>(returnValue: anyInt())
    func makeInt() -> Int {
        return mock_makeInt.handle(())
    }
}
