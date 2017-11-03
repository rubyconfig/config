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

  context 'when fail_on_missing option' do
    before { Config.reset }

    context 'is set to true' do
      before { Config.setup { |cfg| cfg.fail_on_missing = true } }

      it 'should raise an error when accessing a missing key' do
        config = Config.load_files("#{fixture_path}/empty1.yml")

        expect { config.not_existing_method }.to raise_error(KeyError)
        expect { config[:not_existing_method] }.to raise_error(KeyError)
      end

      it 'should raise an error when accessing a removed key' do
        config = Config.load_files("#{fixture_path}/empty1.yml")

        config.tmp_existing = 1337
        expect(config.tmp_existing).to eq(1337)

        config.delete_field(:tmp_existing)
        expect { config.tmp_existing }.to raise_error(KeyError)
        expect { config[:tmp_existing] }.to raise_error(KeyError)
      end
    end

    context 'is set to false' do
      before { Config.setup { |cfg| cfg.fail_on_missing = false } }

      it 'should return nil when accessing a missing key' do
        config = Config.load_files("#{fixture_path}/empty1.yml")

        expect(config.not_existing_method).to eq(nil)
        expect(config[:not_existing_method]).to eq(nil)
      end
    end
  end

  context '#key? and #has_key? methods' do
    let(:config) {
      config = Config.load_files("#{fixture_path}/empty1.yml")
      config.existing = nil
      config.send('complex_value=', nil)
      config.send('even_more_complex_value==', nil)
      config.nested = Config.load_files("#{fixture_path}/empty2.yml")
      config.nested.existing = nil
      config
    }

    it 'should test if a value exists for a given key' do
      expect(config.key?(:not_existing)).to eq(false)
      expect(config.key?(:complex_value)).to eq(true)
      expect(config.key?('even_more_complex_value='.to_sym)).to eq(true)
      expect(config.key?(:nested)).to eq(true)
      expect(config.nested.key?(:not_existing)).to eq(false)
      expect(config.nested.key?(:existing)).to eq(true)
    end

    it 'should be sensible to key\'s class' do
      expect(config.key?(:existing)).to eq(true)
      expect(config.key?('existing')).to eq(false)
    end
  end
end
