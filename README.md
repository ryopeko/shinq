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
```ruby
class FooWorker < ActiveJob::Base
  aueue_as :my_queues #name of queue table

  def perform(args)
    #perform asynchronous
  end
end
```

### Enqueue
```ruby
FooWorker.perform_later(foo: 'bar', baz: 'qux')
```

### Worker execution
TBD

## Contributing

1. Fork it ( https://github.com/[my-github-username]/shinq/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
