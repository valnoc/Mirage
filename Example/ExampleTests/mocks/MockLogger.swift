//
//  MockLogger.swift
//  ExampleTests
//
//  Created by Valeriy Bezuglyy on 04/07/2019.
//  Copyright © 2019 Valeriy Bezuglyy. All rights reserved.
//

import Foundation
@testable import Example
import Mirage2

class MockLogger: Logger {
    //MARK: - logPositiveResult
    lazy var mock_logPositiveResult = FuncCallHandler<Int, Void>(returnValue: ())
    func logPositiveResult(_ result: Int) {
        return mock_logPositiveResult.handle(result)
    }
    
    lazy var mock_logNegativeResult = FuncCallHandler<Int, Void>(returnValue: ())
    func logNegativeResult(_ result: Int) {
        return mock_logNegativeResult.handle(result)
    }
}
