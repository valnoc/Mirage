//
//  PartialMock.swift
//  MirageExample
//
//  Created by Valeriy Bezuglyy on 13/09/2017.
//  Copyright © 2017 Valeriy Bezuglyy. All rights reserved.
//

import Foundation

protocol PartialMock: Mock {
}

extension PartialMock {
    func spy(_ functionName:String) {
        mockManager.spy(functionName)
    }
}

