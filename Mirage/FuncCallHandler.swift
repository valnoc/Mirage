//
//    MIT License
//
//    Copyright (c) 2019 Valeriy Bezuglyy
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

/// **FuncCallHandler** handles calls of a particular function.
/// Each function has its arguments and a return value. Their types are defined via generic class mechanizm.
/// If there are several arguments it is recommended to create a structure or a class to incapsulate the arguments inside.
public class FuncCallHandler<TArgs, TReturn> {
    
    fileprivate var callHistory: [TArgs] = []
    fileprivate let returnValue: TReturn
    
    fileprivate var stub: Stub<TArgs, TReturn>?
    fileprivate let callRealFunc: ((_ args: TArgs) -> TReturn)?
    
    fileprivate let isPartial: Bool
    
    /// Creates an instance of FuncCallHandler
    ///
    /// - Parameters:
    ///   - returnValue: A default value to return for func calls
    ///   - isPartial: If true - real func is called every time after call registration instead of returning default value
    ///   - callRealFunc: A closure which calls inside real func (not mocked)
    public init(returnValue: TReturn,
                isPartial: Bool = false,
                callRealFunc: ((_ args: TArgs) -> TReturn)? = nil) {
        self.callRealFunc = callRealFunc
        self.returnValue = returnValue
        self.isPartial = isPartial
    }
    
    /// Registers func call and gets the result
    ///
    /// - Parameter args: Call arguments
    /// - Returns: Stubbed result (if stub is present) or a default result (a result of real func for partical mock)
    @discardableResult
    public func handle(_ args: TArgs) -> TReturn {
        callHistory.append(args)
        
        if let stub = stub {
            return stub.execute(args)
            
        } else if isPartial {
            // force unwrapping is used here to get crash if real func caller wasn't given
            return callRealFunc!(args)
            
        } else {
            return returnValue
        }
    }

    //MARK: - verify
    
    /// Checks whether function call times count is approriate according to the rule.
    ///
    /// - Parameter rule: A rule to be verified.
    /// - Returns: True if everything is ok. This return value is unnecessery but without it this func is crossed at completions panel inside XCTAssertNoThrow.
    /// - Throws: CallTimesRuleIsBroken error if the rule was broken
    @discardableResult
    public func verify(called rule: CallTimesRule) throws -> Bool {
        try rule.verify(callTimesCount())
        return true
    }
    
    fileprivate func callTimesCount() -> Int {
        return callHistory.count
    }
    
    //MARK: - args
    
    /// Gets args of last call
    ///
    /// - Returns: Args of last call
    public func args() -> TArgs? {
        return args(callTime: callTimesCount() - 1)
    }
    
    /// Gets args of given callTime
    ///
    /// - Parameter callTime: An index of call
    /// - Returns: Args of call. Will return **nil** if function was called less times then *callTime*.
    public func args(callTime: Int) -> TArgs? {
        guard callTime > -1,
            callTime < callTimesCount() else { return nil }
        return callHistory[callTime]
    }

    //MARK: - stub
    
    /// Creates a stub on first call. After calling this function stub **will always be used** as a prioritized way to get the function result at *handle(TArgs) -> TReturn*.
    ///
    /// - Returns: A stub
    public func whenCalled() -> Stub<TArgs, TReturn> {
        if let stub = stub {
            return stub
        }
        else {
            let stub = Stub<TArgs, TReturn>(callRealFuncClosure: callRealFunc)
            self.stub = stub
            return stub
        }
    }
    
    //MARK: - reset
    
    /// Resets call history and removes existing stub.
    /// It is a rare case when you want to reset a mock because it's likely to be disposed and recreated at **tearDown()** and **setUp()** phases. Nevertheless, their could be a reason to do it - looping through several variants of data, etc.
    public func reset() {
        callHistory.removeAll()
        stub = nil
    }
}
