require 'dry-validation'
require 'config/validation/schema'

module Config
  module Validation
    module Schema

      mattr_writer :schema
      @@schema = nil

      def schema(&block)
        if block_given?
          @@schema = Dry::Validation.Schema(&block)
        else
          @@schema
        end
      end

    end
  end
end
