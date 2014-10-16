require 'optparse'
require 'yaml'
require 'shinq'
require 'shinq/launcher'
require 'shinq/configuration'

module Shinq
  class OptionParseError < StandardError; end

  class CLI
    def initialize(args=ARGV)
      setup_option(args)
      setup_db_config
      bootstrap
    end

    def setup_option(args)
      opts = parse_options(args)

      Shinq.configuration = Shinq::Configuration.new(opts)
    end

    def parse_options(args)
      opts = {}
      parser = OptionParser.new do |opt|
        opt.on('--worker VALUE') do |v|
          opts[:worker_name] = v
        end

        opt.on('--db-config VALUE') do |v|
          raise OptionParseError, "#{v} does not exist" unless File.exist?(v)
          opts[:db_config] = YAML.load_file(v)
        end

        opt.on('--queue-database VALUE') do |v|
          raise OptionParseError, "#{v}'s settings does not exist" unless opts[:db_config][v]
          opts[:queue_db] = v
          opts[:queue_db_settings] = opts[:db_config][v]
        end

        opt.on('--require VALUE') do |v|
          opts[:require] = v
        end
      end

      parser.parse!(args)
      opts
    end

    def options
      Shinq.configuration
    end

    def setup_db_config
      Shinq.default_db = options.queue_db
      Shinq.db_config = options.db_config
    end

    def bootstrap
      return unless options.require
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
      Shinq::Launcher.new(options.worker_name).run
    end
  end
end
