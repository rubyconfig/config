require "rails_config/rack/reloader"

module RailsConfig
  # provide helper to register within your Sinatra app
  #
  # set :root, File.dirname(__FILE__)
  # register RailsConfig
  #
  def self.registered(app)
    app.configure do |inner_app|

      env = inner_app.environment || ENV["RACK_ENV"]
      root = inner_app.root

      # use Padrino settings if applicable
      if defined?(Padrino)
        env = Padrino.env
        root = Padrino.root
      end

      RailsConfig.load_and_set_settings(
        File.join(root.to_s, "config", "settings.yml").to_s,
        File.join(root.to_s, "config", "settings", "#{env}.yml").to_s,
        File.join(root.to_s, "config", "environments", "#{env}.yml").to_s,

        File.join(root.to_s, "config", "settings.local.yml").to_s,
        File.join(root.to_s, "config", "settings", "#{env}.local.yml").to_s,
        File.join(root.to_s, "config", "environments", "#{env}.local.yml").to_s
      )

      inner_app.use(::RailsConfig::Rack::Reloader) if inner_app.development?
    end
  end

end