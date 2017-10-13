module Shinq
  class ConfigurationError < StandardError; end

  # @!attribute abort_on_error
  #   @return [Boolean] Whether do +queue_abort()+ on performing failure.
  #   @see Shinq::Launcher#run
  #
  #   Defaults to +true+, which means that worker do +queue_end()+ AFTER it proceeds a job.
  #   If it is +false+, worker do +queue_end()+ BEFORE it proceeds a job.
  #   You may need to set it +false+ for jobs which take very long time to proceed.
  #   You may also need to handle performing error manually then.
  class Configuration
    attr_accessor :require, :worker_name, :db_config, :queue_db, :default_db, :process, :graceful_kill_timeout, :queue_timeout, :daemonize, :statistics, :lifecycle, :abort_on_error, :sleep_sec_on_error

    DEFAULT = {
      require: '.',
      process: 1,
      graceful_kill_timeout: 600,
      queue_timeout: 1,
      daemonize: false,
      abort_on_error: true,
      sleep_sec_on_error: 1,
    }

    def initialize(opts)
      %i(require worker_name db_config queue_db default_db process queue_timeout daemonize statistics lifecycle abort_on_error sleep_sec_on_error).each do |k|
        value = opts.key?(k) ? opts[k] : DEFAULT[k]
        send(:"#{k}=", value)
      end
    end

    def worker_class
      worker_class = worker_name.camelize.safe_constantize
      unless worker_class
        raise ConfigurationError, "worker class #{worker_name.camelize} corresponding to #{worker_name} does not exist"
      end
      worker_class
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
