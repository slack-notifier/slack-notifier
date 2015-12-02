require 'rspec'
require 'slack-notifier'
require 'pry' if ENV['DEBUG']

RSpec.configure do |config|
  config.mock_with :rspec do |mocks|
    mocks.verify_doubled_constant_names = true
    mocks.verify_partial_doubles        = true
  end
end
