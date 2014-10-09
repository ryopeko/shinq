module Shinq
  module Worker
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def perform_async
        self.save
      end
    end
  end
end
