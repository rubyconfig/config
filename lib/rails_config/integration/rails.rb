module RailsConfig
  module Integration
    module Rails3
      if defined?(Rails::Railtie)
        class Railtie < Rails::Railtie

          # manually load the custom initializer before everything else
          initializer :load_custom_rails_config, :before => :load_environment_config, :group => :all do
            initializer = Rails.root.join("config", "initializers", "rails_config.rb")
            require initializer if File.exist?(initializer)
          end

          # Parse the settings before any of the initializers
          initializer :load_rails_config_settings, :after => :load_custom_rails_config, :before => :load_environment_config, :group => :all do
            RailsConfig.load_and_set_settings(
              Rails.root.join("config", "settings.yml").to_s,
              Rails.root.join("config", "settings", "#{Rails.env}.yml").to_s,
              Rails.root.join("config", "environments", "#{Rails.env}.yml").to_s,

              Rails.root.join("config", "settings.local.yml").to_s,
              Rails.root.join("config", "settings", "#{Rails.env}.local.yml").to_s,
              Rails.root.join("config", "environments", "#{Rails.env}.local.yml").to_s
            )
          end

          # Rails Dev environment should reload the Settings on every request
          if Rails.env.development?
            initializer :rails_config_reload_on_development do
              ActionController::Base.class_eval do
                prepend_before_filter { ::RailsConfig.reload! }
              end
            end
          end
        end
      end
    end
  end
end
