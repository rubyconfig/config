module Config::Integrations::Helpers

  def to_dotted_hash(source, target: {}, namespace: nil)
    raise ArgumentError, "target must be a hash (given: #{target.class.name})" unless target.kind_of? Hash
    prefix = "#{namespace}." if namespace
    case source
      when Hash
        source.each do |key, value|
          to_dotted_hash(value, target: target, namespace: "#{prefix}#{key}")
        end
      when Array
        source.each_with_index do |value, index|
          to_dotted_hash(value, target: target, namespace: "#{prefix}#{index}")
        end
      else
        target[namespace] = source
    end
    target
  end

end