module Config
  class Engine < ::Rails::Engine
    isolate_namespace Config
  end
end
