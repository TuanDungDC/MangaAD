# Uncomment the next line to define a global platform for your project
platform :ios, '13.0'

target 'MangaAD' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  
  # Pods for MangaAD
  
  target 'MangaADTests' do
    inherit! :search_paths
    # Pods for testing
  end
  
  target 'MangaADUITests' do
    # Pods for testing
  end
  pod 'Firebase/Auth'
  pod 'Firebase/Database'
  pod 'Firebase/Storage'
  pod 'FirebaseDynamicLinks'
  pod 'SDWebImage'
  pod 'Cosmos'
  pod 'JGProgressHUD'
  
  post_install do |installer|
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
      end
    end
  end
  
end
