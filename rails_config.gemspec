Gem::Specification.new do |s|
  s.name = "rails_config"
  s.version = "0.1.8"

  s.authors = ["Jacques Crocker", "Fred Wu"]
  s.summary = "Provides a Settings helper for rails3 that reads from config/settings.yml"
  s.description = "Easy to use Settings helper that loads its data in from config/settings.yml. Handles adding multiple sources, and easy reloading."
  s.email = ["railsjedi@gmail.com", "ifredwu@gmail.com"]
  s.homepage = "http://github.com/railsjedi/rails_config"

  s.require_paths = ["lib"]
  s.files = Dir['lib/**/*',
                'spec/**/*',
                'rails_config.gemspec',
                'Gemfile',
                'Gemfile.lock',
                'LICENSE',
                'Rakefile',
                'README.md',
                'TODO']

  s.test_files = Dir['spec/**/*']
  s.rdoc_options = ["--charset=UTF-8"]
  s.extra_rdoc_files = [
    "LICENSE",
     "README.md",
     "TODO"
  ]

  s.add_runtime_dependency "activesupport", "~> 3.0"
  s.add_development_dependency "rspec", "~> 2.0"

end

