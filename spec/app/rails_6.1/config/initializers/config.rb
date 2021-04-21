# This is how you would initialize the config object
# when not using the default rails environments

Config.setup do |config|
  config.environment = ENV['NON_RAILS_ENVIRONMENT'].downcase
  config.const_name = 'RailtieSettings'
  config.env_parse_values = true
end

