//
//  PartialMockMainObject.swift
//  MirageExample
//
//  Created by Valeriy Bezuglyy on 13/09/2017.
//  Copyright © 2017 Valeriy Bezuglyy. All rights reserved.
//

import Foundation

@testable import MirageExample

class PartialMockMainObject: MainObject, PartialMock {
    
    var mockManager: MockManager = MockManager(isPartial: true)
    
    let sel_makeFirstArg = "makeFirstArg"
    override func makeFirstArg() -> Int {
        return mockManager.handle(sel_makeFirstArg, withDefaultReturnValue: 0, withArgs: nil) as! Int
    }
    
    let sel_makeSecondArg = "makeSecondArg"
    override func makeSecondArg() -> Int {
        return mockManager.handle(sel_makeSecondArg, withDefaultReturnValue: 0, withArgs: nil) as! Int
    }
}
