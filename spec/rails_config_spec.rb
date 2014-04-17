require 'spec_helper'

describe RailsConfig do

  it "should load a basic config file" do
    config = RailsConfig.load_files("#{fixture_path}/settings.yml")
    config.size.should eq 1
    config.server.should eq "google.com"
    config['1'].should eq 'one'
    config.photo_sizes.avatar.should eq [60, 60]
    config.root['yahoo.com'].should eq 2
    config.root['google.com'].should eq 3
  end

  it "should load 2 basic config files" do
    config = RailsConfig.load_files("#{fixture_path}/settings.yml", "#{fixture_path}/settings2.yml")
    config.size.should eq 1
    config.server.should eq "google.com"
    config.another.should eq "something"
  end

  it "should load empty config for a missing file path" do
    config = RailsConfig.load_files("#{fixture_path}/some_file_that_doesnt_exist.yml")
    config.should be_empty
  end

  it "should load an empty config for multiple missing file paths" do
    files = ["#{fixture_path}/doesnt_exist1.yml", "#{fixture_path}/doesnt_exist2.yml"]
    config = RailsConfig.load_files(files)
    config.should be_empty
  end

  it "should load empty config for an empty setting file" do
    config = RailsConfig.load_files("#{fixture_path}/empty1.yml")
    config.should be_empty
  end

  it "should convert to a hash" do
    config = RailsConfig.load_files("#{fixture_path}/development.yml").to_hash
    config[:section][:servers].should be_a_kind_of(Array)
  end

  it "should convert to a json" do
    config = RailsConfig.load_files("#{fixture_path}/development.yml").to_json
    JSON.parse(config)["section"]["servers"].should be_a_kind_of(Array)
  end

  it "should load an empty config for multiple missing file paths" do
    files = ["#{fixture_path}/empty1.yml", "#{fixture_path}/empty2.yml"]
    config = RailsConfig.load_files(files)
    config.should be_empty
  end

  it "should allow overrides" do
    files = ["#{fixture_path}/settings.yml", "#{fixture_path}/development.yml"]
    config = RailsConfig.load_files(files)
    config.server.should eq "google.com"
    config.size.should eq 2
  end

  it "should allow full reload of the settings files" do
    files = ["#{fixture_path}/settings.yml"]
    RailsConfig.load_and_set_settings(files)
    Settings.server.should eq "google.com"
    Settings.size.should eq 1

    files = ["#{fixture_path}/settings.yml", "#{fixture_path}/development.yml"]
    Settings.reload_from_files(files)
    Settings.server.should eq "google.com"
    Settings.size.should eq 2
  end

  context "ENV variables" do
    let(:config) do
      RailsConfig.load_files("#{fixture_path}/settings.yml")
    end

    before :all do
      load_env("#{fixture_path}/env/settings.yml")
      RailsConfig.use_env = true
    end

    after :all do
      RailsConfig.use_env = false
    end

    it "should load basic ENV variables" do
      config.load_env!
      config.test_var.should eq "123"
    end

    it "should load nested sections" do
      config.load_env!
      config.hash_test.one.should eq "1-1"
    end

    it "should override settings from files" do
      RailsConfig.load_and_set_settings ["#{fixture_path}/settings.yml"]

      Settings.server.should eq "google.com"
      Settings.size.should eq "3"
    end

    it "should reload env" do
      RailsConfig.load_and_set_settings ["#{fixture_path}/settings.yml"]
      RailsConfig.reload!

      Settings.server.should eq "google.com"
      Settings.size.should eq "3"
    end
  end

  context "Nested Settings" do
    let(:config) do
      RailsConfig.load_files("#{fixture_path}/development.yml")
    end

    it "should allow nested sections" do
      config.section.size.should eq 3
    end

    it "should allow configuration collections (arrays)" do
      config.section.servers[0].name.should eq "yahoo.com"
      config.section.servers[1].name.should eq "amazon.com"
    end
  end

  context "Settings with ERB tags" do
    let(:config) do
      RailsConfig.load_files("#{fixture_path}/with_erb.yml")
    end

    it "should evaluate ERB tags" do
      config.computed.should eq 6
    end

    it "should evaluated nested ERB tags" do
      config.section.computed1.should eq 1
      config.section.computed2.should eq 2
    end
  end

  context "Deep Merging" do
    let(:config) do
      files = ["#{fixture_path}/deep_merge/config1.yml", "#{fixture_path}/deep_merge/config2.yml"]
      RailsConfig.load_files(files)
    end

    it "should merge hashes from multiple configs" do
      config.inner.marshal_dump.keys.size.should eq 3
      config.inner2.inner2_inner.marshal_dump.keys.size.should eq 3
    end

    it "should merge arrays from multiple configs" do
      config.arraylist1.size.should eq 6
      config.arraylist2.inner.size.should eq 6
    end
  end

  context "Boolean Overrides" do
    let(:config) do
      files = ["#{fixture_path}/bool_override/config1.yml", "#{fixture_path}/bool_override/config2.yml"]
      RailsConfig.load_files(files)
    end

    it "should allow overriding of bool settings" do
      config.override_bool.should eq false
      config.override_bool_opposite.should eq true
    end
  end

  context "Custom Configuration" do
    it "should have the default settings constant as 'Settings'" do
      RailsConfig.const_name.should eq "Settings"
    end

    it "should be able to assign a different settings constant" do
      RailsConfig.setup{ |config| config.const_name = "Settings2" }
      RailsConfig.const_name.should eq "Settings2"
    end
  end

  context "Settings with a type value of 'hash'" do
    let(:config) do
      files = ["#{fixture_path}/custom_types/hash.yml"]
      RailsConfig.load_files(files)
    end

    it "should turn that setting into a Real Hash" do
      config.prices.should be_a(Hash)
    end

    it "should map the hash values correctly" do
      config.prices[1].should eq 2.99
      config.prices[5].should eq 9.99
      config.prices[15].should eq 19.99
      config.prices[30].should eq 29.99
    end
  end

  context "Merging hash at runtime" do
    let(:config) { RailsConfig.load_files("#{fixture_path}/settings.yml") }
    let(:hash) { {:options => {:suboption => 'value'}, :server => 'amazon.com'} }
    
    it 'should be chainable' do
      config.merge!({}).should eq config
    end
    
    it 'should preserve existing keys' do
      expect { config.merge!({}) }.to_not change{ config.keys }
    end
    
    it 'should recursively merge keys' do
      config.merge!(hash)
      config.options.suboption.should eq 'value'
    end
    
    it 'should rewrite a merged value' do
      expect { config.merge!(hash) }.to change{ config.server }.from('google.com').to('amazon.com')
    end
  end
  
  context "Merging nested hash at runtime" do
    let(:config) { RailsConfig.load_files("#{fixture_path}/deep_merge/config1.yml") }
    let(:hash) { {:inner => {:something1 => 'changed1', :something3 => 'changed3'} } }
    
    it 'should preserve first level keys' do
      expect { config.merge!(hash) }.to_not change{ config.keys }
    end
    
    it 'should preserve nested key' do
      config.merge!(hash)
      config.inner.something2.should eq 'blah2'
    end
    
    it 'should add new nested key' do
      expect { config.merge!(hash) }.to change { config.inner.something3 }.from(nil).to("changed3")
    end
    
    it 'should rewrite a merged value' do
      expect { config.merge!(hash) }.to change{ config.inner.something1 }.from('blah1').to('changed1')
    end
  end

  context "[] accessors" do
    let(:config) do
      files = ["#{fixture_path}/development.yml"]
      RailsConfig.load_files(files)
    end

    it "should access attributes using []" do
      config.section['size'].should eq 3
      config.section[:size].should eq 3
      config[:section][:size].should eq 3
    end

    it "should set values using []=" do
      config.section[:foo] = 'bar'
      config.section.foo.should eq 'bar'
    end
  end

  context "enumerable" do
    let(:config) do
      files = ["#{fixture_path}/development.yml"]
      RailsConfig.load_files(files)
    end

    it "should enumerate top level parameters" do
      keys = []
      config.each { |key, value| keys << key }
      keys.should eq [:size, :section]
    end

    it "should enumerate inner parameters" do
      keys = []
      config.section.each { |key, value| keys << key }
      keys.should eq [:size, :servers]
    end

    it "should have methods defined by Enumerable" do
      config.map { |key, value| key }.should eq [:size, :section]
    end
  end
end
