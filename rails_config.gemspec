$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require 'rails_config/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name             = "rails_config"
  s.version          = RailsConfig::VERSION
  s.date             = Time.now.strftime '%F'
  s.authors          = ["Jacques Crocker", "Fred Wu", "Piotr Kuczynski"]
  s.email            = ["railsjedi@gmail.com", "ifredwu@gmail.com", "piotr.kuczynski@gmail.com"]
  s.summary          = "Please install the Config gem instead."
  s.description      = "Please install the Config gem instead."
  s.homepage         = "https://github.com/railsconfig/rails_config"
  s.license          = "MIT"
  s.extra_rdoc_files = ["README.md"]
  s.rdoc_options     = ["--charset=UTF-8"]

  s.files            = `git ls-files`.split($/)

  s.executables      = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.test_files       = s.files.grep(%r{^(test|spec|features)/})
  s.require_paths    = ["lib"]

  s.add_dependency "config", ">= 1.0.0.beta1"
end
