require 'spec_helper'
require 'shinq'
require 'shinq/client'

def client_class
  Shinq::Client.dup
end

describe Shinq::Client do
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
      it { expect(client_class.schedulable?(table_name: :queue_test)).to be true }
    end

    context 'when target table does NOT have scheduled_at' do
      it { expect(client_class.schedulable?(table_name: :queue_test_without_scheduled_at)).to be false }
    end
  end

  describe '.column_names' do
    it 'fetches column_names' do
      expect(client_class.column_names(table_name: :queue_test)).to eq(['job_id', 'title', 'scheduled_at', 'enqueued_at'])
    end
  end

  describe 'fetch_column_names' do
    it 'fetches column_names' do
      expect(client_class.fetch_column_names(table_name: :queue_test)).to eq(['job_id', 'title', 'scheduled_at', 'enqueued_at'])
    end
  end
end
