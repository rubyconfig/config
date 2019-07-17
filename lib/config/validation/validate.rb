require 'config/validation/error'

module Config
  module Validation
    module Validate
      def validate!
        validation_contract = Config.validation_contract
        validate_using!(data: to_hash, schema: validation_contract) if validation_contract.present?

        schema = Config.schema
        validate_using!(data: to_hash, schema: schema) if schema.present?
      end

      private

      def validate_using!(data:, schema:)
        v_res = schema.call(data)

        return if v_res.success?

        error = Config::Validation::Error.format(v_res)
        raise Config::Validation::Error, "Config validation failed:\n\n#{error}"
      end
    end
  end
end
