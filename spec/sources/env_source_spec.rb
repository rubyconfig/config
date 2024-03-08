require 'spec_helper'

module Config::Sources
  describe EnvSource do
    context 'configuration options' do
      before :each do
        Config.reset
        Config.env_prefix           = nil
        Config.env_separator        = '.'
        Config.env_converter        = :downcase
        Config.env_parse_values     = true
      end

      context 'default configuration' do
        it 'should use global prefix configuration by default' do
          Config.env_prefix = 'MY_CONFIG'

          source = EnvSource.new({ 'MY_CONFIG.ACTION_MAILER' => 'enabled' })
          results = source.load
          expect(results['action_mailer']).to eq('enabled')
        end

        it 'should use global separator configuration by default' do
          Config.env_separator = '__'

          source = EnvSource.new({ 'Settings__ACTION_MAILER__ENABLED' => 'yes' })
          results = source.load
          expect(results['action_mailer']['enabled']).to eq('yes')
        end

        it 'should use global converter configuration by default' do
          Config.env_converter = nil

          source = EnvSource.new({ 'Settings.ActionMailer.Enabled' => 'yes' })
          results = source.load
          expect(results['ActionMailer']['Enabled']).to eq('yes')
        end

        it 'should use global parse_values configuration by default' do
          Config.env_parse_values = false

          source = EnvSource.new({ 'Settings.ACTION_MAILER.ENABLED' => 'true' })
          results = source.load
          expect(results['action_mailer']['enabled']).to eq('true')
        end

        describe 'arrays' do
          let(:source) do
            Config.env_converter = nil
            EnvSource.new({
                            'Settings.SomeConfig.0.0' => 'value1',
                            'Settings.SomeConfig.0.1' => 'value2',
                            'Settings.SomeConfig.1.1' => 'value3',
                            'Settings.SomeConfig.1.2' => 'value4',
                            'Settings.MixedConfig.1.0' => 'value5',
                            'Settings.MixedConfig.1.1' => 'value6',
                            'Settings.MixedConfig.1.custom' => 'value7'
                          })
          end

          let(:results) { source.load }

          context 'when loading nested configurations' do
            it 'converts numeric-keyed hashes to arrays' do
              puts results.inspect
              expect(results['SomeConfig']).to be_an Array
              expect(results['SomeConfig'][0]).to be_an Array
              expect(results['SomeConfig'][0][0]).to eq('value1')
              expect(results['SomeConfig'][0][1]).to eq('value2')
            end

            it 'retains hashes for non-sequential numeric keys' do
              expect(results['SomeConfig'][1]).to be_a Hash
              expect(results['SomeConfig'][1]['1']).to eq('value3')
              expect(results['SomeConfig'][1]['2']).to eq('value4')
            end

            it 'retains hashes for mixed types' do
              expect(results['MixedConfig'][1]).to be_a Hash
              expect(results['MixedConfig'][1]['0']).to eq('value5')
              expect(results['MixedConfig'][1]['1']).to eq('value6')
              expect(results['MixedConfig'][1]['custom']).to eq('value7')
            end
          end
        end
      end

      context 'configuration overrides' do
        it 'should allow overriding prefix configuration' do
          source = EnvSource.new({ 'MY_CONFIG.ACTION_MAILER' => 'enabled' },
                                 prefix: 'MY_CONFIG')
          results = source.load
          expect(results['action_mailer']).to eq('enabled')
        end

        it 'should allow overriding separator configuration' do
          source = EnvSource.new({ 'Settings__ACTION_MAILER__ENABLED' => 'yes' },
                                 separator: '__')
          results = source.load
          expect(results['action_mailer']['enabled']).to eq('yes')
        end

        it 'should allow overriding converter configuration' do
          source = EnvSource.new({ 'Settings.ActionMailer.Enabled' => 'yes' },
                                 converter: nil)
          results = source.load
          expect(results['ActionMailer']['Enabled']).to eq('yes')
        end

        it 'should allow overriding parse_values configuration' do
          source = EnvSource.new({ 'Settings.ACTION_MAILER.ENABLED' => 'true' },
                                 parse_values: false)
          results = source.load
          expect(results['action_mailer']['enabled']).to eq('true')
        end
      end
    end
  end
end
