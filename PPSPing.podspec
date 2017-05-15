Pod::Spec.new do |s|
s.name             = 'PPSPing'
s.version          = '0.1.0'
s.summary          = 'A tools for test network quality'

s.description      = <<-DESC
A lightweight lightweight tool for testing network quality, easy integration and easy to use.
DESC

s.homepage         = 'https://github.com/yangqian111/PPSPing'

s.license          = { :type => 'MIT', :file => 'LICENSE' }

s.author           = { 'ppsheep' => 'ppsheep.qian@gmail.com' }

s.source           = { :git => 'https://github.com/yangqian111/PPSPing.git', :tag => s.version.to_s }

s.ios.deployment_target = '8.0'

s.source_files = 'PPSPing/Classes/**/*'

# s.resource_bundles = {
#   'PPSPing' => ['PPSPing/Assets/*.png']
# }

# s.public_header_files = 'Pod/Classes/**/*.h'
# s.frameworks = 'UIKit', 'MapKit'
# s.dependency 'AFNetworking', '~> 2.3'
end
