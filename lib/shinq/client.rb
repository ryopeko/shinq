require 'sql-maker'
require 'sql/maker/quoting'
require 'active_support/core_ext/hash/keys'

module Shinq
  class Client
    def self.builder
      @builder ||= SQL::Maker.new(driver: 'mysql', auto_bind: true)
    end

    def self.enqueue(table_name: , job_id: , args:, scheduled_at: nil)
      if scheduled_at && !schedulable?(table_name: table_name)
        raise ArgumentError, "table #{table_name} is not schedulable. You need column `scheduled_at`"
      end

      case args
      when Hash
        attributes = args.merge(
          job_id: job_id,
          scheduled_at: scheduled_at ? scheduled_at.to_i : nil,
          enqueued_at: Time.now,
        ).compact
        sql = builder.insert(table_name, attributes)
        Shinq.connection.query(sql)
      else
        raise ArgumentError, "`args` should be a Hash"
      end
    end

    def self.dequeue(table_name:)
      condition = schedulable?(table_name: table_name) ? ":scheduled_at<#{Time.now.to_i}" : ''
      quoted = SQL::Maker::Quoting.quote("#{table_name}#{condition}")

      queue_timeout_quoted = SQL::Maker::Quoting.quote(Shinq.configuration.queue_timeout)

      wait_query = "queue_wait(#{quoted}, #{queue_timeout_quoted})"
      has_queue = Shinq.connection.query("select #{wait_query}").first

      unless has_queue[wait_query].to_i == 0
        sql = builder.select(table_name, ['*'])
        results = Shinq.connection.query(sql)
        # select always returns 1 line in the owner (queue_wait) mode
        return results.first.symbolize_keys
      end
    end

    def self.queue_stats(table_name:)
      quoted = SQL::Maker::Quoting.quote(table_name)

      stats_query = "queue_stats(#{quoted})"
      result = Shinq.connection.query("select #{stats_query}")

      stats = result.first[stats_query].split(/\n/).each_with_object({}) do |s, h|
        (k,v) = s.split(/:/)
        h[k.to_sym] = v.to_i
      end

      stats.merge(
        queue_count: stats[:rows_written] - stats[:rows_removed]
      )
    end

    def self.schedulable?(table_name:)
      self.column_names(table_name: table_name).include?('scheduled_at')
    end

    def self.column_names(table_name:)
      @column_names_by_table_name ||= {}
      @column_names_by_table_name[table_name] ||= begin
        quoted = SQL::Maker::Quoting.quote(table_name)
        column = Shinq.connection.query(<<-EOS).map { |record| record['column_name'] }
select column_name from information_schema.columns where table_schema = database() and table_name = #{quoted}
        EOS
      end
    end

    def self.fetch_column_names(table_name:)
      @column_names_by_table_name ||= {}
      @column_names_by_table_name.delete(table_name)
      column_names(table_name: table_name)
    end

    def self.done
      Shinq.connection.query('select queue_end()')
    end

    def self.abort
      Shinq.connection.query('select queue_abort()')
    end
  end
end
