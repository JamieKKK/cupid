# 这是一个最基本的Podfile
# 不指定任何目标或项目

# CocoaPods官方源
source 'https://github.com/CocoaPods/Specs.git'

# 指定平台和版本
platform :ios, '15.0'

# 创建一个独立的工作区，不需要Xcode项目
workspace 'Cupid'

# 使用标准目标名称'Cupid'，这应该与您的Xcode项目中的目标名称匹配
target 'Cupid' do
  use_frameworks!

  # 网络与图片加载
  pod 'Kingfisher', '~> 7.0'
  pod 'Alamofire', '~> 5.6'
  
  # UI组件
  pod 'SnapKit', '~> 5.6'
  pod 'IQKeyboardManagerSwift', '~> 6.5'
  pod 'lottie-ios', '~> 4.1'
  
  # 工具库
  pod 'KeychainSwift', '~> 20.0'
  pod 'SwiftyJSON', '~> 5.0'
  pod 'RealmSwift', '~> 10.33'
  
  # Firebase相关
  pod 'Firebase/Auth'
  pod 'Firebase/Messaging'
  pod 'Firebase/Analytics'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '15.0'
    end
  end
end 