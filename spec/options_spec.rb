require 'spec_helper'

describe RailsConfig::Options do

  context 'when Settings file is using keywords reserved for OpenStruct' do
    let(:config) do
      RailsConfig.load_files("#{fixture_path}/reserved_keywords.yml")
    end

    it 'should allow to access them via object member notation' do
      expect(config.select).to eq(123)
      expect(config.collect).to eq(456)
    end

    it 'should allow to access them using [] operator' do
      expect(config['select']).to eq(123)
      expect(config['collect']).to eq(456)

      expect(config[:select]).to eq(123)
      expect(config[:collect]).to eq(456)
    end
  end

end
