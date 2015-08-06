require 'active_support/core_ext/module/attribute_accessors'

require 'config/compatibility'
require 'config/options'
require 'config/version'
require 'config/engine' if defined?(::Rails)
require 'config/sources/yaml_source'
require 'deep_merge'

module Config
  # ensures the setup only gets run once
  @@_ran_once = false

  mattr_accessor :const_name, :use_env
  @@const_name = "Settings"
  @@use_env = false

  def self.setup
    yield self if @@_ran_once == false
    @@_ran_once = true
  end

  # Create a populated Options instance from a yaml file. If a second yaml file is given, then the sections of that
  # file will overwrite existing sections of the first file.
  def self.load_files(*files)
    config = Options.new

    # add yaml sources
    [files].flatten.compact.uniq.each do |file|
      config.add_source!(file.to_s)
    end

    config.load!
    config.load_env! if @@use_env
    config
  end

  # Loads and sets the settings constant!
  def self.load_and_set_settings(*files)
    Kernel.send(:remove_const, Config.const_name) if Kernel.const_defined?(Config.const_name)
    Kernel.const_set(Config.const_name, Config.load_files(files))
  end

  def self.setting_files(config_root, env)
    [
      File.join(config_root, "settings.yml").to_s,
      File.join(config_root, "settings", "#{env}.yml").to_s,
      File.join(config_root, "environments", "#{env}.yml").to_s,

      File.join(config_root, "settings.local.yml").to_s,
      File.join(config_root, "settings", "#{env}.local.yml").to_s,
      File.join(config_root, "environments", "#{env}.local.yml").to_s
    ].freeze
  end

  def self.reload!
    Kernel.const_get(Config.const_name).reload!
  end
end

# add rails integration
require('config/integration/rails') if defined?(::Rails)

# add sinatra integration
require('config/integration/sinatra') if defined?(::Sinatra)
