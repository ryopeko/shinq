require 'spec_helper'
require 'shinq'
require 'shinq/client'

describe "Integration" do
  before do
    load_database_config(Shinq)
  end

  context "When create queue", skip: ENV['TRAVIS'] do
    let(:queue_table) { 'queue_test' }
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
end
