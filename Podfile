# Uncomment the next line to define a global platform for your project
 platform :ios, '14.0'

target 'WeatherDemoApp' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  source 'https://github.com/CocoaPods/Specs.git'

  # Pods for WeatherDemoApp

  pod 'Alamofire', '~> 5.6.2'
  pod 'SwiftLint'
  pod 'RealmSwift', '~>10'
  pod 'SVProgressHUD'
  pod 'ReachabilitySwift'
  pod 'SDWebImage', '~> 5.0'

  target 'WeatherDemoAppTests' do
    inherit! :search_paths
    # Pods for testing

  end

  target 'WeatherDemoAppUITests' do
    # Pods for testing
  end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '14.0'
      config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"
      config.build_settings["ONLY_ACTIVE_ARCH"] = "NO"
    end
  end
end

end
