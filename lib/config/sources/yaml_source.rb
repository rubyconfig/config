require 'yaml'
require 'erb'

module Config
  module Sources
    class YAMLSource
      attr_accessor :path
      attr_reader :evaluate_erb

      def initialize(path, evaluate_erb: Config.evaluate_erb_in_yaml)
        @path = path.to_s
        @evaluate_erb = !!evaluate_erb
      end

      # returns a config hash from the YML file
      def load
        if @path and File.exist?(@path)
          file_contents = IO.read(@path)
          file_contents = ERB.new(file_contents).result if evaluate_erb
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
