require 'config/validation/error'

module Config
  module Validation
    module Validate
      def validate!
        validate_using!(Config.validation_contract)
        validate_using!(Config.schema)
      def validate_using!(validator)
        if validator
          result = validator.call(to_hash)

          raise Config::Validation::Error, "Config validation failed:\n\n#{error}"
        end
      end
    end
  end
end
