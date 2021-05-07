A simple wrapper to send notifications to [Slack](https://slack.com/) webhooks.

[![Build Status](https://travis-ci.org/slack-notifier/slack-notifier.svg?branch=master)](https://travis-ci.org/slack-notifier/slack-notifier)
[![Code Climate](https://codeclimate.com/github/slack-notifier/slack-notifier.svg)](https://codeclimate.com/github/slack-notifier/slack-notifier)
[![Gem Version](https://badge.fury.io/rb/slack-notifier.svg)](https://rubygems.org/gems/slack-notifier)
[![SemVer](https://api.dependabot.com/badges/compatibility_score?dependency-name=slack-notifier&package-manager=bundler&version-scheme=semver)](https://dependabot.com/compatibility-score.html?dependency-name=slack-notifier&package-manager=bundler&version-scheme=semver)

## Example

```ruby
require 'slack-notifier'

notifier = Slack::Notifier.new "WEBHOOK_URL"
notifier.ping "Hello World"
# => if your webhook is setup, will message "Hello World"
# => to the default channel you set in slack
```


#### Installation

Install the latest stable release:

```
$ gem install slack-notifier
```

Or with [Bundler](http://bundler.io/), add it to your Gemfile:

```ruby
gem "slack-notifier"
```


#### Setting Defaults

On initialization you can set default payloads by calling `defaults` in an initialization block:

```ruby
notifier = Slack::Notifier.new "WEBHOOK_URL" do
  defaults channel: "#default",
           username: "notifier"
end

notifier.ping "Hello default"
# => will message "Hello default"
# => to the "#default" channel as 'notifier'
```

To get the WEBHOOK_URL you need:

1. go to https://slack.com/apps/A0F7XDUAZ-incoming-webhooks
2. choose your team, press configure
3. in configurations press add configuration
4. choose channel, press "Add Incoming WebHooks integration"


You can also set defaults through an options hash:

```ruby
notifier = Slack::Notifier.new "WEBHOOK_URL", channel: "#default",
                                              username: "notifier"
```

These defaults are over-ridable for any individual ping.

```ruby
notifier.ping "Hello random", channel: "#random"
# => will ping the "#random" channel
```


## Links

Slack requires links to be formatted a certain way, so the default middlware stack of slack-notifier will look through your message and attempt to convert any html or markdown links to slack's format before posting.

Here's what it's doing under the covers:

```ruby
message = "Hello world, [check](http://example.com) it <a href='http://example.com'>out</a>"
Slack::Notifier::Util::LinkFormatter.format(message)
# => "Hello world, <http://example.com|check> it <http://example.com|out>"
```

## Formatting

Slack supports various different formatting options.  For example, if you want to alert an entire channel you include `<!channel>` in your message

```ruby
message = "<!channel> hey check this out"
notifier.ping message

#ends up posting "@channel hey check this out" in your Slack channel
```

You can see [Slack's message documentation here](https://api.slack.com/docs/formatting)

## Escaping

Since sequences starting with < have special meaning in Slack, you should use `Slack::Notifier::Util::Escape.html` if your messages may contain &, < or >.

```ruby
link_text = Slack::Notifier::Util::Escape.html("User <user@example.com>")
message = "Write to [#{link_text}](mailto:user@example.com)"
notifier.ping message
```

## Blocks

This plugin supports the [Slack blocks format](https://app.slack.com/block-kit-builder/) and [block kit builder](https://app.slack.com/block-kit-builder/). This is useful for displaying buttons, dropdowns, and images.

```ruby
blocks = [
  {
    "type": "image",
    "title": {
      "type": "plain_text",
      "text": "image1",
      "emoji": true
    },
    "image_url": "https://api.slack.com/img/blocks/bkb_template_images/onboardingComplex.jpg",
    "alt_text": "image1"
  },
  {
    "type": "section",
    "text": {
      "type": "mrkdwn",
      "text": "Hey there 👋 I'm TaskBot. I'm here to help you create and manage tasks in Slack.\nThere are two ways to quickly create tasks:"
    }
  }
]

notifier.post(blocks: blocks)
```

## Additional parameters

Any key passed to the `post` method is posted to the webhook endpoint. Check out the [Slack webhook documentation](https://api.slack.com/incoming-webhooks) for the available parameters.

Setting an icon:

```ruby
notifier.post text: "feeling spooky", icon_emoji: ":ghost:"
# or
notifier.post text: "feeling chimpy", icon_url: "http://static.mailchimp.com/web/favicon.png"
```

Adding attachments:

```ruby
a_ok_note = {
  fallback: "Everything looks peachy",
  text: "Everything looks peachy",
  color: "good"
}
notifier.post text: "with an attachment", attachments: [a_ok_note]
```


## HTTP options

With the default HTTP client, you can send along options to customize its behavior as `:http_options` params when you post or initialize the notifier.

```ruby
notifier = Slack::Notifier.new 'WEBHOOK_URL', http_options: { open_timeout: 5 }
notifier.post text: "hello", http_options: { open_timeout: 10 }
```

**Note**: you should only send along options that [`Net::HTTP`](http://ruby-doc.org/stdlib-2.2.0/libdoc/net/http/rdoc/Net/HTTP.html) has as setters, otherwise the option will be ignored and show a warning.

### Proxies

`:http_options` can be used if you need to connect to Slack via an HTTP proxy.
For example, to connect through a local squid proxy the following options would be used.

```ruby
notifier = Slack::Notifier.new 'WEBHOOK_URL', http_options: {
                                                              proxy_address:  'localhost',
                                                              proxy_port:     3128,
                                                              proxy_from_env: false
                                                            }
```

## Custom HTTP Client

There is a packaged default client wrapping Net::HTTP, but your HTTP needs might be a little different. In that case, you can pass in your own wrapper to handle sending the notifications. It just needs to respond to `::post` with the arguments of the endpoint URI, and the payload [pretty much the same as Net:HTTP.post_form](http://ruby-doc.org/stdlib-2.1.2/libdoc/net/http/rdoc/Net/HTTP.html#method-c-post_form).

A simple example:
```ruby
module Client
  def self.post uri, params={}
    Net::HTTP.post_form uri, params
  end
end

notifier = Slack::Notifier.new 'WEBHOOK_URL' do
  http_client Client
end
```

It's also encouraged for any custom HTTP implementations to accept the `:http_options` key in params.

**Setting client per post**

You can also set the http_client per-post if you need to special case certain pings.

```ruby
notifier.post text: "hello", http_client: CustomClient
```

**Setting a No-Op client**

In development (or testing), you may want to watch the behavior of the notifier without posting to slack. This can be handled with a no-op client.

```ruby
class NoOpHTTPClient
  def self.post uri, params={}
    # bonus, you could log or observe posted params here
  end
end

notifier = Slack::Notifier.new 'WEBHOOK_URL' do
  http_client NoOpHTTPClient
end
```


## Middleware

By default slack-notifier ships with middleware to format links in the message & text field of attachments. You can configure the middleware a notifier will use on initialization:

```ruby
notifier = Slack::Notifier.new "WEBHOOK_URL" do
  middleware format_message: { formats: [:html] }
end
# this example will *only* use the format_message middleware and only format :html links

notifier.post text: "Hello <a href='http://example.com'>world</a>! [visit this](http://example.com)"
# => will post "Hello <http://example.com|world>! [visit this](http://example.com)"
```

The middleware can be set with a their name, or by name and options. They will be triggered in order.

```ruby
notifier = Slack::Notifier.new "WEBHOOK_URL" do
  middleware :format_message, :format_attachments
end
# will run format_message then format_attachments with default options

notifier = Slack::Notifier.new "WEBHOOK_URL" do
  middleware format_message: { formats: [:html] },
             format_attachments: { formats: [:markdown] }
end
# will run format_message w/ formats [:html] then format_attachments with formats [:markdown]
```

Available middleware:

**`format_message`**

This middleware takes the `:text` key of the payload and runs it through the [`Linkformatter`](#links). You can configure which link formats to look for with a `:formats` option. You can set `[:html]` (only html links), `[:markdown]` (only markdown links) or `[:html, :markdown]` (the default, will format both).

**`format_attachments`**

This middleware takes the `:text` key of any attachment and runs it through the [`Linkformatter`](#links). You can configure which link formats to look for with a `:formats` option. You can set `[:html]` (only html links), `[:markdown]` (only markdown links) or `[:html, :markdown]` (the default, will format both).

**`at`**

This simplifies the process of notifying users and rooms to messages. By adding an `:at` key to the payload w/ an array of symbols the appropriately formatted commands will be prepended to the message. It will accept a single name, or an array.

For example:

```ruby
notifier.post text: "hello", at: :casper
# => "<@casper> hello"

notifier.post text: "hello", at: [:here, :waldo]
# => "<!here> <@waldo> hello"
```

**`channels`**

If the `channel` argument of a payload is an array this splits the payload to be posted to each channel.

For example:

```ruby
notifier.post text: "hello", channel: ["default", "all_the_things"]
# => will post "hello" to the default and all_the_things channel
```

To send a message directly to a user, their username [no longer works](https://github.com/stevenosloan/slack-notifier/issues/51#issuecomment-414138622). Instead you'll need to get the user's ID and set that as the channel.

At the time of writing, one way to get a user's ID is to:

- go to their profile
- click **...** ("More actions")
- click **Copy Member ID**

### Writing your own Middleware

Middleware is fairly straightforward, it is any class that inherits from `Slack::Notifier::PayloadMiddleware::Base` and responds to `#call`. It will always be given the payload as a hash and should return the modified payload as a hash.

For example, lets say we want to replace words in every message, we could write a middleware like this:

```ruby
class SwapWords < Slack::Notifier::PayloadMiddleware::Base
  middleware_name :swap_words # this is the key we use when setting
                              # the middleware stack for a notifier

  options pairs: ["hipchat" => "slack"] # the options takes a hash that will
                                        # serve as the default if not given any
                                        # when initialized

  def call payload={}
    return payload unless payload[:text] # noope if there is no message to work on

    # not efficient, but it's an example :)
    options[:pairs].each do |from, to|
      payload[:text] = payload[:text].gsub from, to
    end

    payload # always return the payload from your middleware
  end
end


notifier = Slack::Notifier.new "WEBHOOK_URL" do
  middleware :swap_words # setting our stack w/ just defaults
end
notifier.ping "hipchat is awesome!"
# => pings slack with "slack is awesome!"

notifier = Slack::Notifier.new "WEBHOOK_URL" do
  # here we set new options for the middleware
  middleware swap_words: { pairs: ["hipchat" => "slack",
                                   "awesome" => "really awesome"]}
end

notifier.ping "hipchat is awesome!"
# => pings slack with "slack is really awesome!"
```

If your middleware returns an array, that will split the message into multiple pings. An example for pinging multiple channels:

```ruby
class MultiChannel < Slack::Notifier::PayloadMiddleware::Base
  middleware_name :channels

  def call payload={}
    return payload unless payload[:channel].respond_to?(:to_ary)

    payload[:channel].to_ary.map do |channel|
      pld = payload.dup
      pld[:channel] = channel
      pld
    end
  end
end
```


Versioning
----------

Since version `1.0` has been released, the aim is to follow [Semantic Versioning](http://semver.org/) as much as possible. However, it is encouraged to check the [changelog](changelog.md) when updating to see what changes have been made.

To summarize the reasoning for versioning:

```
Given a version number MAJOR.MINOR.PATCH, increment:

- MAJOR version when incompatible API changes are made
- MINOR version for adding functionality in a backwards-compatible manner or bug fixes that *may* change behavior
- PATCH version for make backwards-compatible bug fixes
```

Testing
-------

```bash
$ rspec
```

There is also an integration test setup to just double check pinging across the supported rubies. To run:

1. Copy the `.env-example` file to `.env` and replace with your details.
2. Make sure `bin/test` is executable
3. then run and watch for the pings in your slack room

```bash
$ bin/test
```


Contributing
------------

If there is any thing you'd like to contribute or fix, please:

- Fork the repo
- Add tests for any new functionality
- Make your changes
- Verify all new & existing tests pass
- Make a pull request


License
-------
The slack-notifier gem is distributed under the MIT License.
