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
    
    public init(defaultReturnValue: TReturn) {
        self.defaultReturnValue = defaultReturnValue
    }
    
//    var stubs: [Stub]
//    let callRealFuncClosure: MockFunctionCallBlock
//
//    let shouldCallRealFuncs:Bool

//    public init(callRealFuncClosure: @escaping MockFunctionCallBlock) {
//        self.callRealFuncClosure = callRealFuncClosure
//        shouldCallRealFuncs = mock is PartialMock
//
//        callHistory = [:]
//        stubs = []
//    }
    
    @discardableResult
    public func handle(_ args: TArgs) -> TReturn {
        callHistory.append(args)
        
//        if let stub = stubForFunction(functionName) {
//            //TODO: fix
//            return stub.executeNextAction(args) as! TReturn
//
//        } else if shouldCallRealFuncs {
//            //TODO: fix
//            return callRealFuncClosure(functionName, args) as! TReturn
//
//        } else {
            return defaultReturnValue
//        }
    }

    //MARK: - verify
    func verify(called rule: CallTimesRule) throws {
        try rule.verify(callTimesCount())
    }
    
    func callTimesCount() -> Int {
        return callHistory.count
    }
    
    //MARK: - args
    func args() -> TArgs? {
        return callHistory[callTimesCount() - 1]
    }
    
    func args(callTime: Int) -> TArgs? {
        guard callTime > -1,
            callTime < callTimesCount() else { return nil }
        return callHistory[callTime]
    }

//    //MARK: stub
//    func when(_ function: TFunc) -> Stub {
//        if let oldStub = stubForFunction(functionName) {
//            return oldStub
//
//        } else {
//            let stub = Stub(functionName: functionName, callRealFuncClosure: callRealFuncClosure)
//            stubs.append(stub)
//            return stub
//        }
//    }
//
//    fileprivate func stubForFunction(_ function: TFunc) -> Stub? {
//        return stubs.filter({$0.functionName == functionName}).first
//    }

}
