##
# Config Rspec Helpers
#

# Loads ENV vars from a yaml file
def load_env(filename)
  if filename and File.exists?(filename.to_s)
    result = YAML.load(ERB.new(IO.read(filename.to_s)).result)
  end
  result.each { |key, value| ENV[key.to_s] = value.to_s } unless result.nil?
end

# Checks if (default) Config const is already available
def config_available?
  where = caller[0].split(':')[0].gsub(File.expand_path(File.dirname(__FILE__)), '')

  if defined?(::Settings)
    puts "Config available in #{where}"
  else
    raise "Config not available in #{where}"
  end
end
