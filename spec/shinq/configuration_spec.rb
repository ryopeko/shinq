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
end
