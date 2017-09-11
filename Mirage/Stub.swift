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
    
    init(functionName: String) {
        self.functionName = functionName
        actions = []
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
}
