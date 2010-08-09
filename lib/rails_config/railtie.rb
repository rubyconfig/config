if defined?(Rails::Railtie)
  module RailsConfig
    class Railtie < Rails::Railtie
      initializer :setup_rails_config do
        ::Settings = RailsConfig.load_files(
          Rails.root.join("config", "settings.yml").to_s,
          Rails.root.join("config", "settings", "#{Rails.env}.yml").to_s,
          Rails.root.join("config", "environments", "#{Rails.env}.yml").to_s
        )
      end
    end
  end
end
