//
//  MockSecondService.swift
//  MirageExample
//
//  Created by Valeriy Bezuglyy on 02/09/2017.
//  Copyright © 2017 Valeriy Bezuglyy. All rights reserved.
//

import Foundation

@testable import MirageExample

class MockSecondService: SecondService, Mock {
    
    lazy var mockManager: MockManager = MockManager { [weak self] (funcName, args) -> Any? in
        guard let __self = self else { return nil }
        switch funcName {
        case __self.sel_makeRandomPositiveInt:
            return __self.makeRandomPositiveInt()
        case __self.sel_foo:
            return __self.foo()
        default:
            return nil
        }
    }
    
    let sel_makeRandomPositiveInt = "makeRandomPositiveInt()"
    func makeRandomPositiveInt() -> Int {
        return mockManager.handle(sel_makeRandomPositiveInt, withDefaultReturnValue: 4, withArgs: nil) as! Int
    }
    
    let sel_foo = "foo()"
    func foo() {
        mockManager.handle(sel_foo, withDefaultReturnValue: nil, withArgs: nil)
    }
}
