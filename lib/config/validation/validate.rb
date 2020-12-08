require 'config/validation/error'

module Config
  module Validation
    module Validate
      def validate!
        validate_using!(Config.validation_contract)
        validate_using!(Config.schema)
      end

      private

      def validate_using!(validator)
        if validator
          result = validator.call(to_hash)

          return if result.success?

          error = Config::Validation::Error.format(result)
          raise Config::Validation::Error, "Config validation failed:\n\n#{error}"
        end
      end
    end
  end
end
