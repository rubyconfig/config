require 'spec_helper'

context 'when a non rails environment is set' do
  it 'should load a non rails environment file' do
    byebug
    expect(Settings.some_api.scheme).to eq 'https'
    expect(Settings.some_api.host).to eq 'some-non-rails-environment'
    expect(Settings.some_api.path).to eq '/some-path'
  end
end


