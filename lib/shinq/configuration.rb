module Shinq
  class Configuration
    attr_accessor :require, :worker_name, :db_config, :queue_db, :default_db

    DEFAULT = {
      require: '.',
    }

    def initialize(opts)
      %i(require worker_name db_config queue_db default_db).each do |k|
        send(:"#{k}=", opts[k] || DEFAULT[k])
      end
    end

    def db_defined?(db_name)
      !!(db_config && db_config[db_name])
    end
  end
end
