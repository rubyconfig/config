module RailsConfig
  module Integration
    module Rails
      if defined?(::Rails::Railtie)
        class Railtie < ::Rails::Railtie

          # TODO: allo them to override init_callback via ENV or something?
          if ::Rails::VERSION::MAJOR >= 4 and ::Rails::VERSION::MINOR >= 1
            init_callback = :before_initialize
          else
            init_callback = :before_configuration
          end

          ActiveSupport.on_load init_callback, :yield => true do
            # manually load the custom initializer before everything else
            initializer = ::Rails.root.join("config", "initializers", "rails_config.rb")
            require initializer if File.exist?(initializer)

            # Parse the settings before any of the initializers
            RailsConfig.load_and_set_settings(
              ::Rails.root.join("config", "settings.yml").to_s,
              ::Rails.root.join("config", "settings", "#{::Rails.env}.yml").to_s,
              ::Rails.root.join("config", "environments", "#{::Rails.env}.yml").to_s,

              ::Rails.root.join("config", "settings.local.yml").to_s,
              ::Rails.root.join("config", "settings", "#{::Rails.env}.local.yml").to_s,
              ::Rails.root.join("config", "environments", "#{::Rails.env}.local.yml").to_s
            )
          end

          # Rails Dev environment should reload the Settings on every request
          if ::Rails.env.development?
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