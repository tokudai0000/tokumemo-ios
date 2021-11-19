# Uncomment the next line to define a global platform for your project
platform :ios, '13.0'

target 'univIP' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for univIP
  pod 'R.swift' , '~> 5'
  pod 'KeychainAccess' , '~> 4'
  pod 'Kanna' , '~> 5'
  pod 'Firebase/Analytics' , '~> 8'
  
end


post_install do | installer |
  require 'fileutils'

  FileUtils.cp_r('Pods/Target Support Files/Pods-univIP/Pods-univIP-Acknowledgements.plist', 'univIP/Settings.bundle/Acknowledgements.plist', :remove_destination => true)

end
