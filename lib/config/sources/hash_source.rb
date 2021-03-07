module Config
  module Sources
    class HashSource
      attr_accessor :hash

      def initialize(hash, namespace = nil)
        @hash = hash

        # Make sure @namespace is an array if it exists at all
        if namespace
          @namespace = namespace
          @namespace = [@namespace] unless @namespace.is_a?(Array)
        end
      end

      # returns hash that was passed in to initialize
      def load
        return {} unless hash.is_a?(Hash)
        return hash unless @namespace
        return  @namespace.reverse.inject(hash) { |a, n| { n => a } }
      end
    end
  end
end
