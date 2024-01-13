require 'spec_helper'
require 'shinq'
require 'shinq/configuration'
require 'logger'

describe Shinq do
  # remove instance variable deliberately or indeliberately defined by other specs
  subject(:shinq) do
    Shinq.dup.tap do |shinq|
      shinq.instance_variables.each do |variable|
        shinq.remove_instance_variable(variable)
      end
    end
  end

  after do
    shinq.clear_all_connections!
  end

  it { is_expected.to respond_to(:configuration) }
  it { is_expected.to respond_to(:configuration=) }

  describe ".configuration" do
    context "when configuration is not present" do
      it { expect(shinq.configuration).to be_a_kind_of(Shinq::Configuration) }
    end

    context "when configuration is present" do
      before do
        shinq.configuration = Hash.new
      end

      it { expect(shinq.configuration).to be_a_kind_of(Shinq::Configuration) }
    end
  end

  describe ".configuration=" do
    context "when specify args is Hash" do
      let(:args) { Hash.new }

      it 'is expect to return specified args' do
        expect(shinq.configuration=(args)).to eq args
      end
    end

    context "when specify args is Shinq::Configuration" do
      let(:args) { Shinq::Configuration.new({}) }

      it 'is expect to return specified args' do
        expect(shinq.configuration=(args)).to eq args
      end
    end
  end

  describe ".connection" do
    context "when db_config is not present" do
      it { expect{ shinq.connection(db_name: :unknown) }.to raise_error(Shinq::ConfigurationError) }
    end

    context "when db_config is present" do
      before do
        shinq.configuration = { db_config: load_database_config, default_db: :test }
      end

      it do
        shinq.connection(db_name: :test)
        case shinq.configuration.default_db_config[:adapter]
        when 'mysql2'
          expect(shinq.connection(db_name: :test)).to be_a_kind_of(Mysql2::Client)
        when 'trilogy'
          expect(shinq.connection(db_name: :test)).to be_a_kind_of(Trilogy)
        else
          raise "Unexpected adapter: #{shinq.configuration.default_db_config[:adapter]}"
        end
      end
    end
  end

  describe '.clear_all_connections!' do
    before do
      shinq.configuration = { db_config: load_database_config, default_db: :test }
    end

    context 'when there are no connections' do
      it { expect { shinq.clear_all_connections! }.not_to raise_error }
    end

    context 'when there is a connection' do
      let!(:connection) { shinq.connection(db_name: :test) }

      it 'closes connection' do
        shinq.clear_all_connections!

        # Trilogy raises an exception while mysql2 returns false
        # see: https://github.com/trilogy-libraries/trilogy/pull/145
        case shinq.configuration.default_db_config[:adapter]
        when 'trilogy'
          expect { connection.ping }.to raise_error Trilogy::ConnectionClosed
        when 'mysql2'
          expect(connection.ping).to eq false
        else
          raise "Unexpected adapter: #{shinq.configuration.default_db_config[:adapter]}"
        end
      end

      it 'clears connection cache' do
        shinq.clear_all_connections!
        expect(shinq.connection(db_name: :test)).not_to eq connection
      end
    end
  end

  describe ".logger" do
    context "when logger is not present" do
      it { expect(shinq.logger).to be nil }
    end

    context "when logger is present" do
      let(:logger) { Logger.new(STDOUT) }
      before do
        shinq.logger = logger
      end

      it { expect(shinq.logger).to be logger }
    end
  end
end
