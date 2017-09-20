#
# Be sure to run `pod lib lint MyLib.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "Mirage"
  s.version          = "0.3.0"
  s.summary          = "Mirage is a lightweight mocking framework for swift projects."
  s.description      = <<-DESC
Mirage is a lightweight mocking framework for swift projects.
                       DESC
  s.homepage         = "https://github.com/valnoc/Mirage"

  s.license          = 'MIT'
  s.author           = { "Valeriy Bezuglyy" => "valnocorner@gmail.com" }
  s.source           = { :git => "https://github.com/valnoc/Mirage.git", :tag => "v#{s.version}" }

  s.platform     = :ios, '9.0'
  s.requires_arc = true

  s.source_files = 'Mirage/**/*{.swift}'

end
