require 'spec_helper'

describe Config do

  context 'when overriding settings via ENV variables is enabled' do
    let(:config) do
      Config.load_files "#{fixture_path}/settings.yml", "#{fixture_path}/multilevel.yml"
    end

    before :all do
      Config.use_env = true
    end

    after :all do
      Config.use_env = false
    end

    before :each do
      ENV.clear

      Config.env_prefix       = nil
      Config.env_separator    = '.'
      Config.env_converter    = :downcase
      Config.env_parse_values = true
    end

    it 'should add new setting from ENV variable' do
      ENV['Settings.new_var'] = 'value'

      expect(config.new_var).to eq('value')
    end

    context 'should override existing setting with a value from ENV variable' do
      it 'for a basic values' do
        ENV['Settings.size'] = 'overwritten by env'

        expect(config.size).to eq('overwritten by env')
      end

      it 'for multilevel sections' do
        ENV['Settings.number_of_all_countries'] = '0'
        ENV['Settings.world.countries.europe']  = '0'

        expect(config.number_of_all_countries).to eq(0)
        expect(config.world.countries.europe).to eq(0)
        expect(config.world.countries.australia).to eq(1)
      end
    end

    context 'and parsing ENV variable names is enabled' do
      it 'should recognize "false" and expose as Boolean' do
        ENV['Settings.new_var'] = 'false'

        expect(config.new_var).to eq(false)
        expect(config.new_var.is_a? FalseClass).to eq(true)
      end

      it 'should recognize "true" and expose as Boolean' do
        ENV['Settings.new_var'] = 'true'

        expect(config.new_var).to eq(true)
        expect(config.new_var.is_a? TrueClass).to eq(true)
      end

      it 'should recognize numbers and expose them as integers' do
        ENV['Settings.new_var'] = '123'

        expect(config.new_var).to eq(123)
        expect(config.new_var.is_a? Integer).to eq(true)
      end

      it 'should recognize fixed point numbers and expose them as float' do
        ENV['Settings.new_var'] = '1.9'

        expect(config.new_var).to eq(1.9)
        expect(config.new_var.is_a? Float).to eq(true)
      end

      it 'should leave strings intact' do
        ENV['Settings.new_var'] = 'foobar'

        expect(config.new_var).to eq('foobar')
        expect(config.new_var.is_a? String).to eq(true)
      end
    end

    context 'and parsing ENV variable names is disabled' do
      it 'should not convert numbers to integers' do
        ENV['Settings.new_var'] = '123'

        Config.env_parse_values = false

        expect(config.new_var).to eq('123')
      end
    end

    context 'and custom ENV variables prefix is defined' do
      before :each do
        Config.env_prefix = 'MyConfig'
      end

      it 'should load variables from the new prefix' do
        ENV['MyConfig.new_var'] = 'value'

        expect(config.new_var).to eq('value')
      end

      it 'should not load variables from the default prefix' do
        ENV['Settings.new_var'] = 'value'

        expect(config.new_var).to eq(nil)
      end

      it 'should skip ENV variable when partial prefix match' do
        ENV['MyConfigs.new_var'] = 'value'

        expect(config.new_var).to eq(nil)
      end
    end

    context 'and custom ENV variables separator is defined' do
      before :each do
        Config.env_separator = '__'
      end

      it 'should load variables and correctly recognize the new separator' do
        ENV['Settings__new_var']                  = 'value'
        ENV['Settings__var.with.dot']             = 'value'
        ENV['Settings__world__countries__europe'] = '0'

        expect(config.new_var).to eq('value')
        expect(config['var.with.dot']).to eq('value')
        expect(config.world.countries.europe).to eq(0)
      end

      it 'should ignore variables wit default separator' do
        ENV['Settings.new_var'] = 'value'

        expect(config.new_var).to eq(nil)
      end
    end

    context 'and custom ENV variables prefix includes custom ENV variables separator' do
      before :each do
        Config.env_prefix = 'MY_CONFIG'
        Config.env_separator = '_'
      end

      it 'should load environment variables which begin with the custom prefix' do
        ENV['MY_CONFIG_KEY'] = 'value'

        expect(config.key).to eq('value')
      end

      it 'should not load environment variables which begin with the default prefix' do
        ENV['Settings_key'] = 'value'

        expect(config.key).to eq(nil)
      end

      it 'should not load environment variables which partially begin with the custom prefix' do
        ENV['MY_CONFIGS_KEY'] = 'value'

        expect(config.key).to eq(nil)
      end

      it 'should recognize the custom separator' do
        ENV['MY_CONFIG_KEY.WITH.DOT']           = 'value'
        ENV['MY_CONFIG_WORLD_COUNTRIES_EUROPE'] = '0'

        expect(config['key.with.dot']).to eq('value')
        expect(config.world.countries.europe).to eq(0)
      end

      it 'should not recognize the default separator' do
        ENV['MY_CONFIG.KEY'] = 'value'

        expect(config.key).to eq(nil)
      end
    end

    context 'and variable names conversion is enabled' do
      it 'should downcase variable names when :downcase conversion enabled' do
        ENV['Settings.NEW_VAR'] = 'value'

        expect(config.new_var).to eq('value')
      end
    end

    context 'and variable names conversion is disabled' do
      it 'should not change variable names by default' do
        ENV['Settings.NEW_VAR'] = 'value'

        Config.env_converter = nil

        expect(config.new_var).to eq(nil)
        expect(config.NEW_VAR).to eq('value')
      end
    end

    it 'should always load ENV variables when reloading settings from files' do
      ENV['Settings.new_var'] = 'value'

      expect(config.new_var).to eq('value')

      Config.reload!

      expect(config.new_var).to eq('value')
    end

  end
end
