
Pod::Spec.new do |s|

  # 1
  s.platform = :ios
  s.ios.deployment_target = '8.0'
  s.name = "EuroLeagueKit"
  s.summary = "EuroLeagueKit for services and database."
  s.requires_arc = true

  # 2
  s.version = "0.1.0"

  # 3
  s.license = { :type => "MIT", :file => "LICENSE" }

  # 4 - Replace with your name and e-mail address
  s.author = { "Mohamed Elsayed" => "mohamed.compu2018@hotmail.com" }

# 5 - Replace this URL with your own Github page's URL (from the address bar)
  s.homepage = "https://github.com/Modeso/GraduateProject.git"



  # 6 - Replace this URL with your own Git URL from "Quick Setup"
  s.source = { :git => "https://github.com/Modeso/GraduateProject.git", :tag => "#{s.version}"}

  # 7
  s.framework = "UIKit"
  s.dependency 'Alamofire', '~> 4.4'
  s.dependency 'SWXMLHash', '~> 4.0.0'
  s.dependency 'RealmSwift'

  # 8
  s.source_files = "EuroLeagueKit/**/*.{swift}"

end