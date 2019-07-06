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
    var randomNumberGenerator: RandomNumberGenerator!
    var logger: Logger!

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

    func testSmth() {
        let args1 = calculator.mock.sum.args()
        let args2 = calculator.mock.sum.args()
        let args3 = calculator.mock.sum.args()
    }

}
