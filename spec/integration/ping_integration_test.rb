require_relative '../../lib/slack-notifier'

notifier = Slack::Notifier.new ENV['SLACK_TEAM'], ENV['SLACK_TOKEN']
puts "testing with ruby #{RUBY_VERSION}"
notifier.ping "hello from notifier test script on ruby: #{RUBY_VERSION}"