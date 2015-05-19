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
  s.summary          = "Provides a Settings helper for Rails that reads from config/settings.yml"
  s.description      = "Easy to use Settings helper that loads its data in from config/settings.yml. Handles adding multiple sources, and easy reloading."
  s.homepage         = "http://github.com/railsjedi/rails_config"
  s.license          = "MIT"
  s.extra_rdoc_files = ["README.md"]
  s.rdoc_options     = ["--charset=UTF-8"]

  s.files            = `git ls-files`.split($/)

  s.executables      = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.test_files       = s.files.grep(%r{^(test|spec|features)/})
  s.require_paths    = ["lib"]

  s.add_dependency "activesupport", ">= 3.0"

  s.add_development_dependency "bundler",     "~> 1.5"
  s.add_development_dependency "rake"
  s.add_development_dependency "rdoc",        "~> 3.4"
  s.add_development_dependency "pry"

  # Testing
  s.add_development_dependency "appraisal",   "~> 2.0.1"
  s.add_development_dependency "rails",       "~> 3.2.21"
  s.add_development_dependency "rspec-rails", "~> 3.2.1"
  s.add_development_dependency "sqlite3"
  s.add_development_dependency "rubocop",     "~> 0.31.0"

  if ENV['RUBY_VERSION'] >= 'ruby-2.2'
    s.add_development_dependency "test-unit",   "~> 3.0"
  end

  if ENV['TRAVIS']
    s.add_development_dependency "codeclimate-test-reporter"
  end
end
