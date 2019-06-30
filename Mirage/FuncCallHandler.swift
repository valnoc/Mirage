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
    fileprivate let defaultReturnValue: TReturn
    
    fileprivate var stub: Stub<TArgs, TReturn>?
    let callImplementationClosure: (_ args: TArgs) -> TReturn
    let shouldCallImplementation: Bool
    
    public init(callImplementationClosure: @escaping (_ args: TArgs) -> TReturn,
                defaultReturnValue: TReturn) {
        self.callImplementationClosure = callImplementationClosure
        self.defaultReturnValue = defaultReturnValue
        shouldCallImplementation = false
    }
    
    @discardableResult
    public func handle(_ args: TArgs) -> TReturn {
        callHistory.append(args)
        
        if let stub = stub {
            return stub.execute(args)

        } else if shouldCallImplementation {
            return callImplementationClosure(args)

        } else {
            return defaultReturnValue
        }
    }

    //MARK: - verify
    public func verify(called rule: CallTimesRule) throws {
        try rule.verify(callTimesCount())
    }
    
    func callTimesCount() -> Int {
        return callHistory.count
    }
    
    //MARK: - args
    public func args() -> TArgs? {
        return callHistory[callTimesCount() - 1]
    }
    
    public func args(callTime: Int) -> TArgs? {
        guard callTime > -1,
            callTime < callTimesCount() else { return nil }
        return callHistory[callTime]
    }

    //MARK: stub
    public func when() -> Stub<TArgs, TReturn> {
        if let stub = stub {
            return stub
        }
        else {
            let stub = Stub<TArgs, TReturn>(callImplementationClosure: callImplementationClosure)
            self.stub = stub
            return stub
        }
    }
}
