source 'https://github.com/CocoaPods/Specs.git'

use_frameworks!

platform :ios, '10.0'

def shared_pods
  pod 'SnapKit'
  pod 'Hex'
end

target 'SongShare' do
  shared_pods
end

target 'SongShareTests' do
  shared_pods
end

target 'SongShareUITests' do
  shared_pods
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '3.0'
    end
  end
end
