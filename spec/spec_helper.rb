require 'simplecov'
require 'coveralls'

SimpleCov.start do
  add_filter 'spec'
  minimum_coverage(76)
  formatter(
    SimpleCov::Formatter::MultiFormatter.new(
      [
         SimpleCov::Formatter::HTMLFormatter,
         Coveralls::SimpleCov::Formatter
      ]
    )
  )
end

require 'webmock'
require 'webmock/rspec'
require 'pipedrive'

RSpec.configure do |config|
end
