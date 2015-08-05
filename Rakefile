#!/usr/bin/env rake

begin
  require 'bundler/setup'

  Bundler::GemHelper.install_tasks

rescue LoadError
  puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
end

task :default do
  system "rake -T"
end
