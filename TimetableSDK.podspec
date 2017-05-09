Pod::Spec.new do |s|

  s.name         = "TimetableSDK"
  s.version      = "3.1.2"
  s.summary      = "Simple SDK for timetable.spbu.ru that works on macOS, iOS and watchOS"

  s.description  = <<-DESC
                   Simple SDK for macOS, iOS and watchOS that allows you to get the data
                   you need from timetable.spbu.ru.
                   DESC

  s.homepage     = "https://github.com/WeirdMath/TimetableSDK"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "Sergej Jaskiewicz" => "jaskiewiczs@icloud.com" }
  s.social_media_url   = "http://twitter.com/broadway_lamb"

  s.ios.deployment_target = "8.0"
  s.osx.deployment_target = "10.10"
  s.watchos.deployment_target = "2.0"
  s.tvos.deployment_target = "9.0"

  s.source = { :git => 'https://github.com/WeirdMath/TimetableSDK.git', :tag => s.version.to_s }

  s.source_files  = "Sources/**/*.swift"

  s.dependency "SwiftyJSON", "~> 3.0"
  s.dependency "PromiseKit", "~> 4.0"
end
