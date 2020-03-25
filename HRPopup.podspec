#
# Be sure to run `pod lib lint HRPopup.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
    s.name             = 'HRPopup'
    s.version          = '0.3.3'
    s.summary          = '包含弹窗优先级、指定弹窗指定页面显示等功能的封装'

  # This description is used to generate tags and improve search results.
  #   * Think: What does it do? Why did you write it? What is the focus?
  #   * Try to keep it short, snappy and to the point.
  #   * Write the description between the DESC delimiters below.
  #   * Finally, don't worry about the indent, CocoaPods strips it!

    s.description      = <<-DESC
    包含弹窗优先级、指定弹窗指定页面显示等功能的封装,UI完全由自己返回。
                         DESC

    s.homepage         = 'https://github.com/HRongChen/HRPopupTool'
    s.license          = { :type => 'MIT', :file => 'LICENSE' }
    s.author           = { 'HRChen' => 'gavin.chen.hr@gmail.com' }
    s.source           = { :git => 'https://github.com/HRongChen/HRPopupTool.git', :tag => s.version.to_s }

    s.ios.deployment_target = '8.0'

    s.source_files = 'HRPopup/Classes/**/*.{h,m}'
    s.frameworks = 'UIKit', 'Foundation'
end
