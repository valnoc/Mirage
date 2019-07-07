//
//  MainObject.swift
//  Example
//
//  Created by Valeriy Bezuglyy on 02/09/2017.
//  Copyright © 2017 Valeriy Bezuglyy. All rights reserved.
//

import Foundation

class MainObject {

    var calculator: Calculator
    var randomNumberGenerator: RandomNumberGenerator
    var logger: Logger

    init(calculator: Calculator,
         randomNumberGenerator: RandomNumberGenerator,
         logger: Logger) {
        self.calculator = calculator
        self.randomNumberGenerator = randomNumberGenerator
        self.logger = logger
    }

    func performMainOperation() {
        let sum = calculator.sum(randomNumberGenerator.makeInt(),
                                 randomNumberGenerator.makeInt())
        if sum >= 0 {
            logger.logPositiveResult(sum)
        } else {
            logger.logNegativeResult(sum)
            postFailedNotification("negative sum")
        }
    }

    func postFailedNotification(_ reason: String) {
        // show message or smth
    }
}
