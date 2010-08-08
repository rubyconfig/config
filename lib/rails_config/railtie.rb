if defined?(Rails::Railtie)
  module RailsConfig
    class Railtie < Rails::Railtie
      initializer :setup_rails_config do
        ::Settings = RailsConfig::Settings::Builder.load_files(
          :paths => [
            Rails.root.join("config", "settings.yml").to_s,
            Rails.root.join("config", "settings", "#{Rails.env}.yml").to_s,
            Rails.root.join("config", "environments", "#{Rails.env}.yml").to_s
          ],
          :root_path => Rails.root
        )
      end
    end
  end
end
