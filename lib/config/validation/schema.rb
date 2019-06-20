require 'dry-schema'
require 'config/validation/schema'

module Config
  module Validation
    module Schema

      mattr_writer :schema
      @@schema = nil

      def schema(&block)
        if block_given?
          @@schema = Dry::Schema.define(&block)
        else
          @@schema
        end
      end

    end
  end
end
