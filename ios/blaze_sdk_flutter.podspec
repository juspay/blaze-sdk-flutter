#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint blaze_sdk_flutter.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'blaze_sdk_flutter'
  s.version          = '0.0.1'
  s.summary          = 'Blaze SDK Flutter'
  s.description      = <<-DESC
                       integrate Breeze 1CCO and its services seamlessly
                       DESC
  s.homepage         = 'https://breeze.in'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Sahil Sinha' => 'sahilsinha.dar@gmail.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.dependency 'BlazeSDK', '0.5.0'
  s.platform = :ios, '12.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'

  # If your plugin requires a privacy manifest, for example if it uses any
  # required reason APIs, update the PrivacyInfo.xcprivacy file to describe your
  # plugin's privacy impact, and then uncomment this line. For more information,
  # see https://developer.apple.com/documentation/bundleresources/privacy_manifest_files
  # s.resource_bundles = {'blaze_sdk_flutter_privacy' => ['Resources/PrivacyInfo.xcprivacy']}
end
