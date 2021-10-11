# frozen_string_literal: true

require File.expand_path("../lib/slack-notifier/version", __FILE__)

Gem::Specification.new do |s|
  s.name                        = "slack-notifier"
  s.version                     = Slack::Notifier::VERSION
  s.platform                    = Gem::Platform::RUBY
  s.summary                     = "A slim ruby wrapper for posting to slack webhooks"
  s.description                 = "A slim ruby wrapper for posting to slack webhooks"
  s.authors                     = ["Steven Sloan"]
  s.email                       = ["stevenosloan@gmail.com"]
  s.license                     = "MIT"
  s.homepage                    = "https://github.com/slack-notifier/slack-notifier"
  s.metadata['homepage_uri']    = s.homepage
  s.metadata['source_code_uri'] = s.homepage
  s.metadata['changelog_uri']   = "#{s.homepage}/CHANGELOG.md"
  s.required_ruby_version       = '>= 2.0.0'
  s.files                       = Dir["{lib}/**/*.rb"]
  s.test_files                  = Dir["spec/**/*.rb"]
  s.require_path                = "lib"
end
