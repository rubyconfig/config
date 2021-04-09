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
        if @path and File.exist?(@path)
          file_contents = IO.read(@path)
          file_contents = ERB.new(file_contents).result if Config.evaluate_erb_in_yaml
          result = YAML.load(file_contents)
        end

        result || {}

        rescue Psych::SyntaxError => e
          raise "YAML syntax error occurred while parsing #{@path}. " \
                "Please note that YAML must be consistently indented using spaces. Tabs are not allowed. " \
                "Error: #{e.message}"
      end
    end
  end
end
