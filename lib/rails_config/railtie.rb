if defined?(Rails::Railtie)
  module RailsConfig
    class Railtie < Rails::Railtie

      # Parse the settings before any of the initializers
      ActiveSupport.on_load :before_initialize, :yield => true do
        ::Settings = RailsConfig.load_files(
          Rails.root.join("config", "settings.yml").to_s,
          Rails.root.join("config", "settings", "#{Rails.env}.yml").to_s,
          Rails.root.join("config", "environments", "#{Rails.env}.yml").to_s
        )
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
