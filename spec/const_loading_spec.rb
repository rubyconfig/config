require "config"

RSpec.describe Config do
  let(:fixture_path) { File.expand_path('../fixtures', __FILE__) }
  context "Object::Settings defined" do
    it "should set Settings without throwing an error" do
      Object.const_set(:Settings, "foo")
      expect {
        Config.load_and_set_settings("#{fixture_path}/settings.yml")
      }.to_not raise_error
    end
  end
end
