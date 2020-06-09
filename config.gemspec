$:.push File.expand_path('../lib', __FILE__)

require 'config/version'

Gem::Specification.new do |s|
  s.name             = 'config'
  s.version          = Config::VERSION
  s.date             = Time.now.strftime '%F'
  s.authors          = ['Piotr Kuczynski', 'Fred Wu', 'Jacques Crocker']
  s.email            = %w[piotr.kuczynski@gmail.com ifredwu@gmail.com railsjedi@gmail.com]
  s.summary          = 'Effortless multi-environment settings in Rails, Sinatra, Pandrino and others'
  s.description      = 'Easiest way to manage multi-environment settings in any ruby project or framework: ' +
                       'Rails, Sinatra, Pandrino and others'
  s.homepage         = 'https://github.com/rubyconfig/config'
  s.license          = 'MIT'
  s.extra_rdoc_files = %w[README.md CHANGELOG.md CONTRIBUTING.md LICENSE.md]
  s.rdoc_options     = ['--charset=UTF-8']
  s.post_install_message = "\n\e[33mThanks for installing Config\e[0m
Please consider donating to our open collective to help us maintain this project.
\n
Donate: \e[34mhttps://opencollective.com/rubyconfig/donate\e[0m\n"

  s.files = `git ls-files`.split($/)
  s.files.select! { |file| /(^lib\/|^\w+.md$|\.gemspec$)/ =~ file }

  s.require_paths         = ['lib']
  s.required_ruby_version = '>= 2.4.0'

  s.add_dependency 'deep_merge', '~> 1.2', '>= 1.2.1'
  s.add_dependency 'dry-validation', '~> 1.0', '>= 1.0.0'

  s.add_development_dependency 'rake', '~> 12.0', '>= 12.0.0'

  # Testing
  s.add_development_dependency 'appraisal', '~> 2.3', '>= 2.3.0'
  s.add_development_dependency 'rspec', '~> 3.9', '>= 3.9.0'

  # Default RSpec run will test against latest Rails app
  unless ENV['APPRAISAL_INITIALIZED'] || ENV['GITHUB_ACTIONS']
    gems_to_install = /gem "(.*?)", "(.*?)"(?!, platform: (?!\[:ruby\]))/
    File.read(Dir['gemfiles/rails*.gemfile'].sort.last).scan(gems_to_install) do |name, version|
      s.add_development_dependency name, version
    end
  end

  if ENV['GITHUB_ACTIONS']
    # Code coverage is needed only in CI
    s.add_development_dependency 'simplecov', '~> 0.18.5' if RUBY_ENGINE == 'ruby'
  else
    # Static code analysis to be used locally
    s.add_development_dependency 'mdl', '~> 0.9', '>= 0.9.0'
    s.add_development_dependency 'rubocop', '~> 0.85.0'
  end
end
