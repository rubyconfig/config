require 'spec_helper'
require_relative '../../../lib/config/integrations/helpers/cf_manifest_merger'

describe Config::CFManifestMerger do

  let(:mocked_rails_root_path) { "#{fixture_path}/cf/" }
  let(:manifest_hash) { load_manifest('cf_manifest.yml') }

  it 'raises an argument error if you do not specify a target environment' do
    expect {
      Config::CFManifestMerger.new(nil, manifest_hash)
    }.to raise_error(ArgumentError, 'Target environment & manifest path must be specified')
  end

  it 'returns the cf manifest unmodified if no settings are available' do
    merger = Config::CFManifestMerger.new('test', manifest_hash)

    resulting_hash = merger.add_to_env
    expect(resulting_hash).to eq(manifest_hash)
  end

  it 'adds the settings for the target_env to the manifest_hash' do
    allow(Rails).to receive(:root).and_return(mocked_rails_root_path)

    # we use the target_env to load the proper settings file
    merger = Config::CFManifestMerger.new('multilevel_settings', manifest_hash)

    resulting_hash = merger.add_to_env
    expect(resulting_hash).to eq({
                                     'applications' => [
                                         {
                                             'name' => 'some-cf-app',
                                             'instances' => 1,
                                             'env' => {
                                                 'DEFAULT_HOST' => 'host',
                                                 'DEFAULT_PORT' => 'port',
                                                 'FOO' => 'BAR',
                                                 'Settings.world.capitals.europe.germany' => 'Berlin',
                                                 'Settings.world.capitals.europe.poland' => 'Warsaw',
                                                 'Settings.world.array.0.name' => 'Alan',
                                                 'Settings.world.array.1.name' => 'Gam',
                                                 'Settings.world.array_with_index.0.name' => 'Bob',
                                                 'Settings.world.array_with_index.1.name' => 'William'
                                             }
                                         },
                                         {
                                             'name' => 'app_name',
                                             'env' => {
                                                 'DEFAULT_HOST' => 'host',
                                                 'Settings.world.capitals.europe.germany' => 'Berlin',
                                                 'Settings.world.capitals.europe.poland' => 'Warsaw',
                                                 'Settings.world.array.0.name' => 'Alan',
                                                 'Settings.world.array.1.name' => 'Gam',
                                                 'Settings.world.array_with_index.0.name' => 'Bob',
                                                 'Settings.world.array_with_index.1.name' => 'William'
                                             }
                                         }
                                     ]
                                 })
  end

  it 'raises an exception if there is conflicting keys' do
    allow(Rails).to receive(:root).and_return(mocked_rails_root_path)

    merger = Config::CFManifestMerger.new('conflict_settings', manifest_hash)

    # Config.load_and_set_settings "#{fixture_path}/cf/conflict_settings.yml"
    expect {
      merger.add_to_env
    }.to raise_error(ArgumentError, 'Conflicting keys: DEFAULT_HOST, DEFAULT_PORT')
  end

  def load_manifest filename
    YAML.load(IO.read("#{fixture_path}/cf/#{filename}"))
  end
end