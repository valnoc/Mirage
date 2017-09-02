//
//  VerificationStrategy.swift
//  MirageExample
//
//  Created by Valeriy Bezuglyy on 03/09/2017.
//  Copyright © 2017 Valeriy Bezuglyy. All rights reserved.
//

import Foundation

protocol CallTimesVerificator {
    func verify(_ functionName:String, callTimes:Int) throws
}
class WrongCallTimesError: Error {
    //TODO: provide description
}

//MARK: -
class Times: CallTimesVerificator {
    
    var times:Int
    init(_ times:Int) {
        self.times = times
    }
    
    func verify(_ functionName: String, callTimes:Int) throws {
        guard callTimes == times else {
            throw WrongCallTimesError()
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
class AtLeast: CallTimesVerificator {
    
    var times:Int
    init(_ times:Int) {
        self.times = times
    }
    
    func verify(_ functionName: String, callTimes:Int) throws {
        guard callTimes >= times else {
            throw WrongCallTimesError()
        }
    }
}

//MARK: -
class AtMost: CallTimesVerificator {
    
    var times:Int
    init(_ times:Int) {
        self.times = times
    }
    
    func verify(_ functionName: String, callTimes:Int) throws {
        guard callTimes <= times else {
            throw WrongCallTimesError()
        }
    }
}
