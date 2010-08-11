require 'active_support/core_ext/module/attribute_accessors'
require 'pathname'
require 'rails_config/options'
require 'yaml'
require 'erb'

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

  @@load_paths = []
  def self.load_paths
    @@load_paths
  end

  # Create a populated Options instance from a yaml file.  If a second yaml file is given, then the sections of that file will overwrite the sections
  # if the first file if they exist in the first file.
  def self.load_files(*files)
    config = Options.new

    @@load_paths = [files].flatten.compact.uniq
    # add singleton method to our Settings that reloads its settings from the load_paths
    def config.reload!

      conf = {}
      RailsConfig.load_paths.to_a.each do |path|
        file_conf = YAML.load(ERB.new(IO.read(path.to_s)).result) if path and File.exists?(path.to_s)
        next unless file_conf

        if conf.size > 0
          DeepMerge.deep_merge!(file_conf, conf, :preserve_unmergeables => false)
        else
          conf = file_conf
        end
      end

      # load all the new values into the Options
      replace_contents!(conf)
      return self
    end

    config.reload!
    return config
  end

end

# add railtie
require 'rails_config/railtie'
