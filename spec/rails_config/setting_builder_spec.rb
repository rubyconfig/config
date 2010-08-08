require 'spec_helper'

module RailsConfig
  describe SettingBuilder do

    it "should load a basic config file" do
      config = SettingBuilder.load_files(setting_path("settings.yml"))
      config.size.should == 1
      config.server.should == "google.com"
    end

    it "should load empty config for a missing file path" do
      config = SettingBuilder.load_files(setting_path("some_file_that_doesnt_exist.yml"))
      config.should == OpenStruct.new
    end

    it "should load an empty config for multiple missing file paths" do
      files = [setting_path("doesnt_exist1.yml"), setting_path("doesnt_exist2.yml")]
      config = SettingBuilder.load_files(files)
      config.should == OpenStruct.new
    end

    it "should load empty config for an empty setting file" do
      config = SettingBuilder.load_files(setting_path("empty1.yml"))
      config.should == OpenStruct.new
    end

    it "should load an empty config for multiple missing file paths" do
      files = [setting_path("empty1.yml"), setting_path("empty2.yml")]
      config = SettingBuilder.load_files(files)
      config.should == OpenStruct.new
    end

    it "should allow overrides" do
      files = [setting_path("settings.yml"), setting_path("development.yml")]
      config = SettingBuilder.load_files(files)
      config.server.should == "google.com"
      config.size.should == 2
    end

    context "Nested Settings" do
      let(:config) do
        SettingBuilder.load_files(setting_path("development.yml"))
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
        SettingBuilder.load_files(setting_path("with_erb.yml"))
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
        SettingBuilder.load_files(files)
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
        SettingBuilder.load_files(files)
      end

      it "should allow overriding of bool settings" do
        config.override_bool.should == false
        config.override_bool_opposite.should == true
      end
    end


  end
end