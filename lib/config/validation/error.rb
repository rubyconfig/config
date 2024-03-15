require_relative "../error"

module Config
  module Validation
    class Error < ::Config::Error

      def self.format(v_res)
        v_res.errors.group_by(&:path).map do |path, messages|
          "#{' ' * 2}#{path.join('.')}: #{messages.map(&:text).join('; ')}"
        end.join("\n")
      end

    end
  end
end
