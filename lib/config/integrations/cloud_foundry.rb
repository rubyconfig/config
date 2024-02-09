require 'bundler'
require 'yaml'
require_relative '../../../lib/config/integrations/helpers/cf_manifest_merger'

module Config
  module Integrations
    class CloudFoundry < Struct.new(:target_env, :file_path)

      def invoke

        manifest_path = file_path
        file_name, _ext = manifest_path.split('.yml')

        manifest_hash = YAML.load(IO.read(File.join(::Rails.root, manifest_path)))

        puts "Generating manifest... (base cf manifest: #{manifest_path})"

        merged_hash = Config::CFManifestMerger.new(target_env, manifest_hash).add_to_env

        target_manifest_path = File.join(::Rails.root, "#{file_name}-merged.yml")
        IO.write(target_manifest_path, merged_hash.to_yaml)

        puts "File #{target_manifest_path} generated."
      end

    end
  end
end
