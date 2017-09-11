//
//  StubAction.swift
//  MirageExample
//
//  Created by Valeriy Bezuglyy on 11/09/2017.
//  Copyright © 2017 Valeriy Bezuglyy. All rights reserved.
//

import Foundation

class StubAction {
    
    var action: (_ args:[Any?]) -> Any?
    
    init(action: @escaping (_ args:[Any?]) -> Any?) {
        self.action = action
    }
}
