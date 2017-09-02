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
        }
        else {
            postFailedNotification()
        }
    }
    
    func postFailedNotification() {        
    }
    
}
