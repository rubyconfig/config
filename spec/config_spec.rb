require 'spec_helper'

describe Config do
  it "should get setting files" do
    config = Config.setting_files("root/config", "test")
    expect(config).to eq([
                             'root/config/settings.yml',
                             'root/config/settings/test.yml',
                             'root/config/environments/test.yml',
                             'root/config/settings.local.yml',
                             'root/config/settings/test.local.yml',
                             'root/config/environments/test.local.yml'
                         ])
  end

  it "should load a basic config file" do
    config = Config.load_files("#{fixture_path}/settings.yml")
    expect(config.size).to eq(1)
    expect(config.server).to eq("google.com")
    expect(config['1']).to eq('one')
    expect(config.photo_sizes.avatar).to eq([60, 60])
    expect(config.root['yahoo.com']).to eq(2)
    expect(config.root['google.com']).to eq(3)
  end

  it "should load 2 basic config files" do
    config = Config.load_files("#{fixture_path}/settings.yml", "#{fixture_path}/settings2.yml")
    expect(config.size).to eq(1)
    expect(config.server).to eq("google.com")
    expect(config.another).to eq("something")
  end

  it "should load empty config for a missing file path" do
    config = Config.load_files("#{fixture_path}/some_file_that_doesnt_exist.yml")
    expect(config).to be_empty
  end

  it "should load an empty config for multiple missing file paths" do
    files  = ["#{fixture_path}/doesnt_exist1.yml", "#{fixture_path}/doesnt_exist2.yml"]
    config = Config.load_files(files)
    expect(config).to be_empty
  end

  it "should load empty config for an empty setting file" do
    config = Config.load_files("#{fixture_path}/empty1.yml")
    expect(config).to be_empty
  end

  it "should convert to a hash" do
    config = Config.load_files("#{fixture_path}/development.yml").to_hash
    expect(config[:section][:servers]).to be_kind_of(Array)
    expect(config[:section][:servers][0][:name]).to eq("yahoo.com")
    expect(config[:section][:servers][1][:name]).to eq("amazon.com")
  end

  it "should convert to a hash (We Need To Go Deeper)" do
    config = Config.load_files("#{fixture_path}/development.yml").to_hash
    servers = config[:section][:servers]
    expect(servers).to eq([ { name: "yahoo.com" }, { name: "amazon.com" } ])
  end

  it "should convert to a json" do
    config = Config.load_files("#{fixture_path}/development.yml").to_json
    expect(JSON.parse(config)["section"]["servers"]).to be_kind_of(Array)
  end

  it "should load an empty config for multiple missing file paths" do
    files  = ["#{fixture_path}/empty1.yml", "#{fixture_path}/empty2.yml"]
    config = Config.load_files(files)
    expect(config).to be_empty
  end

  it "should allow overrides" do
    files  = ["#{fixture_path}/settings.yml", "#{fixture_path}/development.yml"]
    config = Config.load_files(files)
    expect(config.server).to eq("google.com")
    expect(config.size).to eq(2)
  end

  it "should allow full reload of the settings files" do
    files = ["#{fixture_path}/settings.yml"]
    Config.load_and_set_settings(files)
    expect(Settings.server).to eq("google.com")
    expect(Settings.size).to eq(1)

    files = ["#{fixture_path}/settings.yml", "#{fixture_path}/development.yml"]
    Settings.reload_from_files(files)
    expect(Settings.server).to eq("google.com")
    expect(Settings.size).to eq(2)
  end

  context "ENV variables" do
    let(:config) do
      Config.load_files("#{fixture_path}/settings.yml")
    end

    before :all do
      load_env("#{fixture_path}/env/settings.yml")
      Config.use_env = true
    end

    after :all do
      Config.use_env = false
    end

    it "should load basic ENV variables" do
      config.load_env!
      expect(config.test_var).to eq("123")
    end

    it "should load nested sections" do
      config.load_env!
      expect(config.hash_test.one).to eq("1-1")
    end

    it "should override settings from files" do
      Config.load_and_set_settings ["#{fixture_path}/settings.yml"]
      expect(Settings.server).to eq("google.com")
      expect(Settings.size).to eq("3")
    end

    it "should reload env" do
      Config.load_and_set_settings ["#{fixture_path}/settings.yml"]
      Config.reload!
      expect(Settings.server).to eq("google.com")
      expect(Settings.size).to eq("3")
    end
  end

  context "Nested Settings" do
    let(:config) do
      Config.load_files("#{fixture_path}/development.yml")
    end

    it "should allow nested sections" do
      expect(config.section.size).to eq(3)
    end

    it "should allow configuration collections (arrays)" do
      expect(config.section.servers[0].name).to eq("yahoo.com")
      expect(config.section.servers[1].name).to eq("amazon.com")
    end
  end

  context "Settings with ERB tags" do
    let(:config) do
      Config.load_files("#{fixture_path}/with_erb.yml")
    end

    it "should evaluate ERB tags" do
      expect(config.computed).to eq(6)
    end

    it "should evaluated nested ERB tags" do
      expect(config.section.computed1).to eq(1)
      expect(config.section.computed2).to eq(2)
    end
  end

  context "Deep Merging" do
    let(:config) do
      files = ["#{fixture_path}/deep_merge/config1.yml", "#{fixture_path}/deep_merge/config2.yml"]
      Config.load_files(files)
    end

    it "should merge hashes from multiple configs" do
      expect(config.inner.marshal_dump.keys.size).to eq(3)
      expect(config.inner2.inner2_inner.marshal_dump.keys.size).to eq(3)
    end

    it "should merge arrays from multiple configs" do
      expect(config.arraylist1.size).to eq(6)
      expect(config.arraylist2.inner.size).to eq(6)
    end
  end

  context "Boolean Overrides" do
    let(:config) do
      files = ["#{fixture_path}/bool_override/config1.yml", "#{fixture_path}/bool_override/config2.yml"]
      Config.load_files(files)
    end

    it "should allow overriding of bool settings" do
      expect(config.override_bool).to eq(false)
      expect(config.override_bool_opposite).to eq(true)
    end
  end

  context "Custom Configuration" do
    it "should have the default settings constant as 'Settings'" do
      expect(Config.const_name).to eq("Settings")
    end

    it "should be able to assign a different settings constant" do
      Config.setup { |config| config.const_name = "Settings2" }
      expect(Config.const_name).to eq("Settings2")
    end
  end

  context "Settings with a type value of 'hash'" do
    let(:config) do
      files = ["#{fixture_path}/custom_types/hash.yml"]
      Config.load_files(files)
    end

    it "should turn that setting into a Real Hash" do
      expect(config.prices).to be_kind_of(Hash)
    end

    it "should map the hash values correctly" do
      expect(config.prices[1]).to eq(2.99)
      expect(config.prices[5]).to eq(9.99)
      expect(config.prices[15]).to eq(19.99)
      expect(config.prices[30]).to eq(29.99)
    end
  end

  context "Merging hash at runtime" do
    let(:config) { Config.load_files("#{fixture_path}/settings.yml") }
    let(:hash) { { :options => { :suboption => 'value' }, :server => 'amazon.com' } }

    it 'should be chainable' do
      expect(config.merge!({})).to eq(config)
    end

    it 'should preserve existing keys' do
      expect { config.merge!({}) }.to_not change { config.keys }
    end

    it 'should recursively merge keys' do
      config.merge!(hash)
      expect(config.options.suboption).to eq('value')
    end

    it 'should rewrite a merged value' do
      expect { config.merge!(hash) }.to change { config.server }.from('google.com').to('amazon.com')
    end
  end

  context "Merging nested hash at runtime" do
    let(:config) { Config.load_files("#{fixture_path}/deep_merge/config1.yml") }
    let(:hash) { { :inner => { :something1 => 'changed1', :something3 => 'changed3' } } }

    it 'should preserve first level keys' do
      expect { config.merge!(hash) }.to_not change { config.keys }
    end

    it 'should preserve nested key' do
      config.merge!(hash)
      expect(config.inner.something2).to eq('blah2')
    end

    it 'should add new nested key' do
      expect { config.merge!(hash) }.to change { config.inner.something3 }.from(nil).to("changed3")
    end

    it 'should rewrite a merged value' do
      expect { config.merge!(hash) }.to change { config.inner.something1 }.from('blah1').to('changed1')
    end
  end

  context "[] accessors" do
    let(:config) do
      files = ["#{fixture_path}/development.yml"]
      Config.load_files(files)
    end

    it "should access attributes using []" do
      expect(config.section['size']).to eq(3)
      expect(config.section[:size]).to eq(3)
      expect(config[:section][:size]).to eq(3)
    end

    it "should set values using []=" do
      config.section[:foo] = 'bar'
      expect(config.section.foo).to eq('bar')
    end
  end

  context "enumerable" do
    let(:config) do
      files = ["#{fixture_path}/development.yml"]
      Config.load_files(files)
    end

    it "should enumerate top level parameters" do
      keys = []
      config.each { |key, value| keys << key }
      expect(keys).to eq([:size, :section])
    end

    it "should enumerate inner parameters" do
      keys = []
      config.section.each { |key, value| keys << key }
      expect(keys).to eq([:size, :servers])
    end

    it "should have methods defined by Enumerable" do
      expect(config.map { |key, value| key }).to eq([:size, :section])
    end
  end

  context "keys" do
    let(:config) do
      files = ["#{fixture_path}/development.yml"]
      Config.load_files(files)
    end

    it "should return array of keys" do
      expect(config.keys).to contain_exactly(:size, :section)
    end

    it "should return array of keys for nested entry" do
      expect(config.section.keys).to contain_exactly(:size, :servers)
    end
  end
end
