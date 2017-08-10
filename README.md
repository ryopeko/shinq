# Shinq
[![Build Status](https://travis-ci.org/ryopeko/shinq.svg)](https://travis-ci.org/ryopeko/shinq)

Worker and enqueuer for Q4M using the interface of ActiveJob.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'shinq'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install shinq

[Install Q4M](http://q4m.github.io/install.html)

## Usage

### Initialize
```ruby
Rails.application.configure do
  config.active_job.queue_adapter = :shinq
end
```

### Worker

#### Generate worker, migration file

```
$ rails generate shinq:worker worker_name title:string
      create  db/migrate/20141110061243_create_worker_names.rb
      create  app/workers/worker_name.rb
```

Generated worker file (app/workers/worker_name.rb)
```ruby
class WorkerName < ActiveJob::Base
  queue_as :worker_names

  def perform(args)
    #do something
  end
end
```

Generated migration file
```ruby
class CreateWorkerNames < ActiveRecord::Migration
  def change
    create_table :worker_names, id: false, options: "ENGINE=QUEUE" do |t|
      t.string :job_id, null: false
      t.string :title
      t.integer :scheduled_at, limit: 8, default: 0, null: false
      t.datetime :enqueued_at, null: false
    end
  end
end
```

#### migrate
```
$ rake db:migrate
== 20141110061243 CreateWorkerNames: migrating ================================
-- create_table(:worker_names, {:id=>false, :options=>"ENGINE=QUEUE"})
   -> 0.0260s
== 20141110061243 CreateWorkerNames: migrated (0.0261s) =======================

mysql> show create table worker_names\G
*************************** 1. row ***************************
       Table: worker_names
Create Table: CREATE TABLE `worker_names` (
  `job_id` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `title` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `scheduled_at` bigint(20) NOT NULL DEFAULT '0',
  `enqueued_at` datetime NOT NULL
) ENGINE=QUEUE DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci
```

### Enqueue
```ruby
WorkerName.perform_later(title: 'foo')
```

### Worker execution

#### Basic execution
```
$ bundle exec shinq --worker worker_name
```

You can specify some options. see `bundle exec shinq --help`

## Contributing

1. Fork it ( https://github.com/ryopeko/shinq/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
