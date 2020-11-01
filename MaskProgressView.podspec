#
#  Created by teambition-ios on 2020/7/27.
#  Copyright © 2020 teambition. All rights reserved.
#     

Pod::Spec.new do |s|
  s.name             = 'MaskProgressView'
  s.version          = '0.0.7'
  s.summary          = 'MaskProgressView is a custom progress view which can be masked with an image containing an alpha channel.'
  s.description      = <<-DESC
  MaskProgressView is a custom progress view which can be masked with an image containing an alpha channel.
                       DESC

  s.homepage         = 'https://github.com/teambition/MaskProgressView'
  s.license          = { :type => 'MIT', :file => 'LICENSE.md' }
  s.author           = { 'teambition mobile' => 'teambition-mobile@alibaba-inc.com' }
  s.source           = { :git => 'https://github.com/teambition/MaskProgressView.git', :tag => s.version.to_s }

  s.swift_version = '5.0'
  s.ios.deployment_target = '8.0'

  s.source_files = 'MaskProgressView/*.swift'

end
