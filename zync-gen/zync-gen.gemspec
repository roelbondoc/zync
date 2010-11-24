# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "zync-gen/version"

Gem::Specification.new do |s|
  s.name        = "zync-gen"
  s.version     = Zync::Generators::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Kevin Faustino"]
  s.email       = ["kevin.faustino@nulayer.com"]
  s.homepage    = ""
  s.summary     = %q{Generators for Zync}
  s.description = %q{A Collection of generators for the Zync Web Framework}

  s.rubyforge_project = "zync-gen"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  
  s.add_dependency("thor", ["~> 0.14.6"])
  s.add_dependency("activesupport", ["~> 3.0.3"])

  s.add_development_dependency("rspec", ["~> 2.1.0"])
end
