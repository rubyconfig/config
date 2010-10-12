require 'rails_config'
require 'pathname'
require 'bundler/setup'

def in_editor?
  ENV.has_key?('TM_MODE') || ENV.has_key?('EMACS') || ENV.has_key?('VIM')
end

RSpec.configure do |c|
  c.color_enabled = !in_editor?
  c.run_all_when_everything_filtered = true

  # setup fixtures path
  c.before(:all) do
    @fixture_path = Pathname.new(File.join(File.dirname(__FILE__), "/fixtures"))
    raise "Fixture folder not found: #{@fixture_path}" unless @fixture_path.directory?
  end

  # returns the file path of a fixture setting file
  def setting_path(filename)
    @fixture_path.join(filename)
  end

end

