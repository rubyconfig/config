require "config/rack/reloader"

::Hanami.plugin do
  env = ::Hanami.env
  root = ::Hanami.root
  Config.load_and_set_settings(Config.setting_files(File.join(root, 'config'), env))

  middleware.use(::Config::Rack::Reloader) if env == "development"
end
