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
    
    var mockManager: MockManager = MockManager()
    
    let sel_makeRandomPositiveInt = "makeRandomPositiveInt()"
    func makeRandomPositiveInt() -> Int {
        return mockManager.handleCall(sel_makeRandomPositiveInt, withDefaultReturnValue: 4, withArgs: nil) as! Int
    }
    
    let sel_foo = "foo()"
    func foo() {
        mockManager.handleCall(sel_foo, withDefaultReturnValue: nil, withArgs: nil)
    }
}
