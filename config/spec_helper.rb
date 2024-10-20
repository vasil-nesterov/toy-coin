# typed: strict

require 'debug'
require 'logger'

ENV['RSPEC'] = 'true'

Log = Logger.new(STDOUT, level: Logger::WARN)

RSpec.configure do |c|
  c.filter_run(focus: true)
  c.run_all_when_everything_filtered = true
end