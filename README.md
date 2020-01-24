# Mirage
[![License](https://img.shields.io/github/license/valnoc/Mirage.svg)](https://github.com/valnoc/Mirage/blob/master/LICENSE) [![GitHub issues](https://img.shields.io/github/issues-raw/valnoc/Mirage.svg)](https://github.com/valnoc/Mirage/issues) 

[![Cocoapods release](https://img.shields.io/cocoapods/v/Mirage.svg)]() [![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage) [![GitHub release](https://img.shields.io/github/release/valnoc/Mirage.svg)](https://github.com/valnoc/Mirage/releases) 

Mirage is a mocking library for swift projects. 
The recommended way is to use [Fata Morgana](https://github.com/valnoc/FataMorgana) for mocks generation to avoid writing them manually.

- [Features](#features)
- [Installation](#installation)
  - [Carthage](#carthage)
  - [Cocoapods](#cocoapods)
  - [Source files](#source-files)
- [Usage](#usage)
  - [Mocks](#mocks)
  - [Stubs](#stubs)
  - [Partial mocks](#partial-mocks)
  - [Verify call times](#verify-call-times)
  - [Call Args](#call-args)
- [Migration Guide](#migration-guide)
- [License](#license)

## Features
Using Mirage you can:
- create mocks, stubs, partial mocks
- verify `func` call times
- get call arguments history

---
## Installation
Requires Swift 4.2+

#### Carthage
Add this line into your Cartfile, run `carthage update --platform iOS` and link binary to the target as you always do it)
```ruby
github "valnoc/Mirage" ~> 2.0
```

#### Cocoapods
Add this line into your Podfile under a test target and run `pod update`
```ruby
pod 'Mirage', '~> 2.0'
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
`super_sum` and `callRealFunc` can be skipped if you are not going to use it.
You can also use a struct and get a generated `init`.
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
To create a stub, call mock function `whenCalled()`. 

Then call one of the following functions:
* `thenReturn(_ result: TReturn)` to return the exact value as a result
* `thenDo(_ closure: @escaping Action)` to execute closure instead of called function
* `thenCallRealFunc()` to call real implementation of this function

This `thenSmth` calls can be chained to return one result for the first call and another one for the next calls.

```swift
calculator.mock_sum.whenCalled().thenReturn(number)

randomNumberGenerator.mock_makeInt.whenCalled()
    .thenReturn(5)
    .thenReturn(10)
```

### Partial mocks
A Partial mock is the same thing as a mock but it automatically calls real implementations of its functions.
There are discussions whether partial mock is a pattern or an anti-pattern, whether you therefore should use them or not. 

Mirage allows you to create a partial mock with one line of code. It's up to you - to use or not to use.
To create a partial mock of a func, add `isPartial: true` to a `FuncCallHandler`
```swift
lazy var mock_performMainOperation = FuncCallHandler<Void, Void>(returnValue: (),
                                                                 isPartial: true,
                                                                 callRealFunc: { [weak self] (args) -> Void in
                                                                    guard let __self = self else { return () }
                                                                    return __self.super_performMainOperation()
})
```

### Verify call times
You can call `verify(called:)` on any `FuncCallHandler` to check the number of times this func was called
```swift
- never: callTimes == 0
- once: callTimes == 1
- times: callTimes == *value*
- atLeast: callTimes >= *value*
- atMost: callTimes <= *value*
```

`verify(called:)` throws `CallTimesRuleIsBroken` if actual call times do not match the given rule.

Use `XCTAssertNoThrow(try ...)` with `verify` call
```swift
XCTAssertNoThrow(try randomNumberGenerator.mock_makeInt.verify(called: .times(2)))
XCTAssertNoThrow(try calculator.mock_sum.verify(called: .once))

XCTAssertNoThrow(try logger.mock_logPositiveResult.verify(called: .once))
XCTAssertNoThrow(try logger.mock_logNegativeResult.verify(called: .never))
```

### Call Args
You can get arguments of any call from history using `args() -> TArgs?` or `args(callTime: Int) -> TArgs?` functions. It returns *an array of arguments* for this call or *nil* if no call with given *callTime* was registered. 

So the best pratice is to use guard and XCTFail around `argsOf()` if you expect this args to exist.
```swift
// then
guard let args = calculator.mock_sum.args() else { XCTFail(); return }
XCTAssert(args.left == 5)
XCTAssert(args.right == 10)
```

## Migration Guide
In order to migrate a project from the first version of Mirage framework to the second one, the framework has been renamed as `Mirage2`. It allows to use both the first and the second versions in the same project and to migrate file by file.

Migration from *Mirage 1* to *Mirage 2* consists of several steps.

1. Rewrite mocks

It is very easy to migrate mocks with new version of [Fata Morgana](https://github.com/valnoc/FataMorgana)

2. Use find&replace feature to change `Once()` to `.once`, etc

3. Use find&replace feature along with regexps to change `verify` to `when` calls
I'll give regexps here later

4. Remove args casts after `args()` calls

## License
Mirage is available under MIT License.
