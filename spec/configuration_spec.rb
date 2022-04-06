require 'spec_helper'

describe Config::Configuration do
  subject do
    Module.new do
      extend Config::Configuration.new(hello: 'world')
    end
  end

  it 'extends a module with additional methods' do
    expect(subject.hello).to eq('world')
    expect { subject.hello = 'dlrow' }.to change { subject.hello }.to('dlrow')
  end
end
