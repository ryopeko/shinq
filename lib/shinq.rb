require "shinq/version"

module Shinq
  def self.configure_server
    yield self
  end

  def self.q4m_connection(conn)
    @q4m = conn
  end
end
