# require 'rails_config'
require 'rails_config/tasks'

namespace 'rails_config' do
  task :heroku, [:app] => :environment do |_, args|
    RailsConfig::Tasks::Heroku.new(args[:app]).invoke
  end
end