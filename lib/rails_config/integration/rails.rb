module RailsConfig
  module Integration
    module Rails3
      if defined?(Rails::Railtie)
        class Railtie < Rails::Railtie

          initializer "rails_config" do
            ActiveSupport.on_load :before_configuration, :yield => true do
              initializer = Rails.root.join("config", "initializers", "rails_config.rb")
              require initializer if File.exist?(initializer)


              RailsConfig.load_and_set_settings(
                Rails.root.join("config", "settings.yml").to_s,
                Rails.root.join("config", "settings", "#{Rails.env}.yml").to_s,
                Rails.root.join("config", "environments", "#{Rails.env}.yml").to_s,

                Rails.root.join("config", "settings.local.yml").to_s,
                Rails.root.join("config", "settings", "#{Rails.env}.local.yml").to_s,
                Rails.root.join("config", "environments", "#{Rails.env}.local.yml").to_s
              )
              
              # Rails Dev environment should reload the Settings on every request
              if Rails.env.development?
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
end
