#
# Be sure to run `pod lib lint Keystore.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'Keystore'
  s.version          = '0.1.2'
  s.summary          = 'Keystore persists passwords into keychain'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  Test pod for for handling passwords in keychain
  DESC

  s.homepage         = 'https://github.com/ChristianRonningen'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Christian Rönningen' => '' }
  s.source           = { :git => 'https://github.com/ChristianRonningen/Keystore.git', :tag => s.version.to_s }

  s.ios.deployment_target = '9.3'

  s.source_files = 'Keystore/Classes/**/*'
  
  # s.resource_bundles = {
  #   'Keystore' => ['Keystore/Assets/*.png']
  # }

   s.test_spec 'Tests' do |test_spec|
      test_spec.source_files = 'Tests/*.swift'
   end

   s.frameworks = 'UIKit', 'MapKit'
   s.dependency = 'CryptoSwift'
end
