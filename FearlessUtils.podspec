#
# Be sure to run `pod lib lint FearlessUtils.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'FearlessUtils'
  s.version          = '0.14.0'
  s.summary          = 'Utility library that implements clients specific logic to interact with substrate based networks'

  s.homepage         = 'https://github.com/soramitsu/fearless-utils-iOS'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Soramitsu' => 'admin@soramitsu.co.jp' }
  s.source           = { :git => 'https://github.com/soramitsu/fearless-utils-iOS.git', :tag => s.version.to_s }
  s.swift_version    = '5.0'

  s.ios.deployment_target = '11.0'

  s.pod_target_xcconfig = { 'VALID_ARCHS' => 'x86_64 armv7 arm64'  }

  s.source_files = 'FearlessUtils/Classes/**/*'
  s.dependency 'IrohaCrypto/sr25519'
  s.dependency 'IrohaCrypto/ed25519'
  s.dependency 'IrohaCrypto/secp256k1'
  s.dependency 'IrohaCrypto/Scrypt'
  s.dependency 'IrohaCrypto/ss58'
  s.dependency 'ReachabilitySwift', '~> 5.0'
  s.dependency 'RobinHood', '~> 2.6.1'
  s.dependency 'Starscream'
  s.dependency 'TweetNacl', '~> 1.0.0'
  s.dependency 'BigInt', '~> 5.0'
  s.dependency 'xxHash-Swift', '~> 1.0.0'
  
  s.test_spec do |ts|
      ts.source_files = 'Tests/**/*.swift'
      ts.resources = ['Tests/**/*.json', 'Tests/**/*-metadata']
  end
end
