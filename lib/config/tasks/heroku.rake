# require 'config'
require 'config/tasks'

namespace 'config' do
  task :heroku, [:app] => :environment do |_, args|
    Config::Tasks::Heroku.new(args[:app]).invoke
  end
end