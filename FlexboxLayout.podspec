Pod::Spec.new do |s|
  s.name = 'FlexboxLayout'
  s.version = '0.1'
  s.license = 'MIT'
  s.summary = 'Elegant iOS Forms in pure Swift'
  s.homepage = 'https://github.com/jalopezsuarez/FlexboxLayout'
  s.social_media_url = 'https://twitter.com/alexdrone'  
  s.authors = { 'Alex Usbergo' => 'alexakadrone@gmail.com' }
  s.source = { :git => 'https://github.com/jalopezsuarez/FlexboxLayout.git', :tag => s.version }
  s.ios.deployment_target = '8.0'
  s.ios.frameworks = 'UIKit', 'Foundation'
  s.source_files = 'Source/*'
  s.requires_arc = true
end