@version = "0.1.0"

#
# Be sure to run `pod lib lint VizFig.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "VizFig"
  s.version          = "0.1.0"
  s.summary          = "Define your app's style in code, apply the style in Interface Buillder."
  s.description      = <<-DESC
                       When building an app, it's often useful to define elements of style in the code, including things like fonts, colors, and branding strings.  Having a object that encapsulates this configurations helps insure that you Don't Repeat Yourself.  On the downside, you write blocks of code over and over that do nothing but apply styling to interface elements.  This is simple boilerplate code that creates more opportunity for error and obscures the real intent of your code.  VizFig solves this problem by exposing your styling information inside of Interface Builder so you can apply style elements visually.  In the end, you can style your app faster, with less code and still maintain the agility of a single style definition.'
                       DESC
  s.homepage         = "https://github.com/oakcitylabs/VizFig"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "Jay Lyerly" => "jay@oakcity.io" }
  s.source           = { :git => "https://github.com/oakcitylabs/VizFig.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/oakcitylabs'

    #s.platform     = :ios, '8.0'
  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = '10.9'

  s.platforms             = { :ios => '8.0', :osx => '10.10' }

  s.requires_arc = true

#s.source_files = 'Pod/Classes/**/*'
  s.source_files = 'Pod/Classes/**/*.swift'
  s.preserve_path = 'Pod/Scripts/**/*.py'
#s.resource_bundles = {
#    'VizFig' => ['Pod/Assets/*.png']
#  }
  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
