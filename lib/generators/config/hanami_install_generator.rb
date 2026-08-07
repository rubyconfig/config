module Config
  module Generators
    class HanamiInstallGenerator < ::Hanami::CLI::Commands::Command
      requires "environment"

      desc "Generates a custom Hanami Config initializer file."

      def call(*)
        files.cp File.expand_path("../templates/config.rb", __FILE__), ::Hanami.root.join("config/initializers/config.rb")
        files.cp File.expand_path("../templates/settings.yml", __FILE__), ::Hanami.root.join("config/settings.yml")
        files.cp File.expand_path("../templates/settings.local.yml", __FILE__), ::Hanami.root.join("config/settings.local.yml")
        FileUtils.cp_r File.expand_path("../templates/settings", __FILE__), ::Hanami.root.join("config/settings")
      end
    end
  end
end

::Hanami::CLI.register "generate config", Config::Generators::HanamiInstallGenerator
