require 'spec_helper'
require 'shinq'
require 'shinq/configuration'
require 'logger'

def shinq_class
  Shinq.dup
end

describe Shinq do
  subject { shinq_class }

  it { is_expected.to respond_to(:configuration) }
  it { is_expected.to respond_to(:configuration=) }

  describe ".configuration" do
    context "when configuration is not present" do
      let(:shinq) { shinq_class }

      it { expect(shinq.configuration).to be_a_kind_of(Shinq::Configuration) }
    end

    context "when configuration is present" do
      let(:shinq) {
        shinq_class.tap {|s|
          s.configuration = Hash.new
        }
      }

      it { expect(shinq.configuration).to be_a_kind_of(Shinq::Configuration) }
    end
  end

  describe ".configuration=" do
    context "when specify args is Hash" do
      let(:shinq) { shinq_class }
      let(:args) { Hash.new }

      it 'is expect to return specified args' do
        expect(shinq.configuration=(args)).to eq args
      end
    end

    context "when specify args is Shinq::Configuration" do
      let(:shinq) { shinq_class }
      let(:args) { Shinq::Configuration.new({}) }

      it 'is expect to return specified args' do
        expect(shinq.configuration=(args)).to eq args
      end
    end
  end

  describe ".connection" do
    context "when db_config is present" do
      let(:shinq) { shinq_class }

      it { expect{ shinq.connection(db_name: :unknown) }.to raise_error(Shinq::ConfigurationError) }
    end

    context "when db_config is not preset" do
      let(:shinq) {
        shinq_class.tap {|s|
          s.configuration = {
            db_config: load_database_config,
            default_db: :test,
          }
        }
      }

      it { expect(shinq.connection(db_name: :test)).to be_a_kind_of(Mysql2::Client) }
    end
  end

  describe ".logger" do
    context "when logger is present" do
      let(:shinq) { shinq_class }
      it { expect(shinq.logger).to be nil }
    end

    context "when logger is present" do
      let(:logger) { Logger.new(STDOUT) }
      let(:shinq) {
        shinq_class.tap {|s|
          s.logger = logger
        }
      }

      it { expect(shinq.logger).to be logger }
    end
  end
end
