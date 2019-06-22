module Config
  module Validation
    class Error < StandardError

      def self.format(v_res)
        v_res.errors.group_by(&:path).map do |path, messages|
          "#{' ' * 2}#{path.join('.')}: #{messages.map(&:text).join('; ')}"
        end.join("\n")
      end

    end
  end
end
