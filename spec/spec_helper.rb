ENV["RAILS_ENV"] ||= 'test'

##
# Load Rails dummy application based on gemfile name substituted by Appraisal
#
if ENV["APPRAISAL_INITIALIZED"] || ENV["TRAVIS"]
  app_name = Pathname.new(ENV['BUNDLE_GEMFILE']).basename.sub('.gemfile', '')
else
  app_name = 'rails_3'
end

require File.expand_path("../../spec/app/#{app_name}/config/environment", __FILE__)

##
# Load Rspec
#
#require 'rspec'
require 'rspec/rails'
require 'rspec/autorun'

# Checks for pending migrations before tests are run.
# If you are not using ActiveRecord, you can remove this line.
# ActiveRecord::Migration.check_pending! if defined?(ActiveRecord::Migration)

RSpec.configure do |config|
  config.fixture_path = File.join(File.dirname(__FILE__), "/fixtures")
end

##
# Helpers
#

# Loads ENV vars from a file
def load_env(filename)
  if filename and File.exists?(filename.to_s)
    result = YAML.load(ERB.new(IO.read(filename.to_s)).result)
  end
  result.each { |key, value| ENV[key.to_s] = value.to_s } unless result.nil?
end

##
# Some debug info
#
puts
puts "Gemfile: #{ENV['BUNDLE_GEMFILE']}"
puts "Rails version:"
puts "\trails-#{Gem.loaded_specs["rails"].version}"
puts "\tactivesupport-#{Gem.loaded_specs["activesupport"].version}"
puts

