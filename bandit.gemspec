$:.push File.expand_path("../lib", __FILE__)
require "bandit/version"

Gem::Specification.new do |s|
  s.name        = "bandit"
  s.version     = Bandit::VERSION
  s.authors     = ["Brian Muller"]
  s.email       = ["bamuller@gmail.com"]
  s.homepage    = "https://github.com/bmuller/bandit"
  s.summary     = "Multi-armed bandit testing in rails"
  s.description = "Bandit provides a way to do multi-armed bandit optimization of alternatives in a rails website"

  s.rubyforge_project = "bandit"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  s.add_dependency("rails", ">= 3.1.0")
  s.requirements << "Either redis or memcache gem"
  s.add_development_dependency('rdoc')
end
