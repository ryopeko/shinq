require 'optparse'
require 'yaml'
require 'shinq'
require 'shinq/launcher'
require 'shinq/configuration'
require 'serverengine'

module Shinq
  class OptionParseError < StandardError; end

  class CLI
    def initialize(args=ARGV)
      setup_option(args)
      bootstrap
    end

    def setup_option(args)
      opts = parse_options(args)

      Shinq.configuration = Shinq::Configuration.new(opts)
    end

    def parse_options(args)
      opts = {}
      parser = OptionParser.new do |opt|
        opt.on('-d', '--daemon', 'Daemonize process') do |v|
          opts[:daemonize] = v
        end

        opt.on('-w', '--worker value', 'Name of worker class') do |v|
          opts[:worker_name] = v
        end

        opt.on('-p', '--process VALUE', 'Number of workers') do |v|
          opts[:process] = v.to_i
        end

        opt.on('--queue-timeout VALUE', 'Waiting queue time(sec). use function of queue_wait(Q4M)') do |v|
          opts[:queue_timeout] = v.to_i
        end

        opt.on('--db-config VALUE', 'Specify database configuration file') do |v|
          raise OptionParseError, "#{v} does not exist" unless File.exist?(v)
          opts[:db_config] = YAML.load_file(v)
        end

        opt.on('--queue-database VALUE', 'Name of queue database') do |v|
          raise OptionParseError, "#{v}'s settings does not exist" unless opts[:db_config][v]
          opts[:queue_db] = v
        end

        opt.on('-r', '--require VALUE', 'Add require path') do |v|
          opts[:require] = v
        end

        opt.on('-v', '--version', 'Print version') do |v|
          puts "Shinq #{Shinq::VERSION}"
          exit(0)
        end
      end

      parser.parse!(args)
      opts
    end

    def options
      Shinq.configuration
    end

    def bootstrap
      target = options.require

      if File.directory?(target)
        require 'rails'
        require File.expand_path("#{target}/config/application.rb")

        require 'shinq/rails'
        require File.expand_path("#{target}/config/environment.rb")
      else
        require target
      end
    end

    def run
      se = ServerEngine.create(nil, Shinq::Launcher, {
        daemonize: options.daemonize,
        worker_type: 'process',
        pid_file: 'shinq.pid',
        workers: options.process
      })

      se.run
    end
  end
end
