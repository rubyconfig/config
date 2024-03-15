# frozen_string_literal: true

module Config
  module DryValidationRequirements
    VERSIONS = ['~> 1.0', '>= 1.0.0'].freeze

    def self.load_dry_validation!
      return if defined?(@load_dry_validation)

      begin
        require 'dry/validation/version'
        version = Gem::Version.new(Dry::Validation::VERSION)
        unless VERSIONS.all? { |req| Gem::Requirement.new(req).satisfied_by?(version) }
          raise LoadError
        end
      rescue LoadError
        raise ::Config::Error, 'Could not find a dry-validation version' \
          ' matching requirements' \
          " (#{VERSIONS.map(&:inspect) * ','})"
      end

      require 'dry/validation'
      @load_dry_validation = true
      nil
    end
  end
end
