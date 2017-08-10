ENV['RAILS_ENV'] ||= 'test'
$LOAD_PATH << File.expand_path('../helpers', __FILE__)

require 'rspec/mocks/standalone'
require 'simplecov'
require 'yaml'
require 'active_support/core_ext/hash'
require 'mysql2'
require 'timecop'

def load_database_config
  db_config = YAML.load_file(File.expand_path('./config/database.yml', __dir__)).symbolize_keys
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
    connection = Mysql2::Client.new(load_database_config[:test].merge(flags: Mysql2::Client::MULTI_STATEMENTS))
    result = connection.query(File.read(File.expand_path('./db/structure.sql', __dir__)))

    while connection.next_result
      connection.store_result
    end

    connection.close
  end

  config.order = :random
  Kernel.srand config.seed
end
