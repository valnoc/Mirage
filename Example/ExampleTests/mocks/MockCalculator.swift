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
    override func sum(_ arg1: Int, _ arg2: Int) -> Int {
        let args = Mock.SumArgs(arg1: arg1, arg2: arg2)
        return mock.sum.handle(args)
    }
}

extension MockCalculator {
    private static var mockHash = [String:Mock]()

    var mock: Mock {
        get {
            let tmpAddress = String(format: "%p", unsafeBitCast(self, to: Int.self))
            guard let value = MockCalculator.mockHash[tmpAddress] else {
                let newValue = Mock()
                MockCalculator.mockHash[tmpAddress] = newValue
                return newValue
            }
            return value
        }
    }
    
    class Mock {
        class SumArgs {
            let arg1: Int
            let arg2: Int
            
            init(arg1: Int, arg2: Int) {
                self.arg1 = arg1
                self.arg2 = arg2
            }
        }
        lazy var sum = FuncCallHandler<SumArgs, Int>(returnValue: anyInt())
    }
}

//public protocol Mockable {
//    associatedtype Orig
//    var mock: Mock<Orig> { get set }
//}
//extension Mockable {
//    public var mock: Mock<Self> {
//        get {
//            return Mock(self)
//        }
//        // swiftlint:disable:next unused_setter_value
//        set {
//            // this enables using Reactive to "mutate" base object
//        }
//    }
//}
