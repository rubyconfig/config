require_relative 'lib/config/version'
require_relative 'lib/config/dry_validation_requirements'

Gem::Specification.new do |s|
  s.name             = 'config'
  s.version          = Config::VERSION
  s.date             = Time.now.strftime '%F'
  s.authors          = ['Piotr Kuczynski', 'Fred Wu', 'Jacques Crocker']
  s.email            = %w[piotr.kuczynski@gmail.com ifredwu@gmail.com railsjedi@gmail.com]
  s.summary          = 'Effortless multi-environment settings in Rails, Sinatra, Padrino and others'
  s.description      = 'Easiest way to manage multi-environment settings in any ruby project or framework: ' +
                       'Rails, Sinatra, Padrino and others'
  s.homepage         = 'https://github.com/rubyconfig/config'
  s.license          = 'MIT'
  s.extra_rdoc_files = %w[README.md CHANGELOG.md CONTRIBUTING.md LICENSE.md]
  s.rdoc_options     = ['--charset=UTF-8']

  s.metadata = {
    'changelog_uri' => "https://github.com/rubyconfig/config/blob/master/CHANGELOG.md",
    'funding_uri' => 'https://opencollective.com/rubyconfig/donate',
    'source_code_uri' => 'https://github.com/rubyconfig/config',
    'bug_tracker_uri' => 'https://github.com/rubyconfig/config/issues'
  }
  s.files = `git ls-files`.split($/)
  s.files.select! { |file| /(^lib\/|^\w+.md$|\.gemspec$)/ =~ file }

  s.require_paths         = ['lib']
  s.required_ruby_version = '>= 2.6.0'

  s.add_dependency 'deep_merge', '~> 1.2', '>= 1.2.1'

  s.add_development_dependency 'dry-validation', *Config::DryValidationRequirements::VERSIONS
  s.add_development_dependency 'rake', '~> 12.0', '>= 12.0.0'

  # Testing
  s.add_development_dependency 'appraisal', '~> 2.5', '>= 2.5.0'
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
