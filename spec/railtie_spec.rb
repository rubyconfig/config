require 'spec_helper'

context 'when a the environment config is set' do
  it 'should load a file that matches that environment' do
    if defined?(::Rails)
      expect(RailtieSettings.some_api.scheme).to eq 'https'
      expect(RailtieSettings.some_api.host).to eq 'some-non-rails-environment'
      expect(RailtieSettings.some_api.path).to eq '/some-path'
    end
  end
end


