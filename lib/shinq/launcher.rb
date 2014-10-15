require 'shinq/client'
require 'active_support/inflector'

module Shinq
  class Launcher
    def initialize(worker_name)
      @worker_name = worker_name
      @worker_class = @worker_name.camelize.constantize
    end

    def run
      queue = Shinq::Client.dequeue(table_name: @worker_name.pluralize)

      begin
        @worker_class.new.perform(queue)
      rescue => e
        Shinq::Client.abort
        raise
      end

      Shinq::Client.done
    end
  end
end
