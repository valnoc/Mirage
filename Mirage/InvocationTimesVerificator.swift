//
//  VerificationStrategy.swift
//  MirageExample
//
//  Created by Valeriy Bezuglyy on 03/09/2017.
//  Copyright © 2017 Valeriy Bezuglyy. All rights reserved.
//

import Foundation

protocol InvocationTimesVerificator {
    func verify(_ functionName:String, invocationTimes:Int) throws
}
class WrongInvocationTimesError: Error {
    //TODO: provide description
}

//MARK: -
class Times: InvocationTimesVerificator {
    
    var times:Int
    init(_ times:Int) {
        self.times = times
    }
    
    func verify(_ functionName: String, invocationTimes:Int) throws {
        guard invocationTimes == times else {
            throw WrongInvocationTimesError()
        }
    }
}

//MARK: -
class Once: Times {
    init() {
        super.init(1)
    }
}

//MARK: -
class Never: Times {
    init() {
        super.init(0)
    }
}

//MARK: -
class AtLeast: InvocationTimesVerificator {
    
    var times:Int
    init(_ times:Int) {
        self.times = times
    }
    
    func verify(_ functionName: String, invocationTimes:Int) throws {
        guard invocationTimes >= times else {
            throw WrongInvocationTimesError()
        }
    }
}

//MARK: -
class AtMost: InvocationTimesVerificator {
    
    var times:Int
    init(_ times:Int) {
        self.times = times
    }
    
    func verify(_ functionName: String, invocationTimes:Int) throws {
        guard invocationTimes <= times else {
            throw WrongInvocationTimesError()
        }
    }
}
