require_relative 'helpers'

module Config
  class CFManifestMerger
    include Integrations::Helpers

    def initialize(target_env, manifest_hash)
      @manifest_hash = manifest_hash.dup

      raise ArgumentError.new('Target environment & manifest path must be specified') unless target_env && @manifest_hash

      config_root = File.join(Rails.root, 'config')
      config_setting_files = Config.setting_files(config_root, target_env)
      @settings_hash = Config.load_files(config_setting_files).to_hash.stringify_keys
    end

    def add_to_env

      prefix_keys_with_const_name_hash = to_dotted_hash(@settings_hash, namespace: Config.const_name)

      apps = @manifest_hash['applications']

      apps.each do |app|
        check_conflicting_keys(app['env'], @settings_hash)
        app['env'].merge!(prefix_keys_with_const_name_hash)
      end

      @manifest_hash
    end

    private

    def check_conflicting_keys(env_hash, settings_hash)
      conflicting_keys = env_hash.keys & settings_hash.keys
      raise ArgumentError.new("Conflicting keys: #{conflicting_keys.join(', ')}") if conflicting_keys.any?
    end

  end
end