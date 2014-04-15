require 'ostruct'
module RailsConfig
  class Options < OpenStruct

    include Enumerable

    def empty?
      marshal_dump.empty?
    end

    def add_source!(source)
      # handle yaml file paths
      source = (Sources::YAMLSource.new(source)) if source.is_a?(String)

      @config_sources ||= []
      @config_sources << source
    end

    def reload_env!
      return self if ENV.nil? || ENV.empty?
      conf = Hash.new
      ENV.each do |key, value|
        next unless key.to_s.index(RailsConfig.const_name) == 0
        hash = value
        key.to_s.split('.').reverse.each do |element|
          hash = {element => hash}
        end
        DeepMerge.deep_merge!(hash, conf, :preserve_unmergeables => false)
      end

      merge!(conf[RailsConfig.const_name] || {})
    end

    alias :load_env! :reload_env!

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

      reload_env! if RailsConfig.use_env

      return self
    end

    alias :load! :reload!

    def reload_from_files(*files)
      RailsConfig.load_and_set_settings(files)
      reload!
    end

    def to_hash
      result = {}
      marshal_dump.each do |k, v|
        result[k] = v.instance_of?(RailsConfig::Options) ? v.to_hash : v
      end
      result
    end

    def each(*args, &block)
      marshal_dump.each(*args, &block)
    end

    def to_json(*args)
      require "json" unless defined?(JSON)
      to_hash.to_json(*args)
    end

    def merge!(hash)
      current = to_hash
      DeepMerge.deep_merge!(hash.dup, current)
      marshal_load(__convert(current).marshal_dump)
      self
    end

    # An alternative mechanism for property access.
    # This let's you do foo['bar'] along with foo.bar.
    def [](param)
      send("#{param}")
    end

    def []=(param, value)
      send("#{param}=", value)
    end
    
    protected

    # Recursively converts Hashes to Options (including Hashes inside Arrays)
    def __convert(h) #:nodoc:
      s = self.class.new

      h.each do |k, v|
        k = k.to_s if !k.respond_to?(:to_sym) && k.respond_to?(:to_s)
        s.new_ostruct_member(k)

        if v.is_a?(Hash)
          v = v["type"] == "hash" ? v["contents"] : __convert(v)
        elsif v.is_a?(Array)
          v = v.collect { |e| e.instance_of?(Hash) ? __convert(e) : e }
        end

        s.send("#{k}=".to_sym, v)
      end
      s
    end
  end
end
