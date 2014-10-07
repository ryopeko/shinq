module Shinq
  class Worker
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def perform_async(*args)
        client_enqueue('class' => self, 'args' => args)
      end

      def client_enqueue(item)
        Shinq::Client.new.enqueue(item)
      end
    end
  end
end
