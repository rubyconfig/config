require 'spec_helper'

describe 'db:create', :rails do
  include_context 'rake'

  it 'has access to Settings object and can read databases from settings.yml file' do
    Rake::Task['db:create'].invoke
  end
end