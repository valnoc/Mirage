# Mirage
[![](https://img.shields.io/cocoapods/v/Mirage.svg)]()

Mirage is a mocking library for swift projects. 
The recommended way is to use [Fata Morgana](https://github.com/valnoc/FataMorgana) for mocks generation to avoid writing them manually.

## Features
Using Mirage you can:
- create mocks, stubs, partial mocks
- verify `func` call times
- get call arguments history

---
## Installation
Requires Swift 4.2

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
Check Example project for details.
Try [Fata Morgana](https://github.com/valnoc/FataMorgana) for mocks generation.

### Mocks
A Mock is an object which mimics behaviour of a real object and records functions' calls. You can create `class` mocks and `protocol` mocks in the same way.

> The **first version of Mirage** provided the instruments to create a mock for a whole class or a protocol. A mock could be easily created manually but the usage was not so good - you had to cast args to there types every time you call `args(of:)` and the stubs returned `Any`. Since **Mirage 2** funcs are mocked individually. 

All mocks and stubs are generics. They use `TArgs` and `TReturn` types.

If a func has one argument `TArgs` should be of its type. But if it has several arguments you should create a struct (or class) as a container of this args.

`TReturn` represents func's return type.

#### Mock Example
Let's create a mock for this class

```swift
class Calculator {
    func sum(_ left: Int, _ right: Int) -> Int {
        return left + right
    }
}
```

##### Full variant
1. Create a new Mock class inhereted from the original 
```swift
import Mirage

class MockCalculator: Calculator {
```
2. `func sum` has 2 args `left` and `right` so let's create a nested class (or a struct) to contain them
```swift
    class SumArgs {
        let left: Int
        let right: Int
        
        init(left: Int, right: Int) {
            self.left = left
            self.right = right
        }
    }
```
3. Add this `func` to call real implementation of this function
```swift
    fileprivate func super_sum(_ args: SumArgs) -> Int {
        return super.sum(args.left, args.right)
    }
```
4. Add `FuncCallHandler`. This is the core of func mocking.
```swift
    lazy var mock_sum = FuncCallHandler<SumArgs, Int>(returnValue: anyInt(),
                                                      callRealFunc: { [weak self] (args) -> Int in
                                                        guard let __self = self else { return anyInt() }
                                                        return __self.super_sum(args)
    })
```    
5. `override` the original func and call `mock_sum` to handle func call
```swift
    override func sum(_ left: Int, _ right: Int) -> Int {
        let args = SumArgs(left: left, right: right)
        return mock_sum.handle(args)
    }
```

This is it)
```swift
class MockCalculator: Calculator {
    //MARK: - sum
    class SumArgs {
        let left: Int
        let right: Int
        
        init(left: Int, right: Int) {
            self.left = left
            self.right = right
        }
    }
    fileprivate func super_sum(_ args: SumArgs) -> Int {
        return super.sum(args.left, args.right)
    }
    lazy var mock_sum = FuncCallHandler<SumArgs, Int>(returnValue: anyInt(),
                                                      callRealFunc: { [weak self] (args) -> Int in
                                                        guard let __self = self else { return anyInt() }
                                                        return __self.super_sum(args)
    })
    override func sum(_ left: Int, _ right: Int) -> Int {
        let args = SumArgs(left: left, right: right)
        return mock_sum.handle(args)
    }
}
```

##### Short variant
```swift
class MockCalculator: Calculator {
    //MARK: - sum
    struct SumArgs {
        let left: Int
        let right: Int
    }
    lazy var mock_sum = FuncCallHandler<SumArgs, Int>(returnValue: anyInt())
    override func sum(_ left: Int, _ right: Int) -> Int {
        let args = SumArgs(left: left, right: right)
        return mock_sum.handle(args)
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
## License
Mirage is available under MIT License.
