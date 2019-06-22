require 'yaml'
require 'erb'

module Config
  module Sources
    class YAMLSource
      attr_accessor :path

      def initialize(path)
        @path = path.to_s
      end

      # returns a config hash from the YML file
      def load
        result = YAML.load(ERB.new(IO.read(@path)).result) if @path and File.exist?(@path)

        result || {}

        rescue Psych::SyntaxError => e
          raise "YAML syntax error occurred while parsing #{@path}. " \
                "Please note that YAML must be consistently indented using spaces. Tabs are not allowed. " \
                "Error: #{e.message}"
      end
    end
  end
end
