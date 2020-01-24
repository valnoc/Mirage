//
//  PartialMockMainObject.swift
//  ExampleTests
//
//  Created by Valeriy Bezuglyy on 07/07/2019.
//  Copyright © 2019 Valeriy Bezuglyy. All rights reserved.
//

import Foundation
@testable import Example
import Mirage2

class PartialMockMainObject: MainObject {
    //MARK: - postFailedNotification
    lazy var mock_performMainOperation = FuncCallHandler<Void, Void>(returnValue: (),
                                                                     isPartial: true,
                                                                     callRealFunc: { [weak self] (args) -> Void in
                                                                        guard let __self = self else { return () }
                                                                        return __self.super_performMainOperation()
    })
    func super_performMainOperation() {
        super.performMainOperation()
    }
    override func performMainOperation() {
        return mock_performMainOperation.handle(())
    }
    
    //MARK: - postFailedNotification
    lazy var mock_postFailedNotification = FuncCallHandler<String, Void>(returnValue: (),
                                                                         isPartial: true,
                                                                         callRealFunc: { [weak self] (args) -> Void in
                                                                            guard let __self = self else { return () }
                                                                            return __self.super_postFailedNotification(args)
    })
    func super_postFailedNotification(_ args: String) {
        super.postFailedNotification(args)
    }
    override func postFailedNotification(_ reason: String) {
        return mock_postFailedNotification.handle(reason)
    }
}
