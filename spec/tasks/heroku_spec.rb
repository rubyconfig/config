require 'spec_helper'

describe 'config:heroku' do
  include_context 'rake'

  before do
    load File.expand_path("../../../lib/config/tasks/heroku.rake", __FILE__)
    Rake::Task.define_task(:environment)
  end

  it 'includes the helper module that defines to_dotted_hash' do
    h = Config::Integrations::Heroku.new
    expect(h.public_methods(:true)).to include(:to_dotted_hash)
  end
end