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

/// A set of rules for verifying call times count.
///
/// - never: callTimes == 0
/// - once: callTimes == 1
/// - times: callTimes == *value*
/// - atLeast: callTimes >= *value*
/// - atMost: callTimes <= *value*
public enum CallTimesRule {
    /// callTimes == 0
    case never
    /// callTimes == 1
    case once
    /// callTimes == *value*
    case times(Int)
    /// callTimes >= *value*
    case atLeast(Int)
    /// callTimes <= *value*
    case atMost(Int)
    
    func verify(_ callTimes: Int) throws {
        var isOK = false
        
        switch self {
        case .never:
            isOK = callTimes == 0
            
        case .once:
            isOK = callTimes == 1
            
        case .times(let times):
            isOK = callTimes == times
            
        case .atLeast(let times):
            isOK = callTimes >= times
            
        case .atMost(let times):
            isOK = callTimes <= times
        }
        
        if !isOK { throw CallTimesRuleIsBroken() }
    }
}

public struct CallTimesRuleIsBroken: Error { }
