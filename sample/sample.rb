require 'shinq'
require 'shinq/worker'
require 'active_record'
require 'pry'

ActiveRecord::Base.configurations = {
  'default' => {
    adapter: 'mysql2',
    host: 'localhost',
    port: 3308,
    socket: '/tmp/mysql.sock3',
    database: 'queue_test',
    username: 'root'
  }
}

ActiveRecord::Base.establish_connection(:default)

class MyQueue < ActiveRecord::Base
  self.table_name = 'my_queue'

  validates_presence_of %i(v1 v2)
  validates_numericality_of :v1, only_integer: true

  include Shinq::Worker

  def perform
  end
end

binding.pry
