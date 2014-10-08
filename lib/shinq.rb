require "shinq/version"
require "mysql2"
require "shinq/client"

module Shinq
  def self.configure_server
    yield self
  end

  def self.q4m_config=(config)
    @q4m_config = config
  end

  def self.q4m_config
    @q4m_config
  end
end
