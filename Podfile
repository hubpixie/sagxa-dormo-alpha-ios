# Uncomment the next line to define a global platform for your project
platform :ios, '10.0'


def commonPods
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for a target
  pod 'R.swift'
  pod 'SwaggerClient', :path => 'SwaggerClient/'

end

target 'SagxaDormo' do
  commonPods
end

=begin
target 'SagxaDormo staging' do
  commonPods
  target 'SagxaDormoTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'SagxaDormoUITests' do
    inherit! :search_paths
    # Pods for testing
  end
end
=end

post_install do |installer|
  installer.pods_project.build_configurations.each do |config|
    config.build_settings.delete('CODE_SIGNING_ALLOWED')
    config.build_settings.delete('CODE_SIGNING_REQUIRED')
  end
end


