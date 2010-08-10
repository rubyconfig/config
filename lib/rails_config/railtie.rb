if defined?(Rails::Railtie)
  module RailsConfig
    class Railtie < Rails::Railtie

      ActiveSupport.on_load :before_initialize, :yield => true do
        ::Settings = RailsConfig.load_files(
          Rails.root.join("config", "settings.yml").to_s,
          Rails.root.join("config", "settings", "#{Rails.env}.yml").to_s,
          Rails.root.join("config", "environments", "#{Rails.env}.yml").to_s
        )
      end

    end
  end
end
