require 'ostruct'
require 'yaml'
require 'erb'

# == Summary
# This is API documentation, NOT documentation on how to use this plugin.  For that, see the README.
module ApplicationConfig
  
  # Create a config object (OpenStruct) from a yaml file.  If a second yaml file is given, then the sections of that file will overwrite the sections
  # if the first file if they exist in the first file.
  def self.load_files(conf_path_1, conf_path_2 = nil)
  
    conf1 = YAML.load(ERB.new(IO.read(conf_path_1)).result) if conf_path_1 and File.exists?(conf_path_1)
    conf1 = {} if !conf1 or conf1.empty?
    
    conf2 = YAML.load(ERB.new(IO.read(conf_path_2)).result) if conf_path_2 and File.exists?(conf_path_2)
    conf2 = {} if !conf2 or conf2.empty?
    
    conf = conf1.merge(conf2)
    (!conf or conf.empty?) ? OpenStruct.new : convert(conf)
    
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