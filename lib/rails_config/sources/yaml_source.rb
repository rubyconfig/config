require 'yaml'
require 'erb'

module RailsConfig
  module Sources
    class YAMLSource

      attr_accessor :path

      def initialize(path)
        @path = path
      end

      # returns a config hash from the YML file
      def load
        if @path and File.exists?(@path.to_s)
          result = YAML.load(ERB.new(IO.read(@path.to_s)).result)
        end
        result || {}
      end

    end
  end
end