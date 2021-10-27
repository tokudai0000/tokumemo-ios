# Uncomment the next line to define a global platform for your project
 platform :ios, '13.0'

target 'univIP' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for univIP
  pod 'R.swift' , '~> 5.4'
  pod 'KeychainAccess' , '~> 4.2'
#  pod 'mailcore2-ios' , '~> 0.6'
  pod 'Kanna' , '~> 5.2'
  pod 'Firebase/Analytics' , '~> 8.8'
  
  post_install do |installer|
    installer.pods_project.build_configurations.each do |config|
      config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"
    end
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '9.0'
      end
    end
  end
end
