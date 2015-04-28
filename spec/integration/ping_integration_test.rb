# coding: utf-8

require_relative '../../lib/slack-notifier'

notifier = Slack::Notifier.new ENV['SLACK_WEBHOOK_URL'], username: 'notifier'
puts "testing with ruby #{RUBY_VERSION}"
notifier.ping "hello/こんにちは from notifier test script on ruby: #{RUBY_VERSION}"
