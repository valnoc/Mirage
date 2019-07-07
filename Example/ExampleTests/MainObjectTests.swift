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

    var sut: PartialMockMainObject!

    var calculator: MockCalculator!
    var randomNumberGenerator: MockRandomNumberGenerator!
    var logger: MockLogger!

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.

        calculator = MockCalculator()
        randomNumberGenerator = MockRandomNumberGenerator()
        logger = MockLogger()
        
        sut = PartialMockMainObject(calculator: calculator,
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

    //MARK: - simple
    func test_GivenNumbersFromGenerator_WhenMainOperation_ThenNumbersArePassedIntoCalculatorWithoutModification() {
        // given
        randomNumberGenerator.mock_makeInt.whenCalled()
            .thenReturn(5)
            .thenReturn(10)
        
        // when
        sut.performMainOperation()
        
        // then
        XCTAssertNoThrow(try randomNumberGenerator.mock_makeInt.verify(called: .times(2)))
        XCTAssertNoThrow(try calculator.mock_sum.verify(called: .once))
        
        guard let args = calculator.mock_sum.args() else { XCTFail(); return }
        XCTAssert(args.left == 5)
        XCTAssert(args.right == 10)
    }
    
    func test_GivenPositiveSum_WhenMainOperation_ThenItLogsPositiveResult() {
        // given
        calculator.mock_sum.whenCalled().thenReturn(1)
        
        // when
        sut.performMainOperation()
        
        // then
        XCTAssertNoThrow(try randomNumberGenerator.mock_makeInt.verify(called: .times(2)))
        XCTAssertNoThrow(try calculator.mock_sum.verify(called: .once))
        
        XCTAssertNoThrow(try logger.mock_logPositiveResult.verify(called: .once))
        XCTAssertNoThrow(try logger.mock_logNegativeResult.verify(called: .never))
        
        XCTAssertNoThrow(try sut.mock_postFailedNotification.verify(called: .never))
    }
    
    func test_GivenZeroSum_WhenMainOperation_ThenItLogsPositiveResult() {
        // given
        calculator.mock_sum.whenCalled().thenReturn(0)
        
        // when
        sut.performMainOperation()
        
        // then
        XCTAssertNoThrow(try randomNumberGenerator.mock_makeInt.verify(called: .times(2)))
        XCTAssertNoThrow(try calculator.mock_sum.verify(called: .once))
        
        XCTAssertNoThrow(try logger.mock_logPositiveResult.verify(called: .once))
        XCTAssertNoThrow(try logger.mock_logNegativeResult.verify(called: .never))
        
        XCTAssertNoThrow(try sut.mock_postFailedNotification.verify(called: .never))
    }
    
    func test_GivenNegativeSum_WhenMainOperation_ThenItLogsNegativeResult() {
        // given
        calculator.mock_sum.whenCalled().thenReturn(-1)
        
        // when
        sut.performMainOperation()
        
        // then
        XCTAssertNoThrow(try randomNumberGenerator.mock_makeInt.verify(called: .times(2)))
        XCTAssertNoThrow(try calculator.mock_sum.verify(called: .once))
        
        XCTAssertNoThrow(try logger.mock_logPositiveResult.verify(called: .never))
        XCTAssertNoThrow(try logger.mock_logNegativeResult.verify(called: .once))
        
        XCTAssertNoThrow(try sut.mock_postFailedNotification.verify(called: .once))
    }

    //MARK: - array
    func test_GivenAnyNonNegativeSum_WhenMainOperation_ThenItLogsPositiveResult() {
        for number in 0...100000 {
            calculator.mock_sum.reset()
            randomNumberGenerator.mock_makeInt.reset()
            logger.mock_logNegativeResult.reset()
            logger.mock_logPositiveResult.reset()
            sut.mock_postFailedNotification.reset()
            
            // given
            calculator.mock_sum.whenCalled().thenReturn(number)
            
            // when
            sut.performMainOperation()
            
            // then
            XCTAssertNoThrow(try randomNumberGenerator.mock_makeInt.verify(called: .times(2)))
            XCTAssertNoThrow(try calculator.mock_sum.verify(called: .once))
            
            XCTAssertNoThrow(try logger.mock_logPositiveResult.verify(called: .once))
            XCTAssertNoThrow(try logger.mock_logNegativeResult.verify(called: .never))
            
            XCTAssertNoThrow(try sut.mock_postFailedNotification.verify(called: .never))
        }
    }
    
    func test_GivenAnyNegativeSum_WhenMainOperation_ThenItLogsNevativeResult() {
        for number in -100000...(-1) {
            calculator.mock_sum.reset()
            randomNumberGenerator.mock_makeInt.reset()
            logger.mock_logNegativeResult.reset()
            logger.mock_logPositiveResult.reset()
            sut.mock_postFailedNotification.reset()
            
            // given
            calculator.mock_sum.whenCalled().thenReturn(number)
            
            // when
            sut.performMainOperation()
            
            // then
            XCTAssertNoThrow(try randomNumberGenerator.mock_makeInt.verify(called: .times(2)))
            XCTAssertNoThrow(try calculator.mock_sum.verify(called: .once))
            
            XCTAssertNoThrow(try logger.mock_logPositiveResult.verify(called: .never))
            XCTAssertNoThrow(try logger.mock_logNegativeResult.verify(called: .once))
            
            XCTAssertNoThrow(try sut.mock_postFailedNotification.verify(called: .once))
        }
    }
}
