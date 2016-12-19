module Config
  module Sources
    class HashSource
      attr_accessor :hash

      def initialize(hash)
        @hash = hash
      end

      # returns hash that was passed in to initialize
      def load
        hash.is_a?(Hash) ? hash : {}
      end
    end
  end
end
