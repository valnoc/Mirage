//
//  Stub.swift
//  MirageExample
//
//  Created by Valeriy Bezuglyy on 11/09/2017.
//  Copyright © 2017 Valeriy Bezuglyy. All rights reserved.
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
    @discardableResult
    func thenReturn(_ result: Any) -> Stub {
        let stubAction = StubAction { (_) -> Any? in
            return result
        }
        actions.append(stubAction)
        return self
    }

    @discardableResult
    func thenDo(_ closure: @escaping (_ args: [Any?]) -> Void) -> Stub {
        let stubAction = StubAction { (args) -> Any? in
            closure(args)
            return nil
        }
        actions.append(stubAction)
        return self
    }
    
    @discardableResult
    func thenDo(_ closure: @escaping (_ args: [Any?]) -> Any?) -> Stub {
        let stubAction = StubAction { (args) -> Any? in
            return closure(args)
        }
        actions.append(stubAction)
        return self
    }
    
    @discardableResult
    func thenDoNothing() -> Stub {
        let stubAction = StubAction { (args) -> Any? in
            return nil
        }
        actions.append(stubAction)
        return self
    }
    
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
