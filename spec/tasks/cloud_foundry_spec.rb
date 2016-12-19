require 'spec_helper'

describe 'config:cf' do
  include_context 'rake'
  let(:test_settings_file) { "#{fixture_path}/cf/config/settings/multilevel_settings.yml" }
  let(:test_manifest_file) { "#{fixture_path}/cf/cf_manifest.yml" }
  let(:development_settings_file) { "#{fixture_path}/development.yml" }
  let(:settings_dir) { Rails.root.join('config', 'settings') }

  def setup_temp_rails_root
    allow(Rails).to receive(:root).and_return(Pathname.new Dir.mktmpdir)
  end

  before :all do
    load File.expand_path('../../../lib/config/tasks/cloud_foundry.rake', __FILE__)
    Rake::Task.define_task(:environment)
  end

  before { allow($stdout).to receive(:puts) } # suppressing console output during testing

  after :all do
    Settings.reload_from_files("#{fixture_path}/settings.yml")
  end

  it 'raises an error if the manifest file is missing' do
    expect {
      Rake::Task['config:cf'].execute
    }.to raise_error(SystemCallError)
  end

  it 'raises an error if the settings file is missing' do
    expect {
      Rake::Task['config:cf'].execute({target_env: 'not_existing_env', file_path: 'manifest.yml'})
    }.to raise_error(SystemCallError)
  end

  describe 'without arguments' do
    it 'creates the merged manifest file with the settings ENV variables included for all cf applications' do
      setup_temp_rails_root
      settings_dir.mkpath
      FileUtils.cp(test_settings_file, settings_dir.join('test.yml'))
      FileUtils.cp(test_manifest_file, Rails.root.join('manifest.yml'))

      Rake::Task['config:cf'].execute

      merged_manifest_file = File.join(Rails.root, 'manifest-merged.yml')
      merged_manifest_file_contents = YAML.load(IO.read(merged_manifest_file))

      expect(merged_manifest_file_contents['applications'][0]['name']).to eq 'some-cf-app'
      expect(merged_manifest_file_contents['applications'][0]['env']['DEFAULT_HOST']).to eq 'host'
      expect(merged_manifest_file_contents['applications'][0]['env']['Settings.world.array.0.name']).to eq 'Alan'

      expect(merged_manifest_file_contents['applications'][1]['name']).to eq 'app_name'
      expect(merged_manifest_file_contents['applications'][1]['env']['Settings.world.array.0.name']).to eq 'Alan'
    end
  end

  describe 'with arguments' do
    it 'raises an error if only one argument is provided' do
      expect {
        Rake::Task['config:cf'].execute({target_env:'target_env_name'})
      }.to raise_error(ArgumentError)
    end

    it 'takes in account the provided arguments' do
      setup_temp_rails_root
      settings_dir.mkpath
      FileUtils.cp(test_manifest_file, Rails.root.join('cf_manifest.yml'))
      FileUtils.cp(development_settings_file, settings_dir.join('development.yml'))
      FileUtils.cp(test_settings_file, settings_dir.join('test.yml'))

      Rake::Task['config:cf'].execute({target_env: 'development', file_path: 'cf_manifest.yml'})

      merged_manifest_file = File.join(Rails.root, 'cf_manifest-merged.yml')
      merged_manifest_file_contents = YAML.load(IO.read(merged_manifest_file))

      expect(merged_manifest_file_contents['applications'][0]['env']['Settings.size']).to eq 2
    end
  end
end