module Config
  module Sources
    # Allows settings to be loaded from a "flat" hash with string keys, like ENV.
    class EnvSource
      def initialize(env)
        @env = env
      end

      def load
        return {} if @env.nil? || @env.empty?

        hash = Hash.new

        @env.each do |variable, value|
          separator = Config.env_separator
          prefix = (Config.env_prefix || Config.const_name).to_s.split(separator)

          keys = variable.to_s.split(separator)

          next if keys.shift(prefix.size) != prefix

          keys.map! { |key|
            case Config.env_converter
              when :downcase then
                key.downcase
              when nil then
                key
              else
                raise "Invalid ENV variables name converter: #{Config.env_converter}"
            end
          }

          leaf = keys[0...-1].inject(hash) { |h, key|
            h[key] ||= {}
          }

          unless leaf.is_a?(Hash)
            conflicting_key = (prefix + keys[0...-1]).join(separator)
            raise "Environment variable #{variable} conflicts with variable #{conflicting_key}"
          end

          leaf[keys.last] = Config.env_parse_values ? __value(value) : value
        end

        hash
      end

      private

      # Try to convert string to a correct type
      def __value(v)
        case v
        when 'false'
          false
        when 'true'
          true
        else
          Integer(v) rescue Float(v) rescue v
        end
      end
    end
  end
end
