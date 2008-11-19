require 'application_config/config_builder'
require 'application_config/view_helpers'

::AppConfig = ApplicationConfig::ConfigBuilder.load_files(
  :paths => [
    "#{Rails.root}/config/app_config.yml",
    "#{Rails.root}/config/app_config/settings.yml",
    "#{Rails.root}/config/app_config/#{Rails.env}.yml",
    "#{Rails.root}/config/environments/#{Rails.env}.yml",
    "#{Rails.root}/config/assets.yml",
    "#{Rails.root}/config/javascripts.yml",
    "#{Rails.root}/config/stylesheets.yml"
  ],
  :expand_keys => [:javascripts, :stylesheets],
  :root_path => Rails.root
)

ActionView::Base.send :include, ApplicationConfig::ViewHelpers
