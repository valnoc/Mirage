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

public class Stub<TArgs, TReturn> {
    public typealias MySelf = Stub<TArgs, TReturn>
    public typealias StubAction = (_ args: TArgs) -> TReturn
    
    var actions: [StubAction] = []
    var nextIndex: Int = 0
    
    let callImplementationClosure: StubAction

    init(callImplementationClosure: @escaping StubAction) {
        self.callImplementationClosure = callImplementationClosure
    }

    //MARK: result

    /// Returns new result instead of default
    ///
    /// - Parameter result: New result.
    /// - Returns: A stub for chained call.
    @discardableResult
    public func thenReturn(_ result: TReturn) -> MySelf {
        actions.append({ (_ args) -> TReturn in
            return result
        })
        return self
    }

    /// Execute closure instead of called function.
    ///
    /// - Parameter closure: A closure to execute.
    /// - Returns: A stub for chained call.
    @discardableResult
    public func thenDo(_ closure: @escaping StubAction) -> MySelf {
        actions.append({ (_ args) -> TReturn in
            return closure(args)
        })
        return self
    }

    /// Call real func implementation.
    ///
    /// - Returns:  A stub for chained call.
    @discardableResult
    public func thenCallImplementation() -> MySelf {
        actions.append(callImplementationClosure)
        return self
    }
    
    //MARK: execute
    func execute(_ args: TArgs) -> TReturn {
        var index = actions.count - 1
        if nextIndex < index {
            index = nextIndex
            nextIndex += 1
        }
        
        return actions[index](args)
    }
}
