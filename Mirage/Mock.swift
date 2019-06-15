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

public protocol Mock {
    associatedtype Func
    
    var callHandler: CallHandler<Func> {get set}
}

//MARK: verify
public extension Mock {
    
    /// Verifies that function was called an expected number of times according to verificator.
    ///
    /// - Parameters:
    ///   - functionName: Name of the function.
    ///   - callTimesVerificator: Verificator describes expected number of call times.
    /// - Throws: WrongCallTimesError if function was called another number of times than it was expected.
    func verifyCallTimes(_ function: Func, _ rule: CallTimesRule) throws {
        try callHandler.verify(function, rule)
    }
}

//MARK: args
public extension Mock {
    
    /// Get args of first call from history.
    ///
    /// - Parameter functionName: Name of the function.
    /// - Returns: Array of args or nil.
    func argsOf(_ functionName: String) -> [Any?]? {
        return argsOfFirstCall(functionName)
    }
    
    /// Get args of first call from history.
    ///
    /// - Parameter functionName: Name of the function.
    /// - Returns: Array of args or nil.
    func argsOfFirstCall(_ functionName: String) -> [Any?]? {
        return argsOf(functionName, callTime: 0)
    }
    
    /// Get args of last call from history.
    ///
    /// - Parameter functionName: Name of the function.
    /// - Returns: Array of args or nil.
    func argsOfLastCall(_ functionName: String) -> [Any?]? {
        return argsOf(functionName, callTime: mockManager.totalCallTimes(functionName) - 1)
    }
    
    /// Get args of exact call from history.
    ///
    /// - Parameters:
    ///   - functionName: Name of the function.
    ///   - callTime: Call order.
    /// - Returns: Array of args or nil.
    func argsOf(_ functionName: String, callTime: Int) -> [Any?]? {
        return mockManager.argsOf(functionName, callTime: callTime)
    }
}

//MARK: stub 
public extension Mock {
    
    /// Creates a stub for a function.
    ///
    /// - Parameter functionName: Name of the function.
    /// - Returns: A function stub to be called with `thenDoSmth`, etc.
    func when(_ functionName: String) -> Stub {
        return mockManager.when(functionName)
    }
}
