require 'config/integrations/cloud_foundry'

namespace 'config' do

  desc 'Create a cf manifest with the env variables defined by config under current environment'
  task 'cf', [:target_env, :file_path] => [:environment] do |_, args|

    raise ArgumentError, 'Both target_env and file_path arguments must be specified' if args.length == 1

    default_args = {:target_env => Rails.env, :file_path => 'manifest.yml'}
    merged_args = default_args.merge(args)

    Config::Integrations::CloudFoundry.new(*merged_args.values).invoke
  end

end
