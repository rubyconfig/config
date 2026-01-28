##
# Config Rspec Helpers
#

# Loads ENV vars from a yaml file
def load_env(filename)
  result = YAML.load(ERB.new(File.read(filename.to_s)).result) if filename && File.exist?(filename.to_s)
  result&.each { |key, value| ENV[key.to_s] = value.to_s }
end

# Checks if (default) Config const is already available
def config_available?
  where = caller[0].split(':')[0].gsub(__dir__, '')

  raise "Config not available in #{where}" unless defined?(::Settings)

  puts "Config available in #{where}"
end
