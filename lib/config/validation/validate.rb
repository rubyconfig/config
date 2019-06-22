require 'config/validation/error'

module Config
  module Validation
    module Validate

      def validate!
        if Config.schema
          v_res = Config.schema.(self.to_hash)

          unless v_res.success?
            error = Config::Validation::Error.format(v_res)
            raise Config::Validation::Error.new("Config validation failed:\n\n#{error}")
          end
        end
      end

    end
  end
end
