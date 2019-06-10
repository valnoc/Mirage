//
//  MainObject.swift
//  MirageExample
//
//  Created by Valeriy Bezuglyy on 02/09/2017.
//  Copyright © 2017 Valeriy Bezuglyy. All rights reserved.
//

import Foundation

class MainObject {

    var firstService: FirstService
    var secondService: SecondService

    init(firstService: FirstService,
         secondService: SecondService) {
        self.firstService = firstService
        self.secondService = secondService
    }

    func perfromMainOperation() {
        let sum = firstService.performCalculation(arg1: secondService.makeRandomPositiveInt(), arg2: secondService.makeRandomPositiveInt())

        if sum > 0 {
            secondService.foo()
        } else {
            postFailedNotification("sum < 0")
        }
    }

    func postFailedNotification(_ reason: String) {
    }

    func performArgOperation(_ a: Int, _ b: Int) {
        _ = firstService.performCalculation(arg1: a, arg2: b * 2)
    }

    func calculateSum() -> Int {
        return makeFirstArg() + makeSecondArg()
    }

    func makeFirstArg() -> Int {
        return 2
    }

    func makeSecondArg() -> Int {
        return 5
    }
}
