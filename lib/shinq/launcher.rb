require 'shinq/client'
require 'active_support/inflector'
require 'awesome_print'

module Shinq
  module Launcher
    def run
      worker_name = Shinq.configuration.worker_name
      worker_class = worker_name.camelize.constantize

      until @stop
        queue = Shinq::Client.dequeue(table_name: worker_name.pluralize)
        next unless queue

        begin
          worker_class.new.perform(queue)
        rescue => e
          Shinq::Client.abort
          raise
        end

        Shinq::Client.done
      end
    end

    def stop
      @stop = true
    end
  end
end
