require 'spec_helper'
require 'shinq'
require 'shinq/client'

describe "Integration", skip: ENV['TRAVIS'] do

  before do
    Shinq.configuration = {
      default_db: :test,
      db_config: load_database_config
    }
  end

  after do
    Shinq.clear_all_connections! # Return from owner mode
    tables = Shinq.connection.query('show tables').flat_map(&:values)
    tables.each do |table|
      Shinq.connection.query("delete from #{table}")
    end
    Shinq.clear_all_connections!
  end

  describe "Shinq::Client.enqueue,dequeue" do
    before do
      Timecop.freeze
    end
    after do
      Timecop.return
    end

    context 'with scheduled_at on table' do
      let(:queue_table) { 'queue_test' }
      let(:job_id) { SecureRandom.uuid }

      before do
        Shinq::Client.enqueue(
          table_name: queue_table,
          job_id: job_id,
          args: { title: :foo },
          scheduled_at: scheduled_at
        )
      end

      context 'when scheduled_at is not specified' do
        let(:scheduled_at) { nil }

        it 'can dequeue immediately' do
          expect(Shinq::Client.dequeue(table_name: queue_table)[:job_id]).to eq job_id
        end
      end

      context 'when scheduled_at is specified' do
        let(:scheduled_at) { 1.minute.since }

        it 'can not dequeue job immediately' do
          expect(Shinq::Client.dequeue(table_name: queue_table)).to be nil
        end

        context 'when specified time elapsed' do
          before do
            Timecop.travel(scheduled_at)
          end

          it 'can dequeue job' do
            expect(Shinq::Client.dequeue(table_name: queue_table)[:job_id]).to eq job_id
          end
        end
      end
    end

    context 'without scheduled_at on table' do
      let(:job_id) { SecureRandom.uuid }
      let(:unschedulable_queue_table) { 'queue_test_without_scheduled_at' }

      context 'when scheduled_at is not specified' do
        before do
          Shinq::Client.enqueue(
            table_name: unschedulable_queue_table,
            job_id: job_id,
            args: { title: :foo },
          )
        end

        it 'can dequeue job' do
          expect(Shinq::Client.dequeue(table_name: unschedulable_queue_table)[:job_id]).to eq job_id
        end
      end

      context 'when scheduled_at is specified' do
        it 'cannot enqueue job' do
          expect {
            Shinq::Client.enqueue(
              table_name: unschedulable_queue_table,
              job_id: job_id,
              args: { title: :foo },
              scheduled_at: 1.minute.since,
            )
          }.to raise_error ArgumentError
        end
      end
    end


    context "with invalid args" do
      let(:queue_table) { 'queue_test' }
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
    let(:queue_table) { 'queue_test' }

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
    let(:queue_table) { 'queue_test' }

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
