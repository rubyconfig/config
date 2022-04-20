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
          begin
            require 'dry/validation/version'
            version = Gem::Version.new(Dry::Validation::VERSION)
            unless ::Config::DRY_VALIDATION_REQUIREMENTS.all? { |req| Gem::Requirement.new(req).satisfied_by?(version) }
              raise LoadError
            end
          rescue LoadError
            raise ::Config::Error, 'Could not find a dry-validation version matching requirements' \
              " (#{::Config::DRY_VALIDATION_REQUIREMENTS.map(&:inspect) * ','})"
          end
          # Delay require until optional schema validation is requested
          require 'dry-validation'
          @schema = Dry::Schema.define(&block)
        else
          @schema
        end
      end
    end
  end
end
