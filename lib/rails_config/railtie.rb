if defined?(Rails::Railtie)
  module RailsConfig
    class Railtie < Rails::Railtie

      # manually load the custom initializer before everything else
      initializer :load_custom_rails_config, :before => :bootstrap_hook do
        initializer = Rails.root.join("config", "initializers", "rails_config")
        require initializer if File.exist?(initializer)
      end

      # Parse the settings before any of the initializers
      ActiveSupport.on_load :before_configuration, :yield => true do
        RailsConfig.load_and_set_settings(
          Rails.root.join("config", "settings.yml").to_s,
          Rails.root.join("config", "settings.local.yml").to_s
        )
      end

      # Rails Dev environment should reload the Settings on every request
      if Rails.env.development?
        initializer :rails_config_reload_on_development do
          ActionController::Base.class_eval do
            prepend_before_filter { ::RailsConfig.const_name.constantize.reload! }
          end
        end
      end

    end
  end
end
