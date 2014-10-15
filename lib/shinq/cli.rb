require 'optparse'
require 'yaml'
require 'shinq'
require 'shinq/launcher'

module Shinq
  class OptionParseError < StandardError; end

  class CLI
    def initialize(args=ARGV)
      parse_options(args)
      setup_db_config
      bootstrap
    end

    def parse_options(args)
      @opts = {}
      parser = OptionParser.new do |opt|
        opt.on('--worker VALUE') do |v|
          @opts[:worker_name] = v
        end

        opt.on('--db-config VALUE') do |v|
          raise OptionParseError, "#{v} does not exist" unless File.exist?(v)
          @opts[:db_config] = YAML.load_file(v)
        end

        opt.on('--queue-database VALUE') do |v|
          raise OptionParseError, "#{v}'s settings does not exist" unless @opts[:db_config][v]
          @opts[:queue_db] = v
          @opts[:queue_db_settings] = @opts[:db_config][v]
        end

        opt.on('--require VALUE') do |v|
          @opts[:require] = v
        end
      end

      parser.parse!(args)
      @opts
    end

    def setup_db_config
      Shinq.default_db = @opts[:queue_db]
      Shinq.db_config = @opts[:db_config]
    end

    def bootstrap
      return unless @opts[:require]

      if File.directory?(@opts[:require])
        require 'rails'
        require File.expand_path("#{@opts[:require]}/config/application.rb")

        require 'shinq/rails'
        require File.expand_path("#{@opts[:require]}/config/environment.rb")
      else
        require @opts[:require]
      end
    end

    def run
      Shinq::Launcher.new(@opts[:worker_name]).run
    end
  end
end
