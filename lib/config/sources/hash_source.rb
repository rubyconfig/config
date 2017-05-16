module Config
  module Sources
    class HashSource
      attr_accessor :hash

      def initialize(hash)
        @hash = hash
      end

      # returns hash that was passed in to initialize
      def load
        hash.is_a?(Hash) ? hash.deep_stringify_keys : {}
      end
    end
  end
end
