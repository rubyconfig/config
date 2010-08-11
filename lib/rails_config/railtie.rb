if defined?(Rails::Railtie)
  module RailsConfig
    class Railtie < Rails::Railtie

      # manually load the custom initializer before everything else
      initializer :load_custom_rails_config, :before => :bootstrap_hook do
        require Rails.root.join("config", "initializers", "rails_config")
      end

      # Parse the settings before any of the initializers
      ActiveSupport.on_load :before_initialize, :yield => true do
        settings = RailsConfig.load_files(
          Rails.root.join("config", "settings.yml").to_s,
          Rails.root.join("config", "settings", "#{Rails.env}.yml").to_s,
          Rails.root.join("config", "environments", "#{Rails.env}.yml").to_s
        )
        
        Kernel.const_set(RailsConfig.const_name, settings)
      end

      # Rails Dev environment should reload the Settings on every request
      if Rails.env.development?
        initializer :rails_config_reload_on_development do
          ActionController::Base.class_eval do
            prepend_before_filter { ::Settings.reload! }
          end
        end
      end

    end
  end
end
