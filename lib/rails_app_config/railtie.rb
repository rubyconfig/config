if defined?(Rails::Railtie)
  module RailsAppConfig
    class Railtie < Rails::Railtie
      initializer :add_before_filter do
        # do something here?
      end
    end
  end
end
