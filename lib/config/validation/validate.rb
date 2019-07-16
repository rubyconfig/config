require 'config/validation/error'

module Config
  module Validation
    module Validate
      def validate!
        validate_using!(data: to_hash, schema: Config.validation_contract) if Config.validation_contract
        validate_using!(data: to_hash, schema: Config.schema) if Config.schema
      end

      private

      def validate_using!(data:, schema:)
        v_res = schema.(data)

        return if v_res.success?

        error = Config::Validation::Error.format(v_res)
        raise Config::Validation::Error, "Config validation failed:\n\n#{error}"
      end
    end
  end
end
