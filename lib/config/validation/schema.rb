module Config
  module Validation
    module Schema
      # Assigns schema configuration option
      def schema=(value)
        @schema = value
      end

      def schema(&block)
        if block_given?
          @schema = Dry::Schema.define(&block)
        else
          @schema
        end
      end
    end
  end
end
