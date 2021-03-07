require 'spec_helper'

module Config::Sources
  describe HashSource do
    it "should take a hash as initializer" do
      source = HashSource.new(foo: 5)
      expect(source.hash).to eq(foo: 5)
    end

    context "basic hash" do
      let(:source) do
        example_hash = 
          {
            "size" => 2,
            "section" => {
              "size" => 3,
              "servers" => [ {"name" => "yahoo.com"}, {"name" => "amazon.com"} ]
            }
          }
        HashSource.new(example_hash)
      end

      it "should properly read the settings" do
        results = source.load
        expect(results["size"]).to eq(2)
      end

      it "should properly read nested settings" do
        results = source.load
        expect(results["section"]["size"]).to eq(3)
        expect(results["section"]["servers"]).to be_instance_of(Array)
        expect(results["section"]["servers"].size).to eq(2)
      end
    end

    context "basic hash with single namespace" do
      let(:source) do
        example_hash = 
          {
            "size" => 2,
            "section" => {
              "size" => 3,
              "servers" => [ {"name" => "yahoo.com"}, {"name" => "amazon.com"} ]
            }
          }
        HashSource.new(example_hash, 'test_namespace')
      end

      it "should properly read the settings" do
        results = source.load
        expect(results['test_namespace']["size"]).to eq(2)
      end

      it "should properly read nested settings" do
        results = source.load
        expect(results['test_namespace']["section"]["size"]).to eq(3)
        expect(results['test_namespace']["section"]["servers"]).to be_instance_of(Array)
        expect(results['test_namespace']["section"]["servers"].size).to eq(2)
      end
    end

    context "basic hash with nested namespace" do
      let(:source) do
        example_hash = 
          {
            "size" => 2,
            "section" => {
              "size" => 3,
              "servers" => [ {"name" => "yahoo.com"}, {"name" => "amazon.com"} ]
            }
          }
        HashSource.new(example_hash, ['test_namespace', 'test_layer_2'])
      end

      it "should properly read the settings" do
        results = source.load
        expect(results['test_namespace']['test_layer_2']["size"]).to eq(2)
      end

      it "should properly read nested settings" do
        results = source.load
        expect(results['test_namespace']['test_layer_2']["section"]["size"]).to eq(3)
        expect(results['test_namespace']['test_layer_2']["section"]["servers"]).to be_instance_of(Array)
        expect(results['test_namespace']['test_layer_2']["section"]["servers"].size).to eq(2)
      end
    end
    
    context "parameter is not a hash" do
      let(:source) do
        HashSource.new "hello world"
      end

      it "should return an empty hash" do
        results = source.load
        expect(results).to eq({})
      end
    end
  end
end
