module Shinq
  class Configuration
    attr_accessor :require, :worker_name, :db_config, :queue_db

    DEFAULT = {
      require: '.',
    }

    def initialize(opts)
      %i(require worker_name db_config queue_db).each do |k|
        send(:"#{k}=", opts[k] || DEFAULT[k])
      end
    end
  end
end
