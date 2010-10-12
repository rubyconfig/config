require 'ostruct'
module RailsConfig
  class Options < OpenStruct

    def empty?
      marshal_dump.empty?
    end

    def add_source!(source)
      @config_sources ||= []
      @config_sources << source
    end

    # look through all our sources and rebuild the configuration
    def reload!
      conf = {}
      @config_sources.each do |source|
        source_conf = source.load

        if conf.empty?
          conf = source_conf
        else
          DeepMerge.deep_merge!(source_conf, conf, :preserve_unmergeables => false)
        end
      end

      # swap out the contents of the OStruct with a hash (need to recursively convert)
      marshal_load(__convert(conf).marshal_dump)

      return self
    end

    alias :load! :reload!

    protected

    # Recursively converts Hashes to Options (including Hashes inside Arrays)
    def __convert(h) #:nodoc:
      s = self.class.new

      h.each do |k, v|
        s.new_ostruct_member(k)
        if v.is_a?(Hash)
          if(v["type"] == "hash")
            val = v["contents"]
          else
            val = __convert(v)
          end
          s.send( (k+'=').to_sym, val)
        elsif v.is_a?(Array)
          converted_array = v.collect { |e| e.instance_of?(Hash) ? __convert(e) : e }
          s.send("#{k}=".to_sym, converted_array)
        else
          s.send("#{k}=".to_sym, v)
        end
      end
      s
    end
  end
end