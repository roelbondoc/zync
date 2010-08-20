version = File.read("VERSION").strip

Gem::Specification.new do |s|
  s.name        = 'zync'
  s.version     = version
  s.platform    = Gem::Platform::RUBY
  s.summary     = "Lightweight asynchronous Ruby web framework"
  s.description = "Lightweight asynchronous Ruby web framework"
  
  s.authors     = ["Peter Kieltyka"]
  s.email       = ["peter@nulayer.com"]
  s.homepage    = "http://github.com/nulayer/zync"

  s.files        = Dir['README', 'VERSION', 'lib/**/*']
  s.require_path = 'lib'
  
  s.add_dependency("eventmachine", [">= 0.12.10"])
  s.add_dependency("rack", [">= 1.2.1"])
  s.add_dependency("activesupport", [">= 3.0.0.rc"])
  
  s.add_development_dependency("rspec", ["= 2.0.0.beta.19"])
end
