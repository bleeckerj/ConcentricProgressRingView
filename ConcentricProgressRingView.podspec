Pod::Spec.new do |s|
  s.name             = 'ConcentricProgressRingView'
  s.version          =  "1.3.3"
  s.summary          = 'Fully customizable circular progress bar written in Swift'
  s.homepage         = 'https://github.com/bleeckerj/ConcentricProgressRingView'
  s.license          = { :type => 'Apache 2.0', :file => 'LICENSE' }
  s.author           = { 'Dan Loewenherz' => 'dan@lionheartsw.com' }
  s.source           = { :git => 'https://github.com/bleeckerj/ConcentricProgressRingView.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/lionheart'

  s.ios.deployment_target = '8.4'

  s.source_files = 'ConcentricProgressRingView/Classes/**/*'
end
