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

//public typealias MockFunctionCallBlock = (_ functionName: String, _ args: [Any?]?) -> Any?

public class CallHandler<TFunc> where TFunc: Hashable {
    
    fileprivate var callHistory: [TFunc: [Any]] = [:] //[TFunc: [TArgs]]]

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
    public func handle<TArgs, TReturn>(_ function: TFunc,
                                       withArgs args: TArgs,
                                       defaultReturnValue: TReturn) -> TReturn {
        if callHistory[function] == nil { callHistory[function] = [] }
        callHistory[function]?.append(args)
        
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
    func verify(_ function: TFunc, called rule: CallTimesRule) throws {
        try rule.verify(callTimesCount(of: function))
    }

    //MARK: - args
    func callTimesCount(of function: TFunc) -> Int {
        return (callHistory[function] ?? []).count
    }
    
    func argsOf<TArgs>(_ function: TFunc, callTime: Int) -> TArgs? {
        guard callTime > -1,
            let allCalls = callHistory[function],
            callTime < allCalls.count,
            let args = allCalls[callTime] as? TArgs else { return nil }
        return args
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
