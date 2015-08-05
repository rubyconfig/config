module Config
  module Generators
    class InstallGenerator < ::Rails::Generators::Base
      desc "Generates a custom Rails Config initializer file."

      def self.source_root
        @_config_source_root ||= File.expand_path("../templates", __FILE__)
      end

      def copy_initializer
        template "config.rb", "config/initializers/config.rb"
      end

      def copy_settings
        template "settings.yml", "config/settings.yml"
        template "settings.local.yml", "config/settings.local.yml"
        directory "settings", "config/settings"
      end

      def modify_gitignore
        create_file '.gitignore' unless File.exists? '.gitignore'

        append_to_file '.gitignore' do
          "\n"                                +
          "config/settings.local.yml\n"       +
          "config/settings/*.local.yml\n"     +
          "config/environments/*.local.yml\n"
        end
      end
    end
  end
end
