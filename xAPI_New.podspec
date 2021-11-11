#
# Be sure to run `pod lib lint xAPI_New.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'xAPI_New'
  s.version          = '1.0.5'
  s.summary          = 'A short description of xAPI_New.'
  s.swift_version    = '5'      # Swift版本号

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/kaibuleite/xAPI_New'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'kaibuleite' => '177955297@qq.com' }
  s.source           = { :git => 'https://github.com/kaibuleite/xAPI_New.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'

  s.source_files = 'xAPI_New/Classes/**/*'
  
  # s.resource_bundles = {
  #   'xAPI_New' => ['xAPI_New/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'

  s.dependency 'Alamofire' #最新版仅支持 iOS10 以上系统
  s.dependency 'xExtension'
  
end
