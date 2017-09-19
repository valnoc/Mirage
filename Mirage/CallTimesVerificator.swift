//
//    MIT License
//
//    Copyright (c) 2017 Valeriy Bezuglyy
//
//    Permission is hereby granted, free of charge, to any person obtaining a copy
//    of this software and associated documentation files (the "Software"), to deal
//    in the Software without restriction, including without limitation the rights
//    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//    copies of the Software, and to permit persons to whom the Software is
//    furnished to do so, subject to the following conditions:
//
//    The above copyright notice and this permission notice shall be included in all
//    copies or substantial portions of the Software.
//
//    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//    SOFTWARE.
//

import Foundation

protocol CallTimesVerificator {
    func verify(_ functionName:String, totalCallTimes:Int) throws
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
    
    func verify(_ functionName: String, totalCallTimes:Int) throws {
        guard totalCallTimes == times else {
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
    
    func verify(_ functionName: String, totalCallTimes:Int) throws {
        guard totalCallTimes >= times else {
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
    
    func verify(_ functionName: String, totalCallTimes:Int) throws {
        guard totalCallTimes <= times else {
            throw WrongCallTimesError()
        }
    }
}
