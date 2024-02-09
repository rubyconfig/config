require 'config/integrations/heroku'

namespace 'config' do

  desc 'Upload to Heroku all env variables defined by config under current environment'
  task :heroku, [:app] => :environment do |_, args|
    Config::Integrations::Heroku.new(args[:app]).invoke
  end

end
