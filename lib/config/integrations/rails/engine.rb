module Config
  module Integrations
    module Rails
      class Engine < ::Rails::Engine
        isolate_namespace Config
      end
    end
  end
end
