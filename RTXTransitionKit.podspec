Pod::Spec.new do |s|
  s.name         = 'RTXTransitionKit'
  s.summary      = 'Implement the independent navigation bar and transition animation effects like TouTiao'
  s.version      = '1.0'
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.authors      = { 'menttofly' => '1028365614@qq.com' }
  s.homepage     = 'https://github.com/menttofly/RTXTransitionKit'
  s.platform     = :ios, '8.0'
  s.ios.deployment_target = '8.0'
  s.source       = { :git => 'https://github.com/menttofly/RTXTransitionKit.git', :tag => s.version.to_s }

  s.requires_arc = true
  s.source_files = 'RTXTransitionKit/*.{h,m}'
  s.public_header_files = 'RTXTransitionKit/*.{h}'

end
