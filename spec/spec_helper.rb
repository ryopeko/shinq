require 'rspec/mocks/standalone'
require 'simplecov'

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
  SimpleCov::Formatter::HTMLFormatter
]

SimpleCov.start do
  add_filter 'spec'
end

RSpec.configure do |config|
end
