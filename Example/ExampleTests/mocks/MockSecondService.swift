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

    enum Func: String {
        case makeRandomPositiveInt, foo
    }
    
    lazy var callHandler = CallHandler<Func>()

    // MARK: - mocked calls
    class MakeRandomPositiveIntArgs {
        init() {
        }
    }
    func makeRandomPositiveInt() -> Int {
        return callHandler.handle(.makeRandomPositiveInt,
                                  withArgs: MakeRandomPositiveIntArgs(),
                                  defaultReturnValue: 4)
    }

    class FooArgs {
        init() {
        }
    }
    func foo() {
        callHandler.handle(.foo,
                           withArgs: FooArgs(),
                           defaultReturnValue: ())
    }
}
