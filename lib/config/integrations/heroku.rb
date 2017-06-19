require 'bundler'

module Config
  module Integrations
    class Heroku < Struct.new(:app)
      def invoke
        puts 'Setting vars...'
        heroku_command = "config:set #{vars}"
        heroku(heroku_command)
        puts 'Vars set:'
        puts heroku_command
      end

      def vars
        # Load only local options to Heroku
        Config.load_and_set_settings(
            Rails.root.join("config", "settings.local.yml").to_s,
            Rails.root.join("config", "settings", "#{environment}.local.yml").to_s,
            Rails.root.join("config", "environments", "#{environment}.local.yml").to_s
        )

        out = ''
        dotted_hash = to_dotted_hash Kernel.const_get(Config.const_name).to_hash, {}, Config.const_name
        dotted_hash.each {|key, value| out += " #{key}=#{value} "}
        out
      end

      def environment
        heroku("run 'echo $RAILS_ENV'").chomp[/(\w+)\z/]
      end

      def heroku(command)
        with_app = app ? " --app #{app}" : ""
        `heroku #{command}#{with_app}`
      end

      def `(command)
        Bundler.with_clean_env { super }
      end

      def to_dotted_hash(source, target = {}, namespace = nil)
        prefix = "#{namespace}." if namespace
        case source
          when Hash
            source.each do |key, value|
              to_dotted_hash(value, target, "#{prefix}#{key}")
            end
          when Array
            source.each_with_index do |value, index|
              to_dotted_hash(value, target, "#{prefix}#{index}")
            end
          else
            target[namespace] = source
        end
        target
      end
    end
  end
end
