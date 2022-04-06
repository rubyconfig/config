##
# Config Fixture Helpers
#

module FixtureHelper
  FIXTURE_PATH = File.expand_path('../../fixtures', __FILE__)

  # Provide fixture path as same way as rspec-rails
  def fixture_path
    FIXTURE_PATH
  end
end
