require 'yaml'
require 'erb'

module Config
  module Sources
    class YAMLSource
      attr_accessor :path

      def initialize(path, namespace = nil)
        @path = path.to_s

        # Make sure @namespace is an array if it exists at all
        if namespace
          @namespace = namespace
          @namespace = [@namespace] unless @namespace.is_a?(Array)
        end
      end

      # returns a config hash from the YML file
      def load
        result = YAML.load(ERB.new(IO.read(@path)).result) if @path and File.exist?(@path)
        return {} unless result
        return result unless @namespace
        
        # Resolves namespacing multiple layers deep 
        # i.e. ['layer1', 'layer2'] comes out to {'layer1' => {'layer2' => content}}
        return @namespace.reverse.inject(result) { |a, n| { n => a } }
        

        rescue Psych::SyntaxError => e
          raise "YAML syntax error occurred while parsing #{@path}. " \
                "Please note that YAML must be consistently indented using spaces. Tabs are not allowed. " \
                "Error: #{e.message}"
      end
    end
  end
end
