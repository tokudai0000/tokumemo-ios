# Uncomment the next line to define a global platform for your project
platform :ios, '14.0'

target 'univIP' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  inhibit_all_warnings!
  
  # Pods for univIP
  pod 'R.swift' , '~> 5'
  pod 'KeychainAccess' , '~> 4'
  pod 'Kanna' , '~> 5'
  pod 'Gecco', '~> 2'
  pod 'Firebase/Analytics' , '~> 8'
  pod 'ZXingObjC', '~> 3.6.4'
  pod 'Alamofire', '~> 4'
  pod 'SwiftyJSON', '~> 5'
    
  target  'univIPTests' do
    inherit! :search_paths
    pod 'Firebase'
  end

end


post_install do | installer |
  require 'fileutils'
  # 謝辞
  FileUtils.cp_r('Pods/Target Support Files/Pods-univIP/Pods-univIP-Acknowledgements.plist', 'univIP/Settings.bundle/Acknowledgements.plist', :remove_destination => true)
  
  # 更新が行われていないOSSのWarningを無くす
  # 以下そのWarning
  # The iOS Simulator deployment target 'IPHONEOS_DEPLOYMENT_TARGET' is set to 8.0, but the range of supported deployment target versions is 9.0 to 15.0.99.
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '9.0'
    end
  end  
end
