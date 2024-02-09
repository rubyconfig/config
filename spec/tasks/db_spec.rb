require 'spec_helper'

describe 'db:create', :rails do
  include_context 'rake'

  before { allow($stdout).to receive(:puts) } # suppressing console output during testing

  it 'has access to Settings object and can read databases from settings.yml file' do
    Rake::Task['db:create'].invoke
  end
end