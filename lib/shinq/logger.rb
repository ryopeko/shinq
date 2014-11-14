require 'logger'

module Shinq
  class Logger
    def self.initialize_logger
      @logger = ::Logger.new(STDOUT)
    end

    def self.logger=(log)
      @logger = log
    end

    def self.logger
      @logger ? @logger : initialize_logger
    end
  end
end
