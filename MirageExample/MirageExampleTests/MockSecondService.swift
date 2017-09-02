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
    
    func makeRandomPositiveInt() -> Int {
        return 4
    }
    
    func foo() {
        
    }
}
