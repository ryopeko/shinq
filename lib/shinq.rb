require "mysql2"

module Shinq
  VERSION = Gem.loaded_specs['shinq'].version.to_s

  def self.setup_db_connection(db_config)
    @conn = Mysql2::Client.new(db_config)
  end

  def self.conn
    @conn
  end
end
