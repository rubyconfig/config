require 'ostruct'
require 'config/validation/validate'

module Config
  class Options < OpenStruct
    include Enumerable
    include Validation::Validate

    def keys
      marshal_dump.keys
    end

    def empty?
      marshal_dump.empty?
    end

    def add_source!(source)
      load_config_sources(:push, source)
    end

    def prepend_source!(source)
      load_config_sources(:unshift, source)
    end

    # look through all our sources and rebuild the configuration
    def reload!
      conf = {}
      @config_sources.each do |source|
        source_conf = source.load

        if conf.empty?
          conf = source_conf
        else
          hash_deep_merge(source_conf, conf)
        end
      end

      # swap out the contents of the OStruct with a hash (need to recursively convert)
      marshal_load(__convert(conf).marshal_dump)

      validate!

      self
    end

    alias :load! :reload!

    def reload_from_files(*files)
      Config.load_and_set_settings(files)
      reload!
    end

    def to_hash
      result = {}
      marshal_dump.each do |key, value|
        result[key] = instance_of(value)
      end
      result
    end

    alias :to_h :to_hash

    def each(*args, &block)
      marshal_dump.each(*args, &block)
    end

    def to_json(*args)
      require "json" unless defined?(JSON)
      to_hash.to_json(*args)
    end

    def as_json(options = nil)
      to_hash.as_json(options)
    end

    def merge!(hash)
      current = to_hash
      hash_deep_merge(hash.dup, current)
      marshal_load(__convert(current).marshal_dump)
      self
    end

    # Some keywords that don't play nicely with OpenStruct
    SETTINGS_RESERVED_NAMES = %w[select collect test count zip min max exit!].freeze

    # An alternative mechanism for property access.
    # This let's you do foo['bar'] along with foo.bar.
    def [](param)
      return super if SETTINGS_RESERVED_NAMES.include?(param)
      send("#{param}")
    end

    def []=(param, value)
      send("#{param}=", value)
    end

    SETTINGS_RESERVED_NAMES.each do |name|
      define_method name do
        self[name]
      end
    end

    def key?(key)
      table.key?(key)
    end

    def has_key?(key)
      table.has_key?(key)
    end

    def method_missing(method_name, *args)
      if Config.fail_on_missing && method_name !~ /.*(?==\z)/m
        raise KeyError, "key not found: #{method_name.inspect}" unless key?(method_name)
      end
      super
    end

    def respond_to_missing?(*args)
      super
    end

    protected

    def load_config_sources(method, source)
      # handle yaml file paths
      source = (Sources::YAMLSource.new(source)) if source.is_a?(String)
      source = (Sources::HashSource.new(source)) if source.is_a?(Hash)

      @config_sources ||= []
      @config_sources.send(method, source)
    end

    def hash_deep_merge(source, dest)
      DeepMerge.deep_merge!(
                            source,
                            dest,
                            preserve_unmergeables: false,
                            knockout_prefix:       Config.knockout_prefix,
                            overwrite_arrays:      Config.overwrite_arrays,
                            merge_nil_values:      Config.merge_nil_values,
                            merge_hash_arrays:     Config.merge_hash_arrays
                          )
    end

    def instance_of(value)
      if value.instance_of? Config::Options
        value.to_hash
      elsif value.instance_of? Array
        descend_array(value)
      else
        value
      end
    end

    def descend_array(array)
      array.map { |value| instance_of(value) }
    end

    # Recursively converts Hashes to Options (including Hashes inside Arrays)
    def __convert(hash) #:nodoc:
      s = self.class.new

      hash.each do |k, v|
        k = k.to_s if !k.respond_to?(:to_sym) && k.respond_to?(:to_s)

        if v.is_a?(Hash)
          v = v["type"] == "hash" ? v["contents"] : __convert(v)
        elsif v.is_a?(Array)
          v = v.collect { |e| e.instance_of?(Hash) ? __convert(e) : e }
        end

        s[k] = v
      end
      s
    end
  end
end
