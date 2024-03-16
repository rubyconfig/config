ENV['RAILS_ENV'] ||= 'test'

puts "RUBY_ENGINE: #{RUBY_ENGINE}"
puts "RUBY_VERSION: #{RUBY_VERSION}\n\n"

##
# Code Climate
#
if ENV['GITHUB_ACTIONS'] && RUBY_ENGINE == 'ruby' && RUBY_VERSION.start_with?(ENV['COVERAGE_RUBY_VERSION'] || 'x')
  require 'simplecov'
  SimpleCov.start
end

##
# Load Rspec supporting files
#
Dir['./spec/support/**/*.rb'].sort.each { |f| require f }

##
# Detect Rails/Sinatra dummy application based on gemfile name substituted by Appraisal
#
if ENV['APPRAISAL_INITIALIZED'] || ENV['GITHUB_ACTIONS']
  app_name = File.basename(ENV['BUNDLE_GEMFILE'], '.gemfile')
else
  /.*?(?<app_name>rails.*?)\.gemfile/ =~ Dir["gemfiles/rails*.gemfile"].sort.last
end

##
# Load dummy application and Rspec
#
app_framework = %w{rails sinatra}.find { |f| app_name.to_s.include?(f) }

case app_framework
when 'rails'
  # Load Rails
  require_relative "app/#{app_name}/config/environment"

  APP_RAKEFILE = File.expand_path("../app/#{app_name}/Rakefile", __FILE__)

  # Load Rspec
  require 'rspec/rails'

  # Configure
  RSpec.configure do |config|
    config.fixture_path = FixtureHelper::FIXTURE_PATH
  end

when 'sinatra'
  # Load Sinatra
  require_relative "app/#{app_name}/app"

  # Load Rspec
  require 'rspec'

  # Configure
  RSpec.configure do |config|
    config.filter_run_excluding :rails
    config.include FixtureHelper
  end
end

module FixturePathHelper
  def fixture_path
    # Call fixture_paths.first in Rails >= 7.1 to avoid deprecation warnings
    respond_to?(:fixture_paths) ? fixture_paths.first : super
  end
end

##
# Common Rspec configure
#
RSpec.configure do |config|
  # Turn the deprecation warnings into errors, giving you the full backtrace
  config.raise_errors_for_deprecations!

  config.before(:suite) do
    Config.module_eval do

      # Extend Config module with ability to reset configuration to the default values
      def self.reset
        self.const_name             = 'Settings'
        self.use_env                = false
        self.knockout_prefix        = nil
        self.overwrite_arrays       = true
        self.schema                 = nil
        self.validation_contract    = nil
        self.fail_on_missing        = false
        self.use_rails_credentials  = false
        self.file_name              = 'settings'
        self.dir_name               = 'settings'
        instance_variable_set(:@_ran_once, false)
      end
    end
  end

  config.include FixturePathHelper
end

##
# Print some debug info
#
puts
puts "Gemfile: #{ENV['BUNDLE_GEMFILE']}"
puts 'Version:'

Gem.loaded_specs.each { |name, spec|
  puts "\t#{name}-#{spec.version}" if %w{rails activerecord-jdbcsqlite3-adapter sqlite3 rspec-rails sinatra}.include?(name)
}
puts "\tpsych-#{Psych::VERSION}"

puts
