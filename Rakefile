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
if !ENV["APPRAISAL_INITIALIZED"] && !ENV["TRAVIS"]
  require "appraisal"

  task :default => :appraisal
else
  task :default => :spec
end

##
# Documentation
#
require 'rdoc/task'

RDoc::Task.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = "Config #{Config::VERSION}"
  rdoc.options << '--line-numbers'
  rdoc.rdoc_files.include('README.*')
  rdoc.rdoc_files.include('CHANGELOG.*')
  rdoc.rdoc_files.include('LICENSE.*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
