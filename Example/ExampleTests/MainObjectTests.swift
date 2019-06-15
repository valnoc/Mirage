//
//  ExampleTests.swift
//  ExampleTests
//
//  Created by Valeriy Bezuglyy on 02/09/2017.
//  Copyright © 2017 Valeriy Bezuglyy. All rights reserved.
//

import XCTest
import Mirage
@testable import Example

class MainObjectTests: XCTestCase {

    var sut: MainObject!

    var firstService: MockFirstService!
    var secondService: MockSecondService!

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.

        firstService = MockFirstService()
        secondService = MockSecondService()

        sut = MainObject(firstService: firstService,
                         secondService: secondService)
    }

    override func tearDown() {
        firstService = nil
        secondService = nil

        sut = nil

        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testGivenPositiveResultWhenPerfromMainOperationThenItShouldCallFoo() {
        //given
//        firstService.when(.performCalculation).thenReturn(100)

        //when
        sut.perfromMainOperation()

        //then
        XCTAssertNoThrow(try firstService.verify(.performCalculation, called: .once))
        XCTAssertNoThrow(try secondService.verify(.makeRandomPositiveInt, called: .times(2)))
        XCTAssertNoThrow(try secondService.verify(.foo, called: .once))
    }

    func testGivenNegativeResultWhenPerfromMainOperationThenItShouldNotCallFoo() {
        //given
        var triggered = false
//        firstService.when(.performCalculation).thenDo({ _ -> Any? in
//            triggered = true
//            return -100
//        })

        //when
        sut.perfromMainOperation()

        //then
        XCTAssertNoThrow(try firstService.verify(.performCalculation, called: .once))
        XCTAssertNoThrow(try secondService.verify(.makeRandomPositiveInt, called: .times(2)))
        XCTAssertNoThrow(try secondService.verify(.foo, called: .never))
        XCTAssert(triggered == true)
    }

    func testGivenTwoPositiveValuesChainingWhenPerfromMainOperationThenItShouldCallFoo() {
        //given
//        secondService.when(.makeRandomPositiveInt).thenReturn(5).thenReturn(100)
//        firstService.when(.performCalculation).thenCallReal()

        //when
        sut.perfromMainOperation()

        //then
        XCTAssertNoThrow(try firstService.verify(.performCalculation, called: .once))
        XCTAssertNoThrow(try secondService.verify(.makeRandomPositiveInt, called: .times(2)))
        XCTAssertNoThrow(try secondService.verify(.foo, called: .once))
    }

    func testPerformArgOperation() {
        //given
        let a = 15
        let b = 200

        //when
        sut.performArgOperation(a, b)

        //then
        XCTAssertNoThrow(try firstService.verify(.performCalculation, called: .once))

        guard let args = firstService.argsOf(.performCalculation) as MockFirstService.PerformCalculationArgs else { XCTFail(); return }

        XCTAssert(args.arg1 == a)
        XCTAssert(args.arg2 == b * 2)
    }

//    func testWhenCalculateSumThenItShouldCallMakeFirstAndSecondArgs() {
//        //given
//        let partial = PartialMockMainObject(firstService: firstService, secondService: secondService)
//
//        //when
//        let result = partial.calculateSum()
//
//        //then
//        XCTAssertNoThrow(try partial.verify(partial.sel_makeFirstArg, called: .once))
//        XCTAssertNoThrow(try partial.verify(partial.sel_makeSecondArg, called: .once))
//        XCTAssert(result == 7)
//    }

}
