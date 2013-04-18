require File.dirname(__FILE__) + "/lib/rails_config/version"

Gem::Specification.new do |s|
  s.name             = "rails_config"
  s.version          = RailsConfig::VERSION
  s.date             = Time.now.strftime '%F'
  s.authors          = ["Jacques Crocker", "Fred Wu"]
  s.email            = ["railsjedi@gmail.com", "ifredwu@gmail.com"]
  s.summary          = "Provides a Settings helper for rails3 that reads from config/settings.yml"
  s.description      = "Easy to use Settings helper that loads its data in from config/settings.yml. Handles adding multiple sources, and easy reloading."
  s.homepage         = "http://github.com/railsjedi/rails_config"
  s.extra_rdoc_files = ["README.md"]
  s.rdoc_options     = ["--charset=UTF-8"]
  s.require_paths    = ["lib"]
  s.files            = `git ls-files`.split("\n")
  s.test_files       = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables      = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }

  s.add_dependency "activesupport", ">= 3.0"
  s.add_development_dependency "rake"
  s.add_development_dependency "rdoc"
  s.add_development_dependency "pry"
  s.add_development_dependency "rspec", "~> 2.0"
end
