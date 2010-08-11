require 'ostruct'
module RailsConfig
  class Options < OpenStruct
    def empty?
      marshal_dump.empty?
    end

    def replace_contents!(new_options)
      marshal_load(self.class.convert(new_options).marshal_dump)
    end

    # Recursively converts Hashes to Options (including Hashes inside Arrays)
    def self.convert(h) #:nodoc:
      s = new
      h.each do |k, v|
        s.new_ostruct_member(k)
        if v.is_a?(Hash)
          s.send( (k+'=').to_sym, convert(v))
        elsif v.is_a?(Array)
          converted_array = v.collect { |e| e.instance_of?(Hash) ? convert(e) : e }
          s.send("#{k}=".to_sym, converted_array)
        else
          s.send("#{k}=".to_sym, v)
        end
      end
      s
    end
  end
end