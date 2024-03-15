require 'config/validation/error'

module Config
  module Validation
    module Validate
      def validate!
        return unless Config.validation_contract || Config.schema

        Config::DryValidationRequirements.load_dry_validation!

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
