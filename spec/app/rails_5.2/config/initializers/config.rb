# This is how you would initialize the config object
# when not using the default rails environments

Config.setup do |config|
  config.environment = 'any_env'
  config.const_name = 'RailtieSettings'
  config.env_parse_values = true
end
