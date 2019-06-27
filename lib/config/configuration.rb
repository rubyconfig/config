module Config
  # The main configuration backbone
  class Configuration < Module
    # Accepts configuration options,
    # initializing a module that can be used to extend
    # the necessary class with the provided config methods
    def initialize(**attributes)
      attributes.each do |name, default|
        define_reader(name, default)
        define_writer(name)
      end
    end

    private

    def define_reader(name, default)
      variable = :"@#{name}"

      define_method(name) do
        if instance_variable_defined?(variable)
          instance_variable_get(variable)
        else
          default
        end
      end
    end

    def define_writer(name)
      variable = :"@#{name}"

      define_method("#{name}=") do |value|
        instance_variable_set(variable, value)
      end
    end
  end
end
