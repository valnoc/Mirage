//
//  MockFirstService.swift
//  MirageExample
//
//  Created by Valeriy Bezuglyy on 02/09/2017.
//  Copyright © 2017 Valeriy Bezuglyy. All rights reserved.
//

import Foundation

@testable import MirageExample

class MockFirstService: FirstService, Mock {
    
    var mockManager: MockManager = MockManager()
    
    let sel_performCalculation = "performCalculation(arg1:arg2:)"
    override func performCalculation(arg1:Int, arg2: Int) -> Int {
        return mockManager.handle(sel_performCalculation, withDefaultReturnValue: 0, withArgs: arg1, arg2) as! Int
    }
}
