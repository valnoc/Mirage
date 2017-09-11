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
    
    var actions: [StubAction]
    var nextActionIndex: Int
    
    init(functionName: String) {
        self.functionName = functionName
        actions = []
        
        nextActionIndex = 0
    }
    
    //MARK: result
    func thenReturn(_ result: Any) -> Stub {
        let stubAction = StubAction { (_) -> Any? in
            return result
        }
        actions.append(stubAction)
        return self
    }

    func thenDo(_ closure: @escaping (_ args: [Any?]) -> Void) -> Stub {
        let stubAction = StubAction { (args) -> Any? in
            return closure(args)
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
