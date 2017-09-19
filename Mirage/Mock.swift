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

protocol Mock {
    var mockManager: MockManager {get set}
}

//MARK: verify
extension Mock {
    func verify(_ functionName:String, _ callTimesVerificator:CallTimesVerificator) throws {
        try mockManager.verify(functionName, callTimesVerificator)
    }
}

//MARK: args
extension Mock {
    func argsOf(_ functionName:String) -> [Any?]? {
        return argsOfFirstCall(functionName)
    }
    func argsOfFirstCall(_ functionName:String) -> [Any?]? {
        return argsOf(functionName, callTime: 0)
    }
    func argsOfLastCall(_ functionName:String) -> [Any?]? {
        return argsOf(functionName, callTime: mockManager.totalCallTimes(functionName) - 1)
    }
    func argsOf(_ functionName:String, callTime:Int) -> [Any?]? {
        return mockManager.argsOf(functionName, callTime: callTime)
    }
}

//MARK: stub 
extension Mock {
    func when(_ functionName:String) -> Stub {
        return mockManager.when(functionName)
    }
}
