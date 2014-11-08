require 'spec_helper'
require 'shinq'
require 'shinq/client'

describe "Integration" do
  let(:queue_table) { 'queue_test' }

  before do
    load_database_config(Shinq)
  end

  context "When create queue", skip: ENV['TRAVIS'] do

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

  end
end
