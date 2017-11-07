require 'spec_helper'

describe 'db:create', :rails do
  before do
    require 'rake'
    load 'rails/tasks/engine.rake'
  end

  it 'has access to Settings object and can read databases from settings.yml file' do
    Rake::Task['db:create'].invoke
  end
end