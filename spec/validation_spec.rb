require 'spec_helper'

describe Config do
  context 'validation' do
    around(:each) do |example|
      Config.reset
      example.run
      Config.reset
    end

    it 'should raise if schema is present and validation fails' do
      Config.setup do |config|
        config.schema do
          required(:youtube).schema do
            required(:nonexist_field).filled
            required(:multiple_requirements).filled(:integer, gt?: 18)
          end
        end
      end

      msg = "Config validation failed:\n\n"
      msg += "  youtube.nonexist_field: is missing\n"
      msg += '  youtube.multiple_requirements: must be an integer'

      expect { Config.load_files("#{fixture_path}/validation/config.yml") }.
        to raise_error(Config::Validation::Error, Regexp.new(msg))
    end

    it 'should work if validation passes' do
      Config.setup do |config|
        config.schema do
          required(:youtube).schema do
            required(:api_key).filled
          end
        end
      end

      expect { Config.load_files("#{fixture_path}/validation/config.yml") }.
        to_not raise_error
    end
  end
end
