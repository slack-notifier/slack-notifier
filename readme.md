A simple wrapper to send notifications to [Slack](https://slack.com/) webhooks.

[![Build Status](https://travis-ci.org/stevenosloan/slack-notifier.png?branch=master)](https://travis-ci.org/stevenosloan/slack-notifier)  [![Code Climate](https://codeclimate.com/github/stevenosloan/slack-notifier.png)](https://codeclimate.com/github/stevenosloan/slack-notifier)

## Example

```ruby
require 'slack-notifier'

notifier = Slack::Notifier.new "yourteam", "yourtokenXX"
notifier.ping "Hello World", channel: "#general"
# => if your webhook is setup, will message "Hello World"
# => to the "#general" channel
```

#### Setting Defaults

Once a notifier has been initialized, you can set a default channel and/or user so that you no longer have to set them in pings.

```ruby
notifier.channel  = '#default'
notifier.username = 'notifier'
notifier.ping "Hello default"
# => will message "Hello default"
# => to the "#default" channel as 'notifier'
```

These defaults are over-ridable for any individual ping.

```ruby
notifier.channel = "#default"
notifier.ping "Hello random", channel: "#random"
# => will ping the "#random" channel
```

## Links

Slack requires links to be formatted a certain way, so slack-notifier will look through your message and attempt to convert any html or markdown links to slack's format before posting.

Here's what it's doing under the covers:

```ruby
message = "Hello world, [check](http://example.com) it <a href='http://example.com'>out</a>"
Slack::Notifier::LinkFormatter.format(message)
# => "Hello world, <http://example.com|check> it <http://example.com|out>"
```

## Additional parameters

Any key passed to the `ping` method is posted to the webhook endpoint. Check out the [Slack webhook documentation](https://my.slack.com/services/new/incoming-webhook) for the available parameters.

Setting an icon:

```ruby
notifier.ping "feeling spooky", icon_emoji: ":ghost:"
# or
notifier.ping "feeling chimpy", icon_url: "http://static.mailchimp.com/web/favicon.png"
```

Adding attachments:

```ruby
a_ok_note = {
  fallback: "Everything looks peachy",
  text: "Everything looks peachy",
  color: "good"
}
notifier.ping "with an attachment", attachments: [a_ok_note]
```



Testing
-------

```bash
$ rspec
```


Contributing
------------

If there is any thing you'd like to contribute or fix, please:

- Fork the repo
- Add tests for any new functionality
- Make your changes
- Verify all new &existing tests pass
- Make a pull request


License
-------
The slack-notifier gem is distributed under the MIT License.
