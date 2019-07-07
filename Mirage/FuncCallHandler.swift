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

public class FuncCallHandler<TArgs, TReturn> {
    
    fileprivate var callHistory: [TArgs] = []
    fileprivate let returnValue: TReturn
    
    fileprivate var stub: Stub<TArgs, TReturn>?
    let callRealFunc: ((_ args: TArgs) -> TReturn)?
    
    let isPartial: Bool
    
    public init(returnValue: TReturn,
                isPartial: Bool = false,
                callRealFunc: ((_ args: TArgs) -> TReturn)? = nil) {
        self.callRealFunc = callRealFunc
        self.returnValue = returnValue
        self.isPartial = isPartial
    }
    
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
    @discardableResult
    public func verify(called rule: CallTimesRule) throws -> Bool {
        try rule.verify(callTimesCount())
        return true
    }
    
    func callTimesCount() -> Int {
        return callHistory.count
    }
    
    //MARK: - args
    public func args() -> TArgs? {
        return args(callTime: callTimesCount() - 1)
    }
    
    public func args(callTime: Int) -> TArgs? {
        guard callTime > -1,
            callTime < callTimesCount() else { return nil }
        return callHistory[callTime]
    }

    //MARK: - stub
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
    public func reset() {
        callHistory.removeAll()
        stub = nil
    }
}