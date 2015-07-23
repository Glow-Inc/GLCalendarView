
Pod::Spec.new do |s|
  s.name         = "GLCalendarView"
  s.version      = "1.1.0"
  s.summary      = "Fully customizable date range picker"
  s.homepage     = "https://github.com/Glow-Inc/GLCalendarView"
  s.license      = "MIT"
  s.author       = { "leo" => "leo@glowing.com" }
  s.source       = { :git => "https://github.com/Glow-Inc/GLCalendarView.git", :tag => 'v1.1.0'}
  s.source_files = "GLCalendarView/Sources/**/*.{h,m}"
  s.resources = [
    "GLCalendarView/Sources/**/*.{png}",
    "GLCalendarView/Sources/**/*.{storyboard,xib}",
  ]
  s.requires_arc = true
  s.platform     = :ios, '7.0'

end
