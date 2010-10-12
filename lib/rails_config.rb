require 'active_support/core_ext/module/attribute_accessors'
require 'rails_config/options'

require "rails_config/sources/yaml_source"

require 'rails_config/vendor/deep_merge' unless defined?(DeepMerge)

module RailsConfig
  # ensures the setup only gets run once
  @@_ran_once = false

  mattr_accessor :const_name
  @@const_name = "Settings"

  def self.setup
    yield self if @@_ran_once == false
    @@_ran_once = true
  end

  # Create a populated Options instance from a yaml file.  If a second yaml file is given, then the sections of that file will overwrite the sections
  # if the first file if they exist in the first file.
  def self.load_files(*files)
    config = Options.new

    # add yaml sources
    [files].flatten.compact.uniq.each do |file|
      config.add_source!(Sources::YAMLSource.new(file))
    end
    config.load!
    config
  end

  # Loads and sets the settings constant!
  def self.load_and_set_settings(*files)
    Kernel.send(:remove_const, RailsConfig.const_name) if Kernel.const_defined?(RailsConfig.const_name)
    Kernel.const_set(RailsConfig.const_name, RailsConfig.load_files(files))
  end
end

# add railtie
require 'rails_config/railtie'
