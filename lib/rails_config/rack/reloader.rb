module RailsConfig
  module Rack
    # Rack middleware the reloads RailsConfig on every request (only use in dev mode)
    class Reloader
      def initialize(app)
        @app = app
      end

      def call(env)
        RailsConfig.reload!
        @app.call(env)
      end
    end
  end
end