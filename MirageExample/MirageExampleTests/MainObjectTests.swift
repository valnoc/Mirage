//
//  MirageExampleTests.swift
//  MirageExampleTests
//
//  Created by Valeriy Bezuglyy on 02/09/2017.
//  Copyright © 2017 Valeriy Bezuglyy. All rights reserved.
//

import XCTest
@testable import MirageExample

class MainObjectTests: XCTestCase {
    
    var sut: MainObject!
    
    var mockFirstService: MockFirstService!
    var mockSecondService: MockSecondService!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        sut = MainObject(firstService: mockFirstService,
                         secondService: mockSecondService)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}