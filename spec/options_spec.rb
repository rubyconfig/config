require 'spec_helper'

describe Config::Options do

  context 'when Settings file is using keywords reserved for OpenStruct' do
    let(:config) do
      Config.load_files("#{fixture_path}/reserved_keywords.yml")
    end

    it 'should allow to access them via object member notation' do
      expect(config.select).to eq(123)
      expect(config.collect).to eq(456)
      expect(config.count).to eq(789)
    end

    it 'should allow to access them using [] operator' do
      expect(config['select']).to eq(123)
      expect(config['collect']).to eq(456)
      expect(config['count']).to eq(789)

      expect(config[:select]).to eq(123)
      expect(config[:collect]).to eq(456)
      expect(config[:count]).to eq(789)
    end
  end

  context 'adding sources' do
    let(:config) do
      Config.load_files("#{fixture_path}/settings.yml")
    end

    before do
      config.add_source!("#{fixture_path}/deep_merge2/config1.yml")
      config.reload!
    end

    it 'should still have the initial config' do
      expect(config['size']).to eq(1)
    end

    it 'should add keys from the added file' do
      expect(config['tvrage']['service_url']).to eq('http://services.tvrage.com')
    end

    context 'overwrite with YAML file' do
      before do
        config.add_source!("#{fixture_path}/deep_merge2/config2.yml")
        config.reload!
      end

      it 'should overwrite the previous values' do
        expect(config['tvrage']['service_url']).to eq('http://url2')
      end

    end

    context 'overwrite with Hash' do
      before do
        config.add_source!({tvrage: {service_url: 'http://url3'}})
        config.reload!
      end

      it 'should overwrite the previous values' do
        expect(config['tvrage']['service_url']).to eq('http://url3')
      end
    end
  end

  context 'prepending sources' do
    let(:config) do
      Config.load_files("#{fixture_path}/settings.yml")
    end

    before do
      config.prepend_source!("#{fixture_path}/deep_merge2/config1.yml")
      config.reload!
    end

    it 'should still have the initial config' do
      expect(config['size']).to eq(1)
    end

    it 'should add keys from the added file' do
      expect(config['tvrage']['service_url']).to eq('http://services.tvrage.com')
    end

    context 'be overwritten' do
      before do
        config.prepend_source!("#{fixture_path}/deep_merge2/config2.yml")
        config.reload!
      end

      it 'should overwrite the previous values' do
        expect(config['tvrage']['service_url']).to eq('http://services.tvrage.com')
      end
    end

    context 'source is a hash' do
      let(:hash_source) {
        { tvrage: { service_url: 'http://url3' }, meaning_of_life: 42 }
      }
      before do
        config.prepend_source!(hash_source)
        config.reload!
      end

      it 'should be overwriten by the following values' do
        expect(config['tvrage']['service_url']).to eq('http://services.tvrage.com')
      end

      it 'should set meaning of life' do
        expect(config['meaning_of_life']).to eq(42)
      end
    end
  end

end
