require 'ostruct'
require 'yaml'
require 'erb'

module RailsConfig
  module SettingBuilder
    @@load_paths = []

    # Create a config object (OpenStruct) from a yaml file.  If a second yaml file is given, then the sections of that file will overwrite the sections
    # if the first file if they exist in the first file.
    def self.load_files(*files)
      config = OpenStruct.new

      @@load_paths = [files].flatten.compact.uniq
      # add singleton method to our Settings that reloads its settings from the load_paths
      def config.reload!

        conf = {}
        SettingBuilder.load_paths.to_a.each do |path|
          file_conf = YAML.load(ERB.new(IO.read(path.to_s)).result) if path and File.exists?(path.to_s)
          next unless file_conf

          if conf.size > 0
            DeepMerge.deep_merge!(file_conf, conf, :preserve_unmergeables => false)
          else
            conf = file_conf
          end
        end

        # load all the new values into the openstruct
        marshal_load(RailsConfig::SettingBuilder.convert(conf).marshal_dump)

        return self
      end

      config.reload!
      return config
    end

    def self.load_paths
      @@load_paths
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
  end
end