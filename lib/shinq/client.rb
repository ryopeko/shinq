require 'sql-maker'

module Shinq
  class Client
    def self.builder
      @builder ||= SQL::Maker.new(driver: 'mysql')
    end

    def self.enqueue(table_name: , args:)
      sql, bind = builder.insert(table_name, args)

      Shinq.connection.xquery(sql, bind)
    end

    def self.dequeue(table_name:)
      has_queue = Shinq.connection.xquery('select queue_wait(?)', table_name)

      if has_queue
        sql = builder.select(table_name, ['*']).first
        results = Shinq.connection.xquery(sql)
      end

      results.first
    end

    def self.abort
      Shinq.connection.xquery('select queue_abort()')
    end
  end
end
