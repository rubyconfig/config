if defined?(RbConfig) && defined?(Config)
  Object.send :remove_const, :Config
end
