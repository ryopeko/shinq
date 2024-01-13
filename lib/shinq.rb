require 'mysql2'
require 'shinq/client'
require 'shinq/configuration'

module Shinq
  VERSION = Gem.loaded_specs['shinq'].version.to_s

  def self.configuration=(config)
    @configuration = case config
    when Shinq::Configuration
      config
    else
      Shinq::Configuration.new(config)
    end
  end

  def self.configuration
    @configuration ||= Shinq::Configuration.new({})
  end

  def self.default_db
    self.configuration.default_db ||= ENV['RACK_ENV'] || ENV['RAILS_ENV'] || 'development'
  end

  def self.setup_db_connection(db_name)
    raise Shinq::ConfigurationError unless self.configuration.db_defined?(db_name)
    @connections[db_name.to_sym] = Mysql2::Client.new(self.configuration.db_config[db_name].merge(as: :array))
  end

  def self.connection(db_name: self.default_db)
    @connections ||= {}
    @connections[db_name.to_sym] ||= setup_db_connection(db_name)
  end

  def self.clear_all_connections!
    return unless @connections
    @connections.each do |_db_name, connection|
      connection && connection.close
    end
    @connections = {}
  end

  def self.logger
    @logger
  end

  def self.logger=(log)
    @logger = log
  end
end

require 'shinq/rails' if defined?(::Rails::Engine)
