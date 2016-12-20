module Config
  module Validation
    def validate!
      v_res = Config.schema.(self.to_hash)

      unless v_res.success?
        raise ValidationError.new("Config validation failed:\n\n#{format_errors(v_res)}")
      end
    end

    def format_errors(v_res)
      flatten_hash(v_res.messages).map do |field, msgs|
        "#{' ' * 2}#{field}: #{msgs.join('; ')}"
      end.join('\n')
    end

    def flatten_hash(h, acc={}, pref=[])
      h.inject(acc) do |a, (k,v)|
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
