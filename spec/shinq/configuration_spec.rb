require 'spec_helper'
require 'shinq/configuration'

describe Shinq::Configuration do
  describe "accessors" do
    subject { Shinq::Configuration.new({}) }

    it { is_expected.to respond_to(:require) }
    it { is_expected.to respond_to(:worker_name) }
    it { is_expected.to respond_to(:db_config) }
    it { is_expected.to respond_to(:queue_db) }
    it { is_expected.to respond_to(:default_db) }
    it { is_expected.to respond_to(:process) }
  end

  describe ".new" do
    context "when key does not have a accessor method" do
      let(:configuration) { Shinq::Configuration.new(undefined_key_name: 'foo') }

      it { expect {configuration.undefined_key_name}.to raise_error(NoMethodError) }
    end

    context "when key has a accessor method" do
      let(:configuration) { Shinq::Configuration.new(worker_name: 'foo') }

      it { expect {configuration.worker_name}.not_to raise_error() }
    end
  end

  describe "#default_db_config" do
    context "when default_db is present" do
      let(:configuration) { Shinq::Configuration.new({}) }

      it {expect { configuration.default_db_config }.to raise_error(Shinq::ConfigurationError)}
    end

    context "when default_db's config is present" do
      let(:configuration) { Shinq::Configuration.new(default_db: :foo) }

      it {expect { configuration.default_db_config }.to raise_error(Shinq::ConfigurationError)}
    end

    context "when default_db's config is present" do
      let(:configuration) { Shinq::Configuration.new(default_db: :test) }

      it {expect { configuration.default_db_config }.to raise_error(Shinq::ConfigurationError)}
    end
  end

  describe "#db_defined?" do
    context "when db_config is present" do
      let (:configuration) { Shinq::Configuration.new({}) }

      it { expect(configuration.db_defined?(:test)).to be false }
    end

    context "when db_config is not present" do
      context "when db_config does not have a value by specified key" do
        let (:configuration) {
          Shinq::Configuration.new(
            db_config: {
              test: 'foo'
            }
          )
        }

        it { expect(configuration.db_defined?(:foo)).to be false }
      end

      context "when db_config has a value by specified key" do
        let (:configuration) {
          Shinq::Configuration.new(
            db_config: {
              test: 'foo'
            }
          )
        }

        it { expect(configuration.db_defined?(:test)).to be true }
      end
    end
  end
end
