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

    var calculator: MockCalculator!
    var randomNumberGenerator: MockRandomNumberGenerator!
    var logger: MockLogger!

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.

        calculator = MockCalculator()
        randomNumberGenerator = MockRandomNumberGenerator()
        logger = MockLogger()
        
        sut = MainObject(calculator: calculator,
                         randomNumberGenerator: randomNumberGenerator,
                         logger: logger)
    }

    override func tearDown() {
        calculator = nil
        randomNumberGenerator = nil
        logger = nil

        sut = nil

        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    // - simple
    func testGivenPositiveSumWhenMainOperationThenItLogsPositiveResult() {
        // given
        calculator.mock_sum.when().thenReturn(1)
        
        // when
        sut.performMainOperation()
        
        // then
        XCTAssertNoThrow(try randomNumberGenerator.mock_makeInt.verify(called: .times(2)))
        XCTAssertNoThrow(try calculator.mock_sum.verify(called: .once))
        
        XCTAssertNoThrow(try logger.mock_logPositiveResult.verify(called: .once))
        XCTAssertNoThrow(try logger.mock_logNegativeResult.verify(called: .never))
    }
    
    func testGivenZeroSumWhenMainOperationThenItLogsPositiveResult() {
        // given
        calculator.mock_sum.when().thenReturn(0)
        
        // when
        sut.performMainOperation()
        
        // then
        XCTAssertNoThrow(try randomNumberGenerator.mock_makeInt.verify(called: .times(2)))
        XCTAssertNoThrow(try calculator.mock_sum.verify(called: .once))
        
        XCTAssertNoThrow(try logger.mock_logPositiveResult.verify(called: .once))
        XCTAssertNoThrow(try logger.mock_logNegativeResult.verify(called: .never))
    }
    
    func testGivenNegativeSumWhenMainOperationThenItLogsNegativeResult() {
        // given
        calculator.mock_sum.when().thenReturn(-1)
        
        // when
        sut.performMainOperation()
        
        // then
        XCTAssertNoThrow(try randomNumberGenerator.mock_makeInt.verify(called: .times(2)))
        XCTAssertNoThrow(try calculator.mock_sum.verify(called: .once))
        
        XCTAssertNoThrow(try logger.mock_logPositiveResult.verify(called: .never))
        XCTAssertNoThrow(try logger.mock_logNegativeResult.verify(called: .once))
    }

    // - array
    func testGivenAnyNonNegativeSumWhenMainOperationThenItLogsPositiveResult() {
        for number in 0...100000 {
            calculator.mock_sum.reset()
            randomNumberGenerator.mock_makeInt.reset()
            logger.mock_logNegativeResult.reset()
            logger.mock_logPositiveResult.reset()
            
            // given
            calculator.mock_sum.when().thenReturn(number)
            
            // when
            sut.performMainOperation()
            
            // then
            XCTAssertNoThrow(try randomNumberGenerator.mock_makeInt.verify(called: .times(2)))
            XCTAssertNoThrow(try calculator.mock_sum.verify(called: .once))
            
            XCTAssertNoThrow(try logger.mock_logPositiveResult.verify(called: .once))
            XCTAssertNoThrow(try logger.mock_logNegativeResult.verify(called: .never))
        }
    }
    
    func testGivenAnyNegativeSumWhenMainOperationThenItLogsNevativeResult() {
        for number in -100000...(-1) {
            calculator.mock_sum.reset()
            randomNumberGenerator.mock_makeInt.reset()
            logger.mock_logNegativeResult.reset()
            logger.mock_logPositiveResult.reset()
            
            // given
            calculator.mock_sum.when().thenReturn(number)
            
            // when
            sut.performMainOperation()
            
            // then
            XCTAssertNoThrow(try randomNumberGenerator.mock_makeInt.verify(called: .times(2)))
            XCTAssertNoThrow(try calculator.mock_sum.verify(called: .once))
            
            XCTAssertNoThrow(try logger.mock_logPositiveResult.verify(called: .never))
            XCTAssertNoThrow(try logger.mock_logNegativeResult.verify(called: .once))
        }
    }
}
