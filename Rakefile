#!/usr/bin/env rake

begin
  require 'bundler/setup'

  Bundler::GemHelper.install_tasks

rescue LoadError
  puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
end

##
# Testing
#
require "rspec"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

# Test for multiple Rails scenarios
if !ENV['APPRAISAL_INITIALIZED'] && !ENV['GITHUB_ACTIONS']
  require "appraisal"

  task :default => :appraisal
else
  task :default => :spec
end
