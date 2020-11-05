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
      # handle yaml file paths
      source = (Sources::YAMLSource.new(source)) if source.is_a?(String)
      source = (Sources::HashSource.new(source)) if source.is_a?(Hash)

      @config_sources ||= []
      @config_sources << source
    end

    def prepend_source!(source)
      source = (Sources::YAMLSource.new(source)) if source.is_a?(String)
      source = (Sources::HashSource.new(source)) if source.is_a?(Hash)

      @config_sources ||= []
      @config_sources.unshift(source)
    end

    def reload_env!
      return self if ENV.nil? || ENV.empty?

      hash = Hash.new

      ENV.each do |variable, value|
        separator = Config.env_separator
        prefix = (Config.env_prefix || Config.const_name).to_s
        
        new_keys = variable.to_s.split(separator)        
        prefix_array = prefix.split(separator)
        next if new_keys.shift(prefix_array.size) != prefix_array

        new_keys.map! { |key|
          case Config.env_converter
            when :downcase then
              key.downcase.to_sym
            when nil then
              key.to_sym
            else
              raise "Invalid ENV variables name converter: #{Config.env_converter}"
          end
        }

        # split the environment variable name based on the keys we have in our config
        transformed_keys = __lookup_keys(new_keys, separator)
        if transformed_keys.length > 0
          new_keys = transformed_keys
        end
        
        leaf = new_keys[0...-1].inject(hash) { |h, key|
          h[key] ||= {}
        }

        leaf[new_keys.last] = Config.env_parse_values ? __value(value) : value
      end

      merge!(hash)
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
          DeepMerge.deep_merge!(
                                source_conf,
                                conf,
                                preserve_unmergeables: false,
                                knockout_prefix:       Config.knockout_prefix,
                                overwrite_arrays:      Config.overwrite_arrays,
                                merge_nil_values:      Config.merge_nil_values,
                                merge_hash_arrays:     Config.merge_hash_arrays
                               )
        end
      end

      # swap out the contents of the OStruct with a hash (need to recursively convert)
      marshal_load(__convert(conf).marshal_dump)

      reload_env! if Config.use_env
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
      marshal_dump.each do |k, v|
        if v.instance_of? Config::Options
          result[k] = v.to_hash
        elsif v.instance_of? Array
          result[k] = descend_array(v)
        else
          result[k] = v
        end
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

    def merge!(hash)
      current = to_hash
      DeepMerge.deep_merge!(
                            hash.dup,
                            current,
                            preserve_unmergeables: false,
                            knockout_prefix:       Config.knockout_prefix,
                            overwrite_arrays:      Config.overwrite_arrays,
                            merge_nil_values:      Config.merge_nil_values,
                            merge_hash_arrays:     Config.merge_hash_arrays
                           )
      marshal_load(__convert(current).marshal_dump)
      self
    end

    # Some keywords that don't play nicely with OpenStruct
    SETTINGS_RESERVED_NAMES = %w[select collect test count zip min max].freeze

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

    def descend_array(array)
      array.map do |value|
        if value.instance_of? Config::Options
          value.to_hash
        elsif value.instance_of? Array
          descend_array(value)
        else
          value
        end
      end
    end

    # Recursively converts Hashes to Options (including Hashes inside Arrays)
    def __convert(h) #:nodoc:
      s = self.class.new

      h.each do |k, v|
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

    # Try to convert string to a correct type
    def __value(v)
      case v
      when 'false'
        false
      when 'true'
        true
      else
        Integer(v) rescue Float(v) rescue v
      end
    end

    def __lookup_keys(source_keys, separator, found_keys = [])
      # if we've got no source keys, we must have got to the end of our search
      return found_keys if source_keys.nil? || source_keys.length == 0

      # To allow us to prefix keys with the same seperation character that exists in the config key, we need to search for the keys
      lookup_key = nil
      lookup_config = marshal_dump
      # if we've passed in some found keys, we want to get the config keys from the appropriate level in our config
      found_keys.each do |k|
        lookup_config = lookup_config[k]
      end

      # we can find a config entry for the keys that have been found, so return what we have so they can be created
      return found_keys if lookup_config.nil?

      config_keys = lookup_config.keys

      search_keys = source_keys.dup
      (0..(search_keys.length - 1)).each do
        lookup_key = config_keys.find{|k| k.to_sym == search_keys.join(separator).to_sym }
        break if !lookup_key.nil?
        
        search_keys.pop
      end
        
      found_keys ||= []
      if !lookup_key.nil?
        # we've found a key in our config that matches our env key, store this, and look inside this for the rest
        found_keys << lookup_key
        # get the new search keys
        # do this by taking the original environment variable keys, and removing the key we've found in our config
        env_key = source_keys.join(separator)
        # replace "our_key_" first, then "our_key"
        # leaving us with the remaining keys to search
        env_key = env_key.gsub(lookup_key.to_s + separator, "").gsub(lookup_key.to_s, "") 
        search_keys = env_key.split(separator)
        
        # call the same function again to get the next config key
        found_keys = __lookup_keys(search_keys, separator, found_keys)
      end
      found_keys
    end
  end
end
