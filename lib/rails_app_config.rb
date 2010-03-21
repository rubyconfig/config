require 'application_config/deep_merge' unless defined?(DeepMerge)
require 'application_config/config_builder'
require 'application_config/view_helpers'

::AppConfig = ApplicationConfig::ConfigBuilder.load_files(
  :paths => [
    Rails.root.join("config", "app_config.yml").to_s
    Rails.root.join("config", "app_config", "settings.yml").to_s
    Rails.root.join("config", "app_config", "#{Rails.env}.yml").to_s
    Rails.root.join("config", "environments", "#{Rails.env}.yml").to_s
  ],
  :root_path => Rails.root
)
