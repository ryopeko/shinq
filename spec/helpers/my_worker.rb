require 'active_job'
class MyWorker < ActiveJob::Base
  queue_as :my_workers
end
