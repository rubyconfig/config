require_relative '../dry_validation_requirements'
require_relative '../error'

module Config
  module Validation
    module Schema
      # Assigns schema configuration option
      def schema=(value)
        @schema = value
      end

      def schema(&block)
        if block_given?
          # Delay require until optional schema validation is requested
          Config::DryValidationRequirements.load_dry_validation!
          @schema = Dry::Schema.define(&block)
        else
          @schema
        end
      end
    end
  end
end
