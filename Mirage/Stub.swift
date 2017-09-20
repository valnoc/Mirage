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

class Stub {
    
    let functionName: String
    let callRealFuncClosure: MockFunctionCallBlock
    
    var actions: [StubAction]
    var nextActionIndex: Int
    
    init(functionName: String, callRealFuncClosure:@escaping MockFunctionCallBlock) {
        self.functionName = functionName
        self.callRealFuncClosure = callRealFuncClosure
        
        actions = []        
        nextActionIndex = 0
    }
    
    //MARK: result
    
    /// Returns new result instead of default
    ///
    /// - Parameter result: New result.
    /// - Returns: A stub for chained call.
    @discardableResult
    func thenReturn(_ result: Any) -> Stub {
        let stubAction = StubAction { (_) -> Any? in
            return result
        }
        actions.append(stubAction)
        return self
    }

    /// Execute closure instead of called function.
    ///
    /// - Parameter closure: A closure to execute.
    /// - Returns: A stub for chained call.
    @discardableResult
    func thenDo(_ closure: @escaping (_ args: [Any?]) -> Void) -> Stub {
        let stubAction = StubAction { (args) -> Any? in
            closure(args)
            return nil
        }
        actions.append(stubAction)
        return self
    }
    
    /// Execute closure instead of called function and return result.
    ///
    /// - Parameter closure: A closure to execute.
    /// - Returns: A stub for chained call.
    @discardableResult
    func thenDo(_ closure: @escaping (_ args: [Any?]) -> Any?) -> Stub {
        let stubAction = StubAction { (args) -> Any? in
            return closure(args)
        }
        actions.append(stubAction)
        return self
    }
    
    /// Do nothing when function was called. Useful for partial mocks as common mocks are already doing nothing on call.
    ///
    /// - Returns: A stub for chained call.
    @discardableResult
    func thenDoNothing() -> Stub {
        let stubAction = StubAction { (args) -> Any? in
            return nil
        }
        actions.append(stubAction)
        return self
    }
    
    /// Call real func implementation.
    ///
    /// - Returns:  A stub for chained call.
    @discardableResult
    func thenCallReal() -> Stub {
        let stubAction = StubAction { [weak self] (args) -> Any? in
            guard let __self = self else { return nil }
            return __self.callRealFuncClosure(__self.functionName, args)
        }
        actions.append(stubAction)
        return self
    }
    
    //MARK: execute
    func executeNextAction(_ args:[Any?]) -> Any? {
        guard actions.count > 0 else { return nil }
        
        var action: StubAction
        if nextActionIndex < actions.count {
            action = actions[nextActionIndex]
            nextActionIndex += 1
        }
        else {
            action = actions.last!
        }
        
        return action.execute(args)
    }
}
