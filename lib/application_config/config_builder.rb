require 'ostruct'
require 'yaml'
require 'erb'

module ApplicationConfig
  # == Summary
  # This is API documentation, NOT documentation on how to use this plugin.  For that, see the README.
  class ConfigBuilder
    @@load_paths = []
    @@expand_keys = []
    @@root_path = ""
  
    # Create a config object (OpenStruct) from a yaml file.  If a second yaml file is given, then the sections of that file will overwrite the sections
    # if the first file if they exist in the first file.
    def self.load_files(options = {})
      config = OpenStruct.new
      
      @@load_paths = [options[:paths]].flatten.compact.uniq
      @@expand_keys = [options[:expand_keys]].flatten.compact.uniq
      @@root_path = options[:root_path]
      
      # add singleton method to our AppConfig that reloads its settings from the load_paths options
      def config.reload!
        
        conf = {}
        ConfigBuilder.load_paths.to_a.each do |path|
          file_conf = YAML.load(ERB.new(IO.read(path)).result) if path and File.exists?(path)
          DeepMerge.deep_merge!(file_conf, conf) if file_conf
        end
        
        # expand the javascripts config to handle *.* paths
        ConfigBuilder.expand_keys.to_a.each do |expand_path|
          expand_path = expand_path.to_s
          if conf[expand_path]
            conf[expand_path] = ApplicationConfig::ConfigBuilder.expand(conf[expand_path], "#{ConfigBuilder.root_path}/public/#{expand_path}")
          end
        end
        
        # load all the new values into the openstruct
        marshal_load(ApplicationConfig::ConfigBuilder.convert(conf).marshal_dump)
        
        return self
      end

      config.reload!
      return config
    end
    
    def self.load_paths
      @@load_paths
    end

    def self.expand_keys
      @@expand_keys
    end

    def self.root_path
      @@root_path
    end
  
    # Recursively converts Hashes to OpenStructs (including Hashes inside Arrays)
    def self.convert(h) #:nodoc:
      s = OpenStruct.new
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
    
    # expand a config val
    def self.expand(config, base_path)
      case config.class.to_s
      when "Hash"
        return expand_hash(config, base_path)
      when "Array"
        return expand_array(config, base_path)
      when "String"
        return expand_string(config, base_path)
      end      
      return config
    end
    
    # expand a string and returns a list
    def self.expand_string(config, base_path)
      # puts "Expanding String: #{config.inspect}"
      if config.include?("*")
        results = Dir["#{base_path}/#{config}"].map{|i| i.to_s.gsub("#{base_path}/", "") }

        # puts "EXPANDED PATH: #{base_path}/#{config}"
        # puts results.inspect        
        return results
      else
        return config
      end
    end
    
    # expand a hash by cycling throw all the hash values
    def self.expand_hash(config, base_path)
      # puts "Expanding Hash: #{config.inspect}"
      new_config = {}
      config.each do |key, val|
        new_config[key] = expand(val, base_path)
      end
      return new_config
    end
    
    # expand an array by cycling through all the values
    def self.expand_array(config, base_path)
      # puts "Expanding Array: #{config.inspect}"
      new_config = []
      config.each do |val|
        new_val = expand(val, base_path)
        if new_val.is_a?(Array)
          new_val.each do |inner|
            new_config << inner
          end
        else
          new_config << new_val
        end
      end
      return new_config.uniq
    end
    
    # Cycles through the array of single element hashes
    # and deep merges any duplicates it finds
    # 
    # This is needed so you can define stylesheet keys
    # in multiple config files
    def self.merge_assets(list)
      assets = Array(list).map do |i|
        if i.is_a?(OpenStruct)
          i.marshal_dump
        else
          i
        end
      end
      
      # filter out the duplicate single hash keys
      hash_keys = assets.select{|i| i.is_a?(Hash) and i.keys.size == 1}.group_by{|i| i.keys[0]}
      hash_keys.each do |key, value|
        if Array(value).size > 1
          merged = value.inject({}){|merged, v| DeepMerge.deep_merge!(v,merged)}
          value[0].replace(merged)
          value[1..-1].each do |v|
            v.clear
          end
        end
      end
      
      assets.select{|i| !i.blank? }
    end
    
  end
end