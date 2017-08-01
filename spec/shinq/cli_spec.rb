require 'spec_helper'
require 'shinq/cli'

describe Shinq::CLI do
  describe '.new' do
    context 'when there are no arguments' do
      it { expect { Shinq::CLI.new(%w(--require shinq/cli)) }.not_to raise_error }
    end
  end

  describe '#run' do
    before do
      allow_any_instance_of(ServerEngine::Daemon).to receive(:run).and_return(nil)
    end

    it 'launches Shinq::Launcher' do
      Shinq::CLI.new(%w(--require shinq/cli)).run
    end
  end
end
