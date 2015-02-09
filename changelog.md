# 1.1.0
- add ability to pass `:http_options` to the initializer or `#ping`. this allows you to set options like `read_timeout` or `open_timeout`. See [issue #17](https://github.com/stevenosloan/slack-notifier/issues/17) for more information.

# 1.0.0
- [BREAKING!] To follow changes with slack, client is now initialized with a webhook url instead of team & token. For help upgrading read the [upgrade from 0.6.1 guide](docs/upgrade-from-0.6.1.md)

# 0.6.1
- fix bug in link_formatter to allow multiple links in a message

# 0.6.0
- add ability to pass in your own http client
- [BREAKING!] hook name moves to options array

# 0.5.0
- allow defaults to be set on initialization
- remove channel formatting [#8]

# 0.4.1
- allow default channel's to start with a "@" or "#" [#7]

# 0.4.0
- try and correct for a channel name being set without a leading "#" [@dlackty]

# 0.3.2
- add Net::HTTP wrapper to include support for ruby 1.9.3

# 0.3.1
- remove requirement for channel, no longer required by slack [@dlackty]

# 0.3.0
- add custom hook endpoint parameter [@razielgn]

# 0.2.0
- remove HTTParty dependency

# 0.1.1
- loosen httparty dependency
- refactor codebase & add specs

# 0.1.0
- now formats html or markdown links in your message to match slack's format

# 0.0.2
- fix a fat finger if a default channel is set

# 0.0.1
- initial release
