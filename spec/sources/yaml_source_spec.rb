require 'spec_helper'

module Config::Sources
  describe YAMLSource do
    it "should take a path as initializer" do
      source = YAMLSource.new "somepath"
      expect(source.path).to eq("somepath")
    end

    context "basic yml file" do
      let(:source) do
        YAMLSource.new "#{fixture_path}/development.yml"
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

    context "yml file with erb tags" do
      let(:source) do
        YAMLSource.new("#{fixture_path}/with_erb.yml")
      end

      it "should properly evaluate the erb" do
        results = source.load
        expect(results["computed"]).to eq(6)
      end

      it "should properly evaluate the nested erb settings" do
        results = source.load
        expect(results["section"]["computed1"]).to eq(1)
        expect(results["section"]["computed2"]).to eq(2)
      end

      context "with malformed erb tags" do
        let(:source) do
          YAMLSource.new("#{fixture_path}/with_malformed_erb.yml")
        end

        it "should properly evaluate the erb" do
          expect {
            source.load
          }.to raise_error(SyntaxError)
        end
      end
    end

    context "yaml file with erb tags but erb disabled" do
      let(:source) do
        YAMLSource.new("#{fixture_path}/with_erb.yml", evaluate_erb: false)
      end

      it "should load the file and leave the erb without being evaluated" do
        results = source.load
        expect(results["computed"]).to eq("<%= 1 + 2 + 3 %>")
        expect(results["section"]["computed1"]).to eq("<%= \"1\" %>")
      end

      context "with global config" do
        let(:source) do
          YAMLSource.new("#{fixture_path}/with_erb.yml")
        end

        around do |example|
          original_evaluate_erb_in_yaml = Config.evaluate_erb_in_yaml
          Config.evaluate_erb_in_yaml = false
          example.run
          Config.evaluate_erb_in_yaml = original_evaluate_erb_in_yaml
        end

        it "should load the file and leave the erb without being evaluated" do
          results = source.load
          expect(results["computed"]).to eq("<%= 1 + 2 + 3 %>")
          expect(results["section"]["computed1"]).to eq("<%= \"1\" %>")
        end
      end

      context "with malformed erb tags" do
        let(:source) do
          YAMLSource.new("#{fixture_path}/with_malformed_erb.yml", evaluate_erb: false)
        end

        it "should properly evaluate the erb" do
          expect {
            results = source.load
            expect(results["malformed_erb"]).to eq("<%= = %>")
          }.to_not raise_error
        end
      end
    end

    context "missing yml file" do
      let(:source) do
        YAMLSource.new "somewhere_that_doesnt_exist.yml"
      end

      it "should return an empty hash" do
        results = source.load
        expect(results).to eq({})
      end
    end

    context "blank yml file" do
      let(:source) do
        YAMLSource.new "#{fixture_path}/empty1.yml"
      end

      it "should return an empty hash" do
        results = source.load
        expect(results).to eq({})
      end
    end

    context "malformed yml file" do
      let(:source) do
        YAMLSource.new "#{fixture_path}/malformed.yml"
      end

      it "should raise an useful exception" do
        expect { source.load }.to raise_error(/malformed\.yml/)
      end
    end

    context "unsafe yml file" do
      let(:source) do
        YAMLSource.new "#{fixture_path}/unsafe_load.yml"
      end

      it "should load without any exception" do
        expect { source.load }.not_to raise_error
      end
    end
  end
end
