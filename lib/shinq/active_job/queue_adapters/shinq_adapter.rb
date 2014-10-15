module ActiveJob
  module QueueAdapters
    class ShinqAdapter
      class << self
        def enqueue(job)
          Shinq::Client.enqueue(table_name: job.queue_name, args: job.arguments)
        end
      end
    end
  end
end
