#
#  Be sure to run `pod spec lint PoyntLib.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|
  s.name         = "PoyntLib"
  s.version      = "1.0.0"
  s.summary      = "PoyntLib sdk for Poynt Smart terminal"
  s.homepage     = "https://github.com/poynt/pos-connector-ios-sdk-sample"
  s.license      = "MIT"
  s.author             = { "Eric McConkie" => "eric@poynt.com" }

  s.platform     = :ios
  s.source       = { :path => 'lib-universal' }
  s.public_header_files = 'lib-universal/include/PoyntLib/**/*.h'
  s.vendored_libraries    = 'lib-universal/libPoyntLib.a'
  s.preserve_paths        = 'lib-universal/libPoyntLib.a', 'lib-universal/include/PoyntLib/**/*.h'
  s.dependency "OpenSSL-Universal",'~>1.0.1.20'

end
