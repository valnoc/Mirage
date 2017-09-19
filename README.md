# Mirage
Mirage is a lightweight mocking framework for swift projects. 

Its version is still below 1.0, nevertheless it is production-ready and can be used in your projects. 
Check [Roadmap](https://github.com/valnoc/Mirage/blob/master/README.md#roadmap-for-v10-mvp) for upcoming features.

## Features
It provides a mechanism to 
- create mocks, stubs, partial mocks
- verify call times
- get call arguments history

---
## Installation
Requires Swift 3.0

#### Cocoapods
Add this line into your Podfile under a test target and run `pod update`
```ruby
pod 'Mirage'
```

Podfile example
```ruby
target 'MainTarget' do
  ...
  target 'TestTarget' do
    inherit! :search_paths
    pod 'Mirage'
  end
end
```
#### Source files
Copy /Mirage folder into your test target.

---
## Usage
First of all - check Example project.
### Mocks
A Mock is an object which mimics the behaviour of a real object and records functions' calls.
#### Class mock
To create a class mock (ex. `FirstService`): 
1. Create a new Mock class inhereted from the original 
```swift
class MockService: FirstService
```
2. Implement Mock protocol 
```swift
class MockService: FirstService, Mock
```
First of all add a MockManager variable. It is recommended to add it like a lazy var. 

First argument of MockManager(...) should always be self. Self is not stored anywhere and in fact is used inside init(...) only to get info whether an instance is a mock or a partial mock.

Second argument is a closure which is responsible for calling real implementation of mocked functions. This closure is called with `thenCallRealFunc()` stubs or with partial mocks.
```swift
lazy var mockManager: MockManager = MockManager(self, callRealFuncClosure: { [weak self] (funcName, args) -> Any? in
    guard let __self = self else { return nil }
    return __self.callRealFunc(funcName, args)
})
```
3. Override all funcs which should to be mocked.
New implementation should call mockManager.handle(...) for call registration. 
Arguments are: 
* func string identifier
* default return value (`nil` for void functions) to return if no stub found
* incoming args
```swift
return mockManager.handle(sel_performCalculation, withDefaultReturnValue: 0, withArgs: arg1, arg2) as! Int
```
The best pratice for defining `sel_performCalculation` is to use func name + first args if there are overloads like `func foo(_ a:Double)` and `func foo(_ a:Int)`. Anyway you can pass here any string you wish.

**DO NOT FORGET!** to use passed func identifier in callRealFuncClosure of MockManager and call `super.function(...)`

Example
```swift
class MockFirstService: FirstService, Mock {
    
    lazy var mockManager: MockManager = MockManager(self, callRealFuncClosure: { [weak self] (funcName, args) -> Any? in
        guard let __self = self else { return nil }
        return __self.callRealFunc(funcName, args)
    })
    fileprivate func callRealFunc(_ funcName:String, _ args:[Any?]?) -> Any? {
        switch funcName {
        case sel_performCalculation:
            return super.performCalculation(arg1: args![0] as! Int, arg2: args![1] as! Int)
        default:
            return nil
        }
    }
    
    //MARK: - mocked calls
    let sel_performCalculation = "performCalculation(arg1:arg2:)"
    override func performCalculation(arg1:Int, arg2: Int) -> Int {
        return mockManager.handle(sel_performCalculation, withDefaultReturnValue: 0, withArgs: arg1, arg2) as! Int
    }
}
```
#### Protocol mock
This case is even simpler. Steps are totally the same as creating a class mock except for calling real func implementation.

Example

`SecondService` is just a protocol.
```swift
class MockSecondService: SecondService, Mock {
    
    lazy var mockManager: MockManager = MockManager(self, callRealFuncClosure: { [weak self] (funcName, args) -> Any? in
        guard let __self = self else { return nil }
        return nil
    })
    
    //MARK: - mocked calls
    let sel_makeRandomPositiveInt = "makeRandomPositiveInt()"
    func makeRandomPositiveInt() -> Int {
        return mockManager.handle(sel_makeRandomPositiveInt, withDefaultReturnValue: 4, withArgs: nil) as! Int
    }
    
    let sel_foo = "foo()"
    func foo() {
        mockManager.handle(sel_foo, withDefaultReturnValue: nil, withArgs: nil)
    }
}
```
### Stubs
Function stubbing allows to change the behavour of a function according to testing needs.
To create a stub, call mock function `when(...)`, passing the identifier of a stubbed function.

Then call one of the following:
* `thenReturn(_ result: Any)` to return exact value as a result
* `thenDo(_ closure: @escaping (_ args: [Any?]) -> Void)` to perform some action
* `thenDo(_ closure: @escaping (_ args: [Any?]) -> Any?)` to return a result of action
* `thenDoNothing()` to do... well... nothing)))
* `thenCallReal()` to call real implementation of this function

This `thenSmth` calls can be chained to return one result for first call and another for next calls.

```swift
mockFirstService.when(mockFirstService.sel_performCalculation).thenReturn(100)
mockSecondService.when(mockSecondService.sel_makeRandomPositiveInt).thenReturn(5).thenReturn(100)

var triggered = false
mockFirstService.when(mockFirstService.sel_performCalculation).thenDo({ _ -> Any? in
    triggered = true
    return -100
})

mockFirstService.when(mockFirstService.sel_performCalculation).thenCallReal()
```
### Partial mocks
A Partial mock is smth between a real object and a mock.
- Functions' calls and their args are recorded.
- Functions automatically call real implementation (real object behaviour).
- Any function can be stubbed to return test-needed value or to get alternative behavour.

There are discussions whether partial mock is a pattern or an anti-pattern, whether you therefore should use them or not. 

Mirage allows you to create a partial mock with one line of code. It's up to you - to use or not to use.

To create a partial mock, create a mock subclass, implementing PartialMock protocol.
```swift
class PartialMockFirstService: MockFirstService, PartialMock { }
```
### Verify
There are several verification modes:
- `Never`
- `Once`
- `AtLeast`
- `AtMost`
- `Times` for exact number of times
`verify(...)` throws `WrongCallTimesError` if actual call times do not match verification mode.

Use `XCTAssertNoThrow(try ...)` with `verify` call
```swift
XCTAssertNoThrow(try mockFirstService.verify(mockFirstService.sel_performCalculation, Once()))
XCTAssertNoThrow(try mockSecondService.verify(mockSecondService.sel_makeRandomPositiveInt, Times(2)))
XCTAssertNoThrow(try mockSecondService.verify(mockSecondService.sel_foo, Never()))
```
### Args
You can get arguments of any call from history using `argsOf(...)` function. It returns an array of arguments for this call or nil. So the best pratice is to use guard and XCTFail around `argsOf(...)`.
```swift
guard let args = mockFirstService.argsOf(mockFirstService.sel_performCalculation) else { XCTFail(); return }
guard let arg1 = args[0] as? Int else { XCTFail(); return }
guard let arg2 = args[1] as? Int else { XCTFail(); return }
```
---
## Roadmap for v1.0 (MVP)
#### v0.3
1. partial mocks
1. pods
1. docs
#### v0.4
1. args matching
#### v1.0
1. unit tests
