ENV["RAILS_ENV"] ||= 'test'

##
# Code Climate
#
if ENV["TRAVIS"]
  require "codeclimate-test-reporter"
  CodeClimate::TestReporter.start
end

##
# Load Rspec supporting files
#
Dir['./spec/support/**/*.rb'].each { |f| require f }

##
# Load Rails dummy application based on gemfile name substituted by Appraisal
#
if ENV["APPRAISAL_INITIALIZED"] || ENV["TRAVIS"]
  app_name = Pathname.new(ENV['BUNDLE_GEMFILE']).basename.sub('.gemfile', '')
else
  app_name = 'rails_3'
end

require File.expand_path("../../spec/app/#{app_name}/config/environment", __FILE__)

APP_RAKEFILE = File.expand_path("../../spec/app/#{app_name}/Rakefile", __FILE__)

##
# Load Rspec
#
require 'rspec/rails'

# Configure
RSpec.configure do |config|
  config.fixture_path = File.join(File.dirname(__FILE__), "/fixtures")

  # Turn the deprecation warnings into errors, giving you the full backtrace
  config.raise_errors_for_deprecations!
end


##
# Print some debug info
#
puts
puts "Gemfile: #{ENV['BUNDLE_GEMFILE']}"
puts "Rails version:"

Gem.loaded_specs.each { |name, spec|
  puts "\t#{name}-#{spec.version}" if %w{rails activesupport sqlite3 rspec-rails}.include?(name)
}

puts
