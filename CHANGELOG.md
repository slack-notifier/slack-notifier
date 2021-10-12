# 3.0.0

- [BREAKING] The Slack does not allow Incoming Webhook to be used in more than 1 channel. So, all multiple-channel feature present and `username`/`user` parameters in gem was erased. Be careful that Slack Incoming Webhook not works anymore with multiple channels at once. Each webhook is now related to only one channel.
- Setup of automation using Github Actions
- README.md changes
- Deploy of Rubygems configured to be made using Github Actions
- Specs running in new rubies
- Rubocop offenses fixes

# 2.4.0

- Make keyword argument usage compatible for ruby 3.x [@walski #123, @yuuu #119]

# 2.3.2
- Improve compatability with CommonMark spec for markdown link formatting [@revolter #91]

  Still not 100% compliant, but it is now much closer.

# 2.3.1
- use `map` to return the array of responses instead of payload in `ping` & `post` [@yhatt #88]

# 2.3.0
- feat: add `channels` middleware to split payloads to ping multiple channels [#40]
- feat: support any middleware splittin payload into an array to allow multiple payloads from a single process.

# 2.2.2
- fix wrapping of attachments passed as a hash
- fix error in `LinkFormatter` if a text payload was nil [#81]

# 2.2.1
- fix loading error caused by uninitialized constant [@pocke #78]

# 2.2.0
- raise exception when API responds with an error [@siegy22]

# 2.1.0
- addition of :at middleware to simplify notifying users & rooms [@kazuooooo #66]

# 2.0.0

[BREAKING] This is a fairly large change to how defaults are set and how messages are processed.

**Setting Defaults**

Setter methods are no longer available for setting defaults on a notifier instance, you'll now set defaults with a block on initialization.

```ruby
# previously in 1.x
notifier = Slack::Notifier.new WEBHOOK_URL, http_client: CustomClient
notifier.channel = "sup"

# in 2.x
notifier = Slack::Notifier.new WEBHOOK_URL do
  http_client CustomClient
  defaults channel: "sup"
end
```

Read more about [setting defaults in the readme](readme.md#setting-defaults)

**Message Processing**

Message are now processed through a configurable middleware stack. By default it acts exactly the same as the 1.x versions. [More information is available in the readme](readme.md#middleware)

# 1.5.1
- allow using a single attachment w/o putting it in an array [@Elektron1c97  #47]

# 1.5.0
- allow sending with attachments only [#48]

# 1.4.0
- Format attachment messages with the LinkFormatter  [@bhuga #37]
- Add support for mailto links in markdown formatted links [@keithpitty #43]

# 1.3.1
- Fix bug with link formatter for markdown links wrapped in square braces [@bhuga #36]

# 1.3.0
- Add `#escape` to allow clients to escape special characters [@monkbroc #35]

# 1.2.1
- use `#scrub` to (more selectively) strip invalid characters from strings before attempting to format. This allows valid japanese (and more) characters to be used. Thanks to @fukayatsu for reporting.

  This checks for the presence of the `scrub` method on string, so if on ruby < 2.1 you'll need to include & require the `string-scrub` gem to handle invalid characters.

# 1.2.0
- Strip invalid UTF-8 characters from message before attempting to format links. They are replaced with the unicode replacement character '[�](http://en.wikipedia.org/wiki/Specials_(Unicode_block)#Replacement_character)'. [@ushu #26]

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
