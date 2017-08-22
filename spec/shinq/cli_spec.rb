require 'spec_helper'
require 'shinq/cli'

describe Shinq::CLI do
  describe '.new' do
    context 'when there are require statement' do
      it 'requires and run the code' do
        # NOTE: As CLI alters global process irreversibly, we only check the result
        Shinq::CLI.new(%W[
          --require my_worker
          --db-config #{File.expand_path('../config/database.yml', __dir__)}
          --worker my_worker
        ])
        expect(defined? MyWorker).to eq 'constant'
      end
    end
  end

  describe '#run' do
    before do
      allow_any_instance_of(ServerEngine::Daemon).to receive(:run).and_return(nil)
    end

    it 'launches Shinq::Launcher backended by ServerEngine' do
      expect {
        Shinq::CLI.new(%W[
          --require my_worker
          --db-config #{File.expand_path('../config/database.yml', __dir__)}
          --worker my_worker
        ]).run
      }.not_to raise_error
    end
  end
end
