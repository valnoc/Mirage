Pod::Spec.new do |s|
  s.name             = "Mirage"
  s.version          = "2.0.0"
  s.summary          = "Mirage is a mocking library for swift projects. The recommended way is to use github.com/valnoc/FataMorgana for Mirage mocks generation."
  s.description      = <<-DESC
Mirage is a mocking library for swift projects. The recommended way is to use https://github.com/valnoc/FataMorgana for Mirage mocks generation to avoid writing them manually.
Features.
Using Mirage you can:
- create mocks, stubs, partial mocks
- verify func call times
- get call arguments history
                       DESC

  s.homepage         = "https://github.com/valnoc/Mirage"

  s.license          = 'MIT'
  s.author           = { "Valeriy Bezuglyy" => "valnocorner@gmail.com" }
  s.source           = { :git => "https://github.com/valnoc/Mirage.git", :tag => "#{s.version}" }

  s.swift_version = '5.0'
  s.platform     = :ios, '9.0'
  s.requires_arc = true

  s.source_files = 'Source/Mirage/**/*{.swift}'

end
