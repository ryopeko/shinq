require 'shinq/client'
require 'active_support/inflector'

module Shinq
  module Launcher
    def run
      worker_name = Shinq.configuration.worker_name
      worker_class = worker_name.camelize.constantize

      @loop_count = 0

      until @stop
        queue = Shinq::Client.dequeue(table_name: worker_name.pluralize)
        next Shinq.logger.info("Queue is empty (#{Time.now})") unless queue

        begin
          worker_class.new.perform(queue)
        rescue => e
          Shinq::Client.abort
          raise
        end

        Shinq::Client.done

        @loop_count += 1

        if lifecycle_limit?
          Shinq.logger.info("Lifecycle Limit pid(#{Process.pid})")
          break
        end
      end
    end

    def stop
      @stop = true
    end

    def lifecycle_limit?
      return false unless Shinq.configuration.lifecycle
      return (Shinq.configuration.lifecycle < @loop_count)
    end
  end
end
