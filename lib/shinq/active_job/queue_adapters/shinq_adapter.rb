module ActiveJob
  module QueueAdapters
    class ShinqAdapter
      def enqueue(job)
        self.class.enqueue job
      end

      def enqueue_at(job, timestamp)
        self.class.enqueue_at job, timestamp
      end

      class << self
        def enqueue(job)
          Shinq::Client.enqueue(
            table_name: job.queue_name,
            job_id: job.job_id,
            args: job.arguments.first
          )
        end

        def enqueue_at(job, timestamp)
          Shinq::Client.enqueue(
            table_name: job.queue_name,
            job_id: job.job_id,
            args: job.arguments.first,
            scheduled_at: timestamp,
          )
        end
      end
    end
  end
end
