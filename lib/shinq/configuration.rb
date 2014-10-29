module Shinq
  class ConfigurationError < StandardError; end

  class Configuration
    attr_accessor :require, :worker_name, :db_config, :queue_db, :default_db, :process, :queue_timeout, :daemonize

    DEFAULT = {
      require: '.',
      process: 1,
      queue_timeout: 1,
      daemonize: false
    }

    def initialize(opts)
      %i(require worker_name db_config queue_db default_db process queue_timeout daemonize).each do |k|
        send(:"#{k}=", opts[k] || DEFAULT[k])
      end
    end

    def default_db_config
      raise ConfigurationError if !(default_db && db_defined?(default_db))
      db_config[default_db]
    end

    def db_defined?(db_name)
      !!(db_config && db_config[db_name])
    end
  end
end
