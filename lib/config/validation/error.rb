module Config
  module Validation
    class Error < StandardError

      def self.format(v_res)
        flatten_hash(v_res.messages).map do |field, msgs|
          "#{' ' * 2}#{field}: #{msgs.join('; ')}"
        end.join('\n')
      end

      def self.flatten_hash(h, acc={}, pref=[])
        h.inject(acc) do |a, (k, v)|
          if v.is_a?(Hash)
            flatten_hash(v, acc, pref + [k])
          else
            acc[(pref + [k]).join('.')] = v
            acc
          end
        end
      end

    end
  end
end
