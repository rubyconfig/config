module Config
  module Rack
    # Rack middleware the reloads Config on every request (only use in dev mode)
    class Reloader
      def initialize(app)
        @app = app
      end

      def call(env)
        Config.reload!
        @app.call(env)
      end
    end
  end
end