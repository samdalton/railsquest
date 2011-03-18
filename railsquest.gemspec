# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "railsquest/version"

Gem::Specification.new do |s|
  s.name        = "railsquest"
  s.version     = Railsquest::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["RailsQuest"]
  s.email       = ["hello@railsquest"]
  s.homepage    = ""
  s.summary     = %q{It's awesome}
  s.description = %q{more awesomeness}

  s.rubyforge_project = "railsquest"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
