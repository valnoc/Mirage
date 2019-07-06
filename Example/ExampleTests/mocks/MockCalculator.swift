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
    fileprivate func super_sum(_ args: Mock.SumArgs) -> Int {
        return super.sum(args.arg1, args.arg2)
    }
    
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
                let newValue = Mock(orig: self)
                MockCalculator.mockHash[tmpAddress] = newValue
                return newValue
            }
            return value
        }
    }
    
    class Mock {
        let orig: MockCalculator
        init(orig: MockCalculator) {
            self.orig = orig
        }
        
        class SumArgs {
            let arg1: Int
            let arg2: Int
            
            init(arg1: Int, arg2: Int) {
                self.arg1 = arg1
                self.arg2 = arg2
            }
        }
        lazy var sum = FuncCallHandler<SumArgs, Int>(returnValue: anyInt(),
                                                     callRealFuncClosure: { [weak self] (args) -> Int in
                                                        guard let __self = self else { return anyInt() }
                                                        return __self.orig.super_sum(args)
        })
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
