require File.expand_path( "../lib/slack-notifier/version", __FILE__ )

Gem::Specification.new do |s|

  s.name          = 'slack-notifier'
  s.version       = Slack::Notifier::VERSION
  s.platform      = Gem::Platform::RUBY

  s.summary       = 'A slim ruby wrapper for posting to slack channels'
  s.description   = %q{ A slim ruby wrapper for posting to slack channels }
  s.authors       = ["Steven Sloan"]
  s.email         = ["stevenosloan@gmail.com"]
  s.homepage      = "http://github.com/stevenosloan/slack-notifier"
  s.license       = 'MIT'

  s.files         = Dir["{lib}/**/*.rb"]
  s.test_files    = Dir["spec/**/*.rb"]
  s.require_path  = "lib"

  # Networking
  s.add_dependency("httparty", ["~> 0.11"])

end