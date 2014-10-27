module ActiveJob
  module QueueAdapters
    class ShinqAdapter
      class << self
        def enqueue(job)
          Shinq::Client.enqueue(
            table_name: job.queue_name,
            job_id: job.job_id,
            args: job.arguments.first
          )
        end
      end
    end
  end
end
