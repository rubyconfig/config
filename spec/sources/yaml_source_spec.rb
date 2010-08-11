require 'spec_helper'

module RailsConfig::Sources
  describe YAMLSource do

    it "should take a path as initializer" do
      source = YAMLSource.new "somepath"
      source.path.should == "somepath"
    end

    context "basic yml file" do
      let(:source) do
        YAMLSource.new setting_path("development.yml")
      end

      it "should properly read the settings" do
        results = source.load
        results["size"].should == 2
      end

      it "should properly read nested settings" do
        results = source.load
        results["section"]["size"].should == 3
        results["section"]["servers"].should be_an(Array)
        results["section"]["servers"].size.should == 2
      end
    end

    context "yml file with erb tags" do
      let(:source) do
        YAMLSource.new setting_path("with_erb.yml")
      end

      it "should properly evaluate the erb" do
        results = source.load
        results["computed"].should == 6
      end

      it "should properly evaluate the nested erb settings" do
        results = source.load
        results["section"]["computed1"].should == 1
        results["section"]["computed2"].should == 2
      end
    end

    context "missing yml file" do
      let(:source) do
        YAMLSource.new "somewhere_that_doesnt_exist.yml"
      end

      it "should return an empty hash" do
        results = source.load
        results.should == {}
      end
    end

    context "blank yml file" do
      let(:source) do
        YAMLSource.new setting_path("empty1.yml")
      end

      it "should return an empty hash" do
        results = source.load
        results.should == {}
      end
    end

  end
end