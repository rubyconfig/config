if defined?(Rails::Railtie)
  module RailsAppConfig
    class Railtie < Rails::Railtie
      initializer :setup_app_config do
        ::AppConfig = ApplicationConfig::ConfigBuilder.load_files(
          :paths => [
            Rails.root.join("config", "app_config.yml").to_s,
            Rails.root.join("config", "app_config", "settings.yml").to_s,
            Rails.root.join("config", "app_config", "#{Rails.env}.yml").to_s,
            Rails.root.join("config", "environments", "#{Rails.env}.yml").to_s
          ],
          :root_path => Rails.root
        )
      end
    end
  end
end
