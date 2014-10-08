require 'json'
require 'mysql2'

module Shinq
  class Client
    class << self
      def enqueue(item)

      end
    end

    def initialize
      @conn ||= Mysql2::Client.new(Shinq.q4m_config)
    end
  end
end
