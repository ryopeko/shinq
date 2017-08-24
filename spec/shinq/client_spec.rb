require 'spec_helper'
require 'shinq'
require 'shinq/client'

describe Shinq::Client do
  subject(:shinq_client) do
    Shinq::Client.dup.tap do |client|
      client.instance_variables.each do |variable|
        client.remove_instance_variable(variable)
      end
    end
  end

  before do
    Shinq.configuration = {
      default_db: :test,
      db_config: load_database_config
    }
  end

  after do
    Shinq.clear_all_connections!
  end

  describe '.schedulable?' do
    context 'when target table have scheduled_at' do
      it { expect(shinq_client.schedulable?(table_name: :queue_test)).to be true }
    end

    context 'when target table does NOT have scheduled_at' do
      it { expect(shinq_client.schedulable?(table_name: :queue_test_without_scheduled_at)).to be false }
    end
  end

  describe '.column_names' do
    it 'fetches column_names' do
      expect(shinq_client.column_names(table_name: :queue_test)).to eq(['job_id', 'title', 'scheduled_at', 'enqueued_at'])
    end
  end

  describe 'fetch_column_names' do
    it 'fetches column_names' do
      expect(shinq_client.fetch_column_names(table_name: :queue_test)).to eq(['job_id', 'title', 'scheduled_at', 'enqueued_at'])
    end
  end
end
