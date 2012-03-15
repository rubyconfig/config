require 'spec_helper'

describe RailsConfig do

  it "should load a basic config file" do
    config = RailsConfig.load_files(setting_path("settings.yml"))
    config.size.should == 1
    config.server.should == "google.com"
  end

  it "should load 2 basic config files" do
    config = RailsConfig.load_files(setting_path("settings.yml"), setting_path("settings2.yml"))
    config.size.should == 1
    config.server.should == "google.com"
    config.another.should == "something"
  end

  it "should load empty config for a missing file path" do
    config = RailsConfig.load_files(setting_path("some_file_that_doesnt_exist.yml"))
    config.should be_empty
  end

  it "should load an empty config for multiple missing file paths" do
    files = [setting_path("doesnt_exist1.yml"), setting_path("doesnt_exist2.yml")]
    config = RailsConfig.load_files(files)
    config.should be_empty
  end

  it "should load empty config for an empty setting file" do
    config = RailsConfig.load_files(setting_path("empty1.yml"))
    config.should be_empty
  end

  it "should convert to a hash" do
    config = RailsConfig.load_files(setting_path("development.yml")).to_hash
    config[:section][:servers].should be_a_kind_of(Array)
  end

  it "should convert to a json" do
    config = RailsConfig.load_files(setting_path("development.yml")).to_json
    JSON.parse(config)["section"]["servers"].should be_a_kind_of(Array)
  end

  it "should load an empty config for multiple missing file paths" do
    files = [setting_path("empty1.yml"), setting_path("empty2.yml")]
    config = RailsConfig.load_files(files)
    config.should be_empty
  end

  it "should allow overrides" do
    files = [setting_path("settings.yml"), setting_path("development.yml")]
    config = RailsConfig.load_files(files)
    config.server.should == "google.com"
    config.size.should == 2
  end

  it "should allow full reload of the settings files" do
    files = [setting_path("settings.yml")]
    RailsConfig.load_and_set_settings(files)
    Settings.server.should == "google.com"
    Settings.size.should == 1

    files = [setting_path("settings.yml"), setting_path("development.yml")]
    Settings.reload_from_files(files)
    Settings.server.should == "google.com"
    Settings.size.should == 2
  end

  context "Nested Settings" do
    let(:config) do
      RailsConfig.load_files(setting_path("development.yml"))
    end

    it "should allow nested sections" do
      config.section.size.should == 3
    end

    it "should allow configuration collections (arrays)" do
      config.section.servers[0].name.should == "yahoo.com"
      config.section.servers[1].name.should == "amazon.com"
    end
  end

  context "Settings with ERB tags" do
    let(:config) do
      RailsConfig.load_files(setting_path("with_erb.yml"))
    end

    it "should evaluate ERB tags" do
      config.computed.should == 6
    end

    it "should evaluated nested ERB tags" do
      config.section.computed1.should == 1
      config.section.computed2.should == 2
    end
  end

  context "Deep Merging" do
    let(:config) do
      files = [setting_path("deep_merge/config1.yml"), setting_path("deep_merge/config2.yml")]
      RailsConfig.load_files(files)
    end

    it "should merge hashes from multiple configs" do
      config.inner.marshal_dump.keys.size.should == 3
      config.inner2.inner2_inner.marshal_dump.keys.size.should == 3
    end

    it "should merge arrays from multiple configs" do
      config.arraylist1.size.should == 6
      config.arraylist2.inner.size.should == 6
    end
  end

  context "Boolean Overrides" do
    let(:config) do
      files = [setting_path("bool_override/config1.yml"), setting_path("bool_override/config2.yml")]
      RailsConfig.load_files(files)
    end

    it "should allow overriding of bool settings" do
      config.override_bool.should == false
      config.override_bool_opposite.should == true
    end
  end

  context "Custom Configuration" do
    it "should have the default settings constant as 'Settings'" do
      RailsConfig.const_name.should == "Settings"
    end

    it "should be able to assign a different settings constant" do
      RailsConfig.setup{ |config| config.const_name = "Settings2" }
      RailsConfig.const_name.should == "Settings2"
    end
  end

  context "Settings with a type value of 'hash'" do
    let(:config) do
      files = [setting_path("custom_types/hash.yml")]
      RailsConfig.load_files(files)
    end

    it "should turn that setting into a Real Hash" do
      config.prices.should be_a(Hash)
    end

    it "should map the hash values correctly" do
      config.prices[1].should == 2.99
      config.prices[5].should == 9.99
      config.prices[15].should == 19.99
      config.prices[30].should == 29.99
    end
  end

  context "Merging hash at runtime" do
    let(:config) { RailsConfig.load_files(setting_path("settings.yml")) }
    let(:hash) { {:options => {:suboption => 'value'}} }
    
    it 'should be chainable' do
      config.merge!({}).should === config
    end
    
    it 'should preserve existing keys' do
      expect { config.merge!({}) }.to_not change{ config.keys }
    end
    
    it 'should recursively merge keys' do
      config.merge!(hash)
      config.options.suboption.should == 'value'
    end
  end
end