#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint flutter_tencentad.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'flutter_tencentad'
  s.version          = '0.0.1'
  s.summary          = 'A new Flutter project.'
  s.description      = <<-DESC
A new Flutter project.
                       DESC
  s.homepage         = 'https://github.com/gstory0404/flutter_tencentad'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'gstory' => 'gstory0404@gmail.com' }
  s.source           = { :path => '.' }
  s.public_header_files = 'Classes/**/*.h'
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '9.0'
 # s.dependency 'GDTMobSDK','~> 4.13.02'
  s.vendored_frameworks = 'gdtsdk/MySDK.framework'
  
  s.static_framework = true

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386'}
  s.swift_version = '5.0'
end
