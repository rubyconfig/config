require 'spec_helper'
require_relative '../../../lib/config/integrations/helpers/helpers'

describe 'Helpers' do

  subject { Class.new.send(:include, Config::Integrations::Helpers).new }

  describe '#to_dotted_hash' do

    context 'only the source is specified' do

      it 'returns a hash with a nil key (default)' do
        expect(subject.to_dotted_hash 3).to eq({nil => 3})
      end
    end

    context 'with invalid arguments' do
      it 'raises an error' do
        expect { subject.to_dotted_hash(3, target: [1, 2, 7], namespace: 2) }
            .to raise_error(ArgumentError, 'target must be a hash (given: Array)')
      end
    end

    context 'all arguments specified' do

      it 'returns a hash with the namespace as the key' do
        expect(subject.to_dotted_hash(3, namespace: 'ns')).to eq({'ns' => 3})
      end

      it 'returns a new hash with a dotted string key prefixed with namespace' do
        expect(subject.to_dotted_hash({hello: {cruel: 'world'}}, namespace: 'ns'))
            .to eq({'ns.hello.cruel' => 'world'})
      end

      it 'returns the same hash as passed as a parameter' do
        target = {something: 'inside'}
        target_id = target.object_id
        result = subject.to_dotted_hash(2, target: target, namespace: 'ns')
        expect(result).to eq({:something => 'inside', 'ns' => 2})
        expect(result.object_id).to eq target_id
      end

      it 'returns a hash when given a source with mixed nested types (hashes & arrays)' do
        expect(subject.to_dotted_hash(
            {hello: {evil: [:cruel, 'world', and: {dark: 'universe'}]}}, namespace: 'ns'))
            .to eq(
                    {"ns.hello.evil.0" => :cruel,
                     "ns.hello.evil.1" => "world",
                     "ns.hello.evil.2.and.dark" => "universe"}
                )
      end
    end
  end
end