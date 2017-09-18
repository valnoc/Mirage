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

### Cocoapods
Add this line into your Podfile under a test target and run `pod update`
```
pod 'Mirage'
```

#### Podfile example
```
target 'MainTarget' do
  ...
  target 'TestTarget' do
    inherit! :search_paths
    pod 'Mirage'
  end
end
```
### Source files
Copy /Mirage folder into your test target.

---
## Usage
First of all - check Example project.
### Mocks

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
