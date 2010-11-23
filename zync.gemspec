# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "zync/version"

require File.expand_path('../lib/zync/version', __FILE__)

Gem::Specification.new do |s|
  s.name        = 'zync'
  s.version     = Zync::VERSION
  s.platform    = Gem::Platform::RUBY
  s.summary     = "Lightweight asynchronous Ruby web framework"
  s.description = "Lightweight asynchronous Ruby web framework"

  s.authors     = ["Peter Kieltyka"]
  s.email       = ["peter@nulayer.com"]
  s.homepage    = "http://github.com/nulayer/zync"

  s.files        = Dir['README', 'VERSION', 'lib/**/*']
  s.require_path = 'lib'

  s.add_dependency("eventmachine", ["~> 0.12.10"])
  s.add_dependency("rack", ["~> 1.2.1"])
  s.add_dependency("activesupport", ["~> 3.0.0"])

  s.add_development_dependency("rspec", ["~> 2.1.0"])
end
