ENV['RAILS_ENV'] ||= 'test'
$LOAD_PATH << File.expand_path('../helpers', __FILE__)

require 'rspec/mocks/standalone'
require 'simplecov'
require 'erb'
require 'yaml'
require 'active_support'
require 'active_support/core_ext/hash'
require 'active_support/core_ext/numeric/time'
require 'mysql2'
require 'timecop'

def load_database_config(adapter: ENV.fetch('SHINQ_TEST_ADAPTER', 'trilogy'))
  YAML.load_file(File.expand_path('./config/database.yml', __dir__)).deep_symbolize_keys.deep_merge(test: { adapter: adapter })
end

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new(
  SimpleCov::Formatter::HTMLFormatter
)

SimpleCov.start do
  add_filter 'spec'
end

RSpec.configure do |config|
  config.filter_run :focus
  config.run_all_when_everything_filtered = true

  if config.files_to_run.one?
    config.full_backtrace = true
    config.default_formatter = 'doc'
  end

  config.before(:suite) do
    sql = Pathname('./db/structure.sql').expand_path(__dir__).read

    config_for_setup = load_database_config[:test]
      .except(:database) # To create database
      .merge(flags: Mysql2::Client::MULTI_STATEMENTS)

    connection = Mysql2::Client.new(config_for_setup)
    result = connection.query(sql)

    while connection.next_result
      connection.store_result
    end

    connection.close
  end

  config.order = :random
  Kernel.srand config.seed
end
