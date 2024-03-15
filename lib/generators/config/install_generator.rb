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
        template "settings.yml", "config/#{Config.file_name}.yml"
        template "settings.local.yml", "config/#{Config.file_name}.local.yml"
        directory "settings", "config/#{Config.dir_name}"
      end

      def modify_gitignore
        create_file '.gitignore' unless File.exist? '.gitignore'

        append_to_file '.gitignore' do
          "\n"                                      +
          "config/#{Config.file_name}.local.yml\n"  +
          "config/#{Config.dir_name}/*.local.yml\n" +
          "config/environments/*.local.yml\n"
        end
      end
    end
  end
end
