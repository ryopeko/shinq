require 'optparse'

module Shinq
  class CLI
    def initialize(args=ARGV)
      parse_options(args)
    end

    def parse_options(args)
      @opts = {}
      parser = OptionParser.new do |opt|
        opt.on('--worker VALUE') do |v|
          @opts[:worker_name] = v
        end
      end

      parser.parse!(args)
      @opts
    end
  end
end
