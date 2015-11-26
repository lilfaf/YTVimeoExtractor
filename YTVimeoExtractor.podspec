Pod::Spec.new do |s|
  s.name         = "YTVimeoExtractor"
  s.version      = "0.3.0"
  s.summary      = "Fetches Vimeo's mp4 URLs for iOS."
  s.description  = <<-DESC
                    YTVimeoExtractor is a class which lets you get the iOS
                    compatible video url from Vimeo which you can use in
                    MPMoviePlayerController, no need to use a UIWebView.
                    DESC
  s.homepage     = "https://github.com/lilfaf/YTVimeoExtractor"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { "Louis Larpin" => "louis.larpin@gmail.com" }
  s.source       = { :git => "https://github.com/lilfaf/YTVimeoExtractor.git", :tag => "0.3.0" }

  s.ios.deployment_target = '7.0'
  s.osx.deployment_target = '10.9'
  s.tvos.deployment_target = '9.0'
  s.source_files = 'YTVimeoExtractor/*.{h,m}'
  s.requires_arc = true
end
