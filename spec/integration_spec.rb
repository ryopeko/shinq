require 'spec_helper'
require 'shinq'
require 'shinq/client'

describe "Integration", skip: ENV['TRAVIS'] do
  let(:queue_table) { 'queue_test' }

  before do
    load_database_config(Shinq)
  end

  after do
    Shinq.connection.query("delete from #{queue_table}")
  end

  describe "Shinq::Client.enqueue,dequeue" do
    context "valid args" do
      let(:args) { {title: 'foo'} }

      before do
        Shinq::Client.enqueue(
          table_name: queue_table,
          job_id: 'jobid',
          args: args
        )

        @queue = Shinq::Client.dequeue(table_name: queue_table)
        Shinq::Client.done
      end

      it { expect(@queue[:title]).to eq args[:title] }
    end

    context "invalid args" do
      it {
        expect {
          Shinq::Client.enqueue(
            table_name: queue_table,
            job_id: 'jobid',
            args: Array.new
          )
        }.to raise_error(ArgumentError)
      }
    end
  end

  describe "Shinq::Client.abort" do
    context "When client has a queue" do
      before do
        Shinq::Client.enqueue(
          table_name: queue_table,
          job_id: 'jobid',
          args: {title: 'foo'}
        )

        @queue_count = Shinq.connection.query("select count(*) as c from #{queue_table}").first['c']

        Shinq::Client.dequeue(table_name: queue_table)
        Shinq::Client.abort

        @after_queue_count = Shinq.connection.query("select count(*) as c from #{queue_table}").first['c']
      end

      it { expect(@after_queue_count).to be @queue_count }
    end

    context "When client does not have a queue" do
      it {
        expect {
          Shinq::Client.abort
        }.to raise_error (/not in owner mode/)
      }
    end
  end

  describe "Shinq::Client.queue_stats" do
    subject(:stats) {
      Shinq::Client.queue_stats(table_name: queue_table)
    }

    it { expect(stats).to have_key :rows_written }
    it { expect(stats).to have_key :rows_removed }
    it { expect(stats).to have_key :wait_immediate }
    it { expect(stats).to have_key :wait_delayed }
    it { expect(stats).to have_key :wait_timeout }
    it { expect(stats).to have_key :restored_by_abort }
    it { expect(stats).to have_key :restored_by_close }
    it { expect(stats).to have_key :bytes_total }
    it { expect(stats).to have_key :bytes_removed }
    it { expect(stats).to have_key :queue_count }

    it "queue_count expect to be equal rows_removed - rows_written" do
      expect(stats[:queue_count]).to eq (stats[:rows_removed] - stats[:rows_written])
    end
  end
end
