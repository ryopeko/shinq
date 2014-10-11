require "mysql2"
require "shinq/client"

module Shinq
  VERSION = Gem.loaded_specs['shinq'].version.to_s

  def self.configure_server
    yield self
  end

  def self.q4m_config=(config)
    @q4m_config = config
  end

  def self.q4m_config
    @q4m_config
  end

  def self.setup_db_connection(db_config)
    @conn = Mysql2::Client.new(db_config)
  end

  def self.conn
    @conn
  end
end
