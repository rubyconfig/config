require 'config/options'
require 'config/configuration'
require 'config/dry_validation_requirements'
require 'config/version'
require 'config/sources/yaml_source'
require 'config/sources/hash_source'
require 'config/sources/env_source'
require 'config/validation/schema'
require 'deep_merge/core'

module Config
  extend Config::Validation::Schema
  extend Config::Configuration.new(
    # general options
    const_name: 'Settings',
    use_env: false,
    env_prefix: 'Settings',
    env_separator: '.',
    env_converter: :downcase,
    env_parse_values: true,
    env_parse_arrays: false,
    fail_on_missing: false,
    file_name: 'settings',
    dir_name: 'settings',
    # deep_merge options
    knockout_prefix: nil,
    merge_nil_values: true,
    overwrite_arrays: true,
    merge_hash_arrays: false,
    validation_contract: nil,
    evaluate_erb_in_yaml: true,
    use_rails_credentials: false,
    environment: nil
  )

  def self.setup
    yield self unless @_ran_once
    @_ran_once = true
  end

  # Create a populated Options instance from a settings file. If a second file is given, then the sections of that
  # file will overwrite existing sections of the first file.
  def self.load_files(*sources)
    config = Options.new

    # add settings sources
    [sources].flatten.compact.each do |source|
      config.add_source!(source)
    end

    # load rails crendentials
    if defined?(::Rails::Railtie) && Config.use_rails_credentials
      if Rails.application.credentials.respond_to?(:credentials)
        config.add_source!(Sources::HashSource.new(Rails.application.credentials.config.deep_stringify_keys))
      else
        config.add_source!(Sources::HashSource.new(Rails.application.secrets.to_h.deep_stringify_keys))
      end
    end

    config.add_source!(Sources::EnvSource.new(ENV)) if Config.use_env

    config.load!
    config
  end

  # Loads and sets the settings constant!
  def self.load_and_set_settings(*sources)
    name = Config.const_name
    Object.send(:remove_const, name) if Object.const_defined?(name)
    Object.const_set(name, Config.load_files(sources))
  end

  def self.setting_files(config_root, env)
    [
      File.join(config_root, "#{Config.file_name}.yml").to_s,
      File.join(config_root, Config.dir_name, "#{env}.yml").to_s,
      File.join(config_root, 'environments', "#{env}.yml").to_s,
      *local_setting_files(config_root, env)
    ].freeze
  end

  def self.local_setting_files(config_root, env)
    [
      (File.join(config_root, "#{Config.file_name}.local.yml").to_s if env != 'test'),
      File.join(config_root, Config.dir_name, "#{env}.local.yml").to_s,
      File.join(config_root, 'environments', "#{env}.local.yml").to_s
    ].compact
  end

  def self.reload!
    Object.const_get(Config.const_name).reload!
  end
end

# Rails integration
require('config/integrations/rails/railtie') if defined?(::Rails::Railtie)

# Sinatra integration
require('config/integrations/sinatra') if defined?(::Sinatra)
