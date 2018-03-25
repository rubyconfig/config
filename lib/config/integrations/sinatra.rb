require "config/rack/reloader"

module Config
  # provide helper to register within your Sinatra app
  #
  # set :root, File.dirname(__FILE__)
  # register Config
  #
  def self.registered(app)
    app.configure do |inner_app|

      env = inner_app.environment || ENV["RACK_ENV"]
      root = inner_app.root

      # use Padrino settings if applicable
      if defined?(Padrino)
        env = Padrino.env if Padrino.respond_to?(:env)
        root = Padrino.root if Padrino.respond_to?(:root)
      end

      Config.load_and_set_settings(Config.setting_files(File.join(root, 'config'), env))

      inner_app.use(::Config::Rack::Reloader) if inner_app.development?
    end
  end
end
