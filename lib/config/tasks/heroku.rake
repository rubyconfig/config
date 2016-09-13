require 'config/integrations/heroku'

namespace 'config' do
  task :heroku, [:app] => :environment do |_, args|
    Config::Integrations::Heroku.new(args[:app]).invoke
  end
end
