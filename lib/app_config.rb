require 'ostruct'
require 'yaml'
require 'erb'

# == Summary
# This is API documentation, NOT documentation on how to use this plugin.  For that, see the README.
class ApplicationConfig
  
  cattr_accessor :conf_paths
  
  # Create a config object (OpenStruct) from a yaml file.  If a second yaml file is given, then the sections of that file will overwrite the sections
  # if the first file if they exist in the first file.
  def self.load_files(*conf_load_paths)
    self.conf_paths = []
    self.conf_paths += conf_load_paths
    self.conf_paths.uniq!
    
    reload!
  end
  
  def self.reload!
    conf = {}
    conf_paths.each do |path|
      new_conf = YAML.load(ERB.new(IO.read(path)).result) if path and File.exists?(path)
      conf.merge!(new_conf) if new_conf
    end
    return convert(conf)
  end
  
  # Recursively converts Hashes to OpenStructs (including Hashes inside Arrays)
  def self.convert(h) #:nodoc:
    s = OpenStruct.new
    h.each do |k, v|
      s.new_ostruct_member(k)
      if v.instance_of?(Hash)
        s.send( (k+'=').to_sym, convert(v))
      elsif v.instance_of?(Array)
        converted_array = v.collect { |e| e.instance_of?(Hash) ? convert(e) : e }
        s.send( (k+'=').to_sym, converted_array)
      else
        s.send( (k+'=').to_sym, v)
      end
    end
    s
  end

end