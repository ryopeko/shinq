require 'sql-maker'
require 'sql/maker/quoting'

module Shinq
  class Client
    def self.builder
      @builder ||= SQL::Maker.new(driver: 'mysql', auto_bind: true)
    end

    def self.enqueue(table_name: , args:)
      case args
      when Hash
        sql = builder.insert(table_name, args)
        Shinq.connection.query(sql)
      when Array
        args.each do |queue|
          sql = builder.insert(table_name, queue)

          Shinq.connection.query(sql)
        end
      else
        raise ArgumentError, "queue should be Array[Hash] or Hash"
      end
    end

    def self.dequeue(table_name:)
      quoted = SQL::Maker::Quoting.quote(table_name)
      has_queue = Shinq.connection.query("select queue_wait(#{quoted})").first

      if has_queue
        sql = builder.select(table_name, ['*'])
        results = Shinq.connection.query(sql)
      end

      results.first
    end

    def self.done
      Shinq.connection.query('select queue_end()')
    end

    def self.abort
      Shinq.connection.query('select queue_abort()')
    end
  end
end
