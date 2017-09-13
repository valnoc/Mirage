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
        
        mockFirstService = MockFirstService()
        mockSecondService = MockSecondService()
        
        sut = MainObject(firstService: mockFirstService,
                         secondService: mockSecondService)
    }
    
    override func tearDown() {
        mockFirstService = nil
        mockSecondService = nil
        
        sut = nil
        
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testGivenPositiveResultWhenPerfromMainOperationThenItShouldCallFoo() {
        //given
        mockFirstService.when(mockFirstService.sel_performCalculation).thenReturn(100)
        
        //when
        sut.perfromMainOperation()
        
        //then
        XCTAssertNoThrow(try mockFirstService.verify(mockFirstService.sel_performCalculation, Once()))
        XCTAssertNoThrow(try mockSecondService.verify(mockSecondService.sel_makeRandomPositiveInt, Times(2)))
        XCTAssertNoThrow(try mockSecondService.verify(mockSecondService.sel_foo, Once()))
    }
    
    func testGivenNegativeResultWhenPerfromMainOperationThenItShouldNotCallFoo() {
        //given
        var triggered = false
        mockFirstService.when(mockFirstService.sel_performCalculation).thenDo({ _ -> Any? in
            triggered = true
            return -100
        })
        
        //when
        sut.perfromMainOperation()
        
        //then
        XCTAssertNoThrow(try mockFirstService.verify(mockFirstService.sel_performCalculation, Once()))
        XCTAssertNoThrow(try mockSecondService.verify(mockSecondService.sel_makeRandomPositiveInt, Times(2)))
        XCTAssertNoThrow(try mockSecondService.verify(mockSecondService.sel_foo, Never()))
        XCTAssert(triggered == true)
    }
    
    func testGivenTwoPositiveValuesChainingWhenPerfromMainOperationThenItShouldCallFoo() {
        //given
        mockSecondService.when(mockSecondService.sel_makeRandomPositiveInt).thenReturn(5).thenReturn(100)
        
        mockFirstService.when(mockFirstService.sel_performCalculation).thenDo({ args -> Any? in
            let arg1 = args.first as? Int ?? 0
            let arg2 = args.last as? Int ?? 0
            return arg1 + arg2
        })
        
        //when
        sut.perfromMainOperation()
        
        //then
        XCTAssertNoThrow(try mockFirstService.verify(mockFirstService.sel_performCalculation, Once()))
        XCTAssertNoThrow(try mockSecondService.verify(mockSecondService.sel_makeRandomPositiveInt, Times(2)))
        XCTAssertNoThrow(try mockSecondService.verify(mockSecondService.sel_foo, Once()))
    }
    
    func testPerformArgOperation() {
        //given
        let a = 15
        let b = 200
        
        //when
        sut.performArgOperation(a, b)
        
        //then
        XCTAssertNoThrow(try mockFirstService.verify(mockFirstService.sel_performCalculation, Once()))
        
        guard let args = mockFirstService.argsOf(mockFirstService.sel_performCalculation) else { XCTFail(); return }
        guard let arg1 = args[0] as? Int else { XCTFail(); return }
        guard let arg2 = args[1] as? Int else { XCTFail(); return }
        
        XCTAssert(arg1 == a)
        XCTAssert(arg2 == b * 2)
    }
    
}
