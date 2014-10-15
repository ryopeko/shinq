require "mysql2-cs-bind"

module Shinq
  VERSION = Gem.loaded_specs['shinq'].version.to_s

  def self.db_config=(config)
    @db_config = config
    @connections = {}
  end

  def self.db_config
    @db_config
  end

  def self.default_db=(db_name)
    @default_db = db_name
  end

  def self.default_db
    @default_db
  end


  def self.setup_db_connection(db_name)
    @connection ||= {}
    @connections[db_name] = Mysql2::Client.new(db_config[db_name])
  end

  def self.connection(db_name: default_db)
    @connections[db_name] ||= setup_db_connection(db_name)
  end
end
