require 'spec_helper'
require 'shinq'
require 'shinq/client'

describe "Integration" do
  before do
    load_database_config(Shinq)
  end

  context "When create queue", skip: ENV['TRAVIS'] do
    let(:queue_table) { 'queue_test' }

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


    it { expect(@queue[:title]).to eq args[:title] }
  end
end
