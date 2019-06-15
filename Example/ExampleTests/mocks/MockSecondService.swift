//
//  MockSecondService.swift
//  Example
//
//  Created by Valeriy Bezuglyy on 02/09/2017.
//  Copyright © 2017 Valeriy Bezuglyy. All rights reserved.
//

import Foundation
import Mirage

@testable import Example

class MockSecondService: SecondService, Mock {

    lazy var mockManager: MockManager = MockManager(self, callRealFuncClosure: { [weak self] (_, _) -> Any? in
        guard let __self = self else { return nil }
        return nil
    })

    // MARK: - mocked calls
    let sel_makeRandomPositiveInt = "makeRandomPositiveInt()"
    func makeRandomPositiveInt() -> Int {
        return mockManager.handle(sel_makeRandomPositiveInt, withDefaultReturnValue: 4, withArgs: nil) as! Int
    }

    let sel_foo = "foo()"
    func foo() {
        mockManager.handle(sel_foo, withDefaultReturnValue: nil, withArgs: nil)
    }
}
