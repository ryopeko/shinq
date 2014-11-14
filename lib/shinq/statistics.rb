require 'shinq/client'
require 'active_support/inflector'

module Shinq
  module Statistics
    def run
      until @stop
        Shinq.logger.info Shinq::Client.queue_stats(table_name: Shinq.configuration.worker_name.pluralize)
        sleep Shinq.configuration.statistics
      end
    end

    def stop
      @stop = true
    end
  end
end
