module Config
  module Sources
    # Allows settings to be loaded from a "flat" hash with string keys, like ENV.
    class EnvSource
      attr_reader :prefix
      attr_reader :separator
      attr_reader :converter
      attr_reader :parse_values
      attr_reader :parse_arrays

      def initialize(env,
                     prefix: Config.env_prefix || Config.const_name,
                     separator: Config.env_separator,
                     converter: Config.env_converter,
                     parse_values: Config.env_parse_values,
                     parse_arrays: Config.env_parse_arrays)
        @env = env
        @prefix = prefix.to_s.split(separator)
        @separator = separator
        @converter = converter
        @parse_values = parse_values
        @parse_arrays = parse_arrays
      end

      def load
        return {} if @env.nil? || @env.empty?

        hash = Hash.new

        @env.each do |variable, value|
          keys = variable.to_s.split(separator)

          next if keys.shift(prefix.size) != prefix

          keys.map! { |key|
            case converter
              when :downcase then
                key.downcase
              when nil then
                key
              else
                raise "Invalid ENV variables name converter: #{converter}"
            end
          }

          leaf = keys[0...-1].inject(hash) { |h, key|
            h[key] ||= {}
          }

          unless leaf.is_a?(Hash)
            conflicting_key = (prefix + keys[0...-1]).join(separator)
            raise "Environment variable #{variable} conflicts with variable #{conflicting_key}"
          end

          leaf[keys.last] = parse_values ? __value(value) : value
        end

        parse_arrays ? convert_hashes_to_arrays(hash) : hash
      end

      private
      def convert_hashes_to_arrays(hash)
        hash.each_with_object({}) do |(key, value), new_hash|
          if value.is_a?(Hash)
            value = convert_hashes_to_arrays(value)
            if consecutive_numeric_keys?(value.keys)
              new_hash[key] = value.keys.sort_by(&:to_i).map { |k| value[k] }
            else
              new_hash[key] = value
            end
          else
            new_hash[key] = value
          end
        end
      end

      def consecutive_numeric_keys?(keys)
        keys.map(&:to_i).sort == (0...keys.size).to_a && keys.all? { |k| k == k.to_i.to_s }
      end

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
