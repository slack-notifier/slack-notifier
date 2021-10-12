# Slack Notifier

[![CI](https://github.com/slack-notifier/slack-notifier/actions/workflows/ci.yml/badge.svg)](https://github.com/slack-notifier/slack-notifier/actions/workflows/ci.yml)
[![Code Climate](https://codeclimate.com/github/slack-notifier/slack-notifier.svg)](https://codeclimate.com/github/slack-notifier/slack-notifier)
[![Gem Version](https://badge.fury.io/rb/slack-notifier.svg)](https://rubygems.org/gems/slack-notifier)
[![Gem](https://img.shields.io/gem/dt/slack-notifier.svg)]()
[![license](https://img.shields.io/github/license/slack-notifier/slack-notifier.svg)]()
[![SemVer](https://api.dependabot.com/badges/compatibility_score?dependency-name=slack-notifier&package-manager=bundler&version-scheme=semver)](https://dependabot.com/compatibility-score.html?dependency-name=slack-notifier&package-manager=bundler&version-scheme=semver)

A slim ruby wrapper for posting to [Slack](https://slack.com/) webhooks.

<img style="max-width: 100%;" src="https://github.com/slack-notifier/slack-notifier/blob/main/slack_webhook.png?raw=true" height="100px" />

## Installation

Add this line to your application's Gemfile:

```ruby
gem "slack-notifier"
```

And then execute:

```shell
bundle install
```

Or install it yourself as:

```shell
gem install slack-notifier
```

## Usage

### Configuration of Incoming Webhook in Slack

The first step before using this gem is to configure the Incoming Webhook in Slack.

For this purpose, please check the official documentation of Slack. It's listed below some useful links:

- https://www.youtube.com/watch?v=6NJuntZSJVA
- https://api.slack.com/messaging/webhooks
- https://slack.com/intl/en-br/help/articles/115005265063-Incoming-webhooks-for-Slack
- https://slack.com/apps/A0F7XDUAZ-incoming-webhooks

After the configuration, keep your generated Incoming Webhook URL in a secret and secure way.

You will use it (the URL) in next sections of README.

### Hello World example

Once your webhook is setup, the example below will send the message "Hello World" to the default channel you set in Slack.

```ruby
require "slack-notifier"
Slack::Notifier.new("WEBHOOK_URL").ping("Hello World")
```

### Gem public interface

The `Slack::Notifier` class has 3 main methods:

- `new`: Initialization of notifier
- `ping`: Simple invocation of Incoming Webhook API, passing a text message and additional parameters
- `post`: Advanced invocation of Incoming Webhook API, passing the available accepted parameters

### Default options

The default options can be defined in three ways:

- In Initialization, using a block

```ruby
require "slack-notifier"

notifier = Slack::Notifier.new "WEBHOOK_URL" do
  defaults channel: "#default", username: "notifier"
end

notifier.ping "Hello default"
```

- In initialization, using a hash parameter

```ruby
require "slack-notifier"
notifier = Slack::Notifier.new "WEBHOOK_URL", channel: "#default", username: "notifier"
```

- In method invocations that sends the message (`ping` and `post`), using a hash parameter

```ruby
require "slack-notifier"
notifier = Slack::Notifier.new "WEBHOOK_URL"
notifier.ping "Hello random", channel: "#random", username: "notifier"
```

### Links

Slack requires links to be formatted a certain way. Because of this, the gem has a default middleware that will look through your message and attempt to convert any html/markdown links to Slack's format before posting.

The example code below expose what it's doing under the covers:

```ruby
require "slack-notifier"
message = "Hello world, [check](http://example.com) it <a href='http://example.com'>out</a>"
Slack::Notifier::Util::LinkFormatter.format(message)
# => "Hello world, <http://example.com|check> it <http://example.com|out>"
```

### Formatting

Slack supports multiple formatting options.

If you want, for example, to alert an entire channel you can include `<!your-channel>` in your message:

```ruby
require "slack-notifier"
notifier = Slack::Notifier.new "WEBHOOK_URL"
notifier.ping "<!your-channel> hey check this out!"
# => It will send message "@your-channel hey check this out!" in your Slack channel
```

You can see more formatting examples in [Slack's documentation](https://api.slack.com/docs/formatting).

### Escaping

Since sequences starting with < have special meaning in Slack, you should use `Slack::Notifier::Util::Escape.html` if your messages may contain literals `&`, `<` or `>`.

```ruby
require "slack-notifier"
link_text = Slack::Notifier::Util::Escape.html("User <user@example.com>")
message = "Write to [#{link_text}](mailto:user@example.com)"
notifier.ping message
```

### Blocks

This plugin supports the [Slack blocks format](https://app.slack.com/block-kit-builder/) and [block kit builder](https://app.slack.com/block-kit-builder/). This is useful for displaying buttons, dropdowns, and images.

```ruby
require "slack-notifier"

notifier = Slack::Notifier.new "WEBHOOK_URL"

blocks = [
  {
    "type": "image",
    "title": { "type": "plain_text", "text": "image1", "emoji": true },
    "image_url": "https://api.slack.com/img/blocks/bkb_template_images/onboardingComplex.jpg",
    "alt_text": "image1"
  },

  {
    "type": "section",
    "text": { "type": "mrkdwn", "text": "Hey there 👋 I'm TaskBot.\nThere are two ways to quickly create tasks:" }
  }
]

notifier.post(blocks: blocks)
```

### Additional parameters

Any key passed to the `post` method is posted to the webhook endpoint. Check out the [Slack webhook documentation](https://api.slack.com/incoming-webhooks) for the available parameters.

Below are exposed example codes using a subset of the available additional parameters that can be sent for Slack webhook endpoint:

Emoji icon / URL icon

```ruby
require "slack-notifier"

notifier = Slack::Notifier.new "WEBHOOK_URL"

notifier.post text: "feeling spooky", icon_emoji: ":ghost:"
# or
notifier.post text: "feeling chimpy", icon_url: "http://static.mailchimp.com/web/favicon.png"
```

Attachments

```ruby
require "slack-notifier"

notifier = Slack::Notifier.new "WEBHOOK_URL"

a_ok_note = {
  fallback: "Everything looks peachy",
  text: "Everything looks peachy",
  color: "good"
}

notifier.post text: "with an attachment", attachments: [a_ok_note]
```

### HTTP options

With the default HTTP client, you can send along options to customize its behavior as `:http_options` params when you post or initialize the notifier.

```ruby
require "slack-notifier"
notifier = Slack::Notifier.new "WEBHOOK_URL", http_options: { open_timeout: 5 }
notifier.post text: "hello", http_options: { open_timeout: 10 }
```

**Note**: you should only send along options that [`Net::HTTP`](http://ruby-doc.org/stdlib/libdoc/net/http/rdoc/Net/HTTP.html) has as setters, otherwise the option will be ignored and show a warning.

### Proxies

`:http_options` can be used if you need to connect to Slack via an HTTP proxy.
For example, to connect through a local squid proxy the following options would be used.

```ruby
require "slack-notifier"
notifier = Slack::Notifier.new "WEBHOOK_URL", http_options: {
                                                              proxy_address:  'localhost',
                                                              proxy_port:     3128,
                                                              proxy_from_env: false
                                                            }
```

### Custom HTTP Client

There is a packaged default client wrapping Net::HTTP in gem. But there is scenarios where your HTTP needs might be a little different. In that cases, you can pass to notifier your own wrapper to handle sending the notifications. It just needs to respond to `::post` with the arguments of the endpoint URI, and the payload [pretty much the same as Net:HTTP.post_form](http://ruby-doc.org/stdlib/libdoc/net/http/rdoc/Net/HTTP.html#method-c-post_form):

```ruby
require "slack-notifier"

module MyOwnHTTPClient
  def self.post uri, params={}
    Net::HTTP.post_form uri, params
  end
end

notifier = Slack::Notifier.new "WEBHOOK_URL" do
  http_client MyOwnHTTPClient
end
```

The customization of HTTP Client is useful especially for mocking purposes, logging, request tracking and so on. But pay attention to keep the expected API desired by gem.

You can also set the `http_client` per-post, if you need the customization only for certain pings/posts:

```ruby
require "slack-notifier"
notifier = Slack::Notifier.new "WEBHOOK_URL"
notifier.post text: "hello", http_client: MyOwnHTTPClient
notifier.post text: "bye" # => uses the default HTTP client
```

You also may want to watch the behavior of the notifier without posting to slack. This can be handled with a no-op client:

```ruby
require "slack-notifier"

class NoOpHTTPClient
  def self.post uri, params={}
    # You can log or observe posted params here
  end
end

notifier = Slack::Notifier.new "WEBHOOK_URL" do
  http_client NoOpHTTPClient
end
```

### Middleware

By default, `slack-notifier` ships with a default middleware to format links in the message and in text field of attachments.

You can configure which middleware the notifier will use:

```ruby
require "slack-notifier"

notifier = Slack::Notifier.new "WEBHOOK_URL" do
  middleware format_message: { formats: [:html] }
end
# => This example will *only* use the format_message middleware and only format :html links

notifier.post text: "Hello <a href='http://example.com'>world</a>! [visit this](http://example.com)"
# => It will post "Hello <http://example.com|world>! [visit this](http://example.com)"
```

The middleware can be set with a their name, or by name and options. They will be triggered in order that them are declared:

```ruby
require "slack-notifier"

notifier = Slack::Notifier.new "WEBHOOK_URL" do
  middleware :format_message, :format_attachments
end
# => will run format_message then format_attachments with default options

notifier = Slack::Notifier.new "WEBHOOK_URL" do
  middleware format_message:     { formats: [:html]     },
             format_attachments: { formats: [:markdown] }
end
# => will run format_message with formats [:html] then format_attachments with formats [:markdown]
```

The available middlewares are:

- **`format_message`**: This middleware takes the `:text` key of the payload and runs it through the [`Linkformatter`](#links). You can configure which link formats to look for with a `:formats` option. You can set `[:html]` (only html links), `[:markdown]` (only markdown links) or `[:html, :markdown]` (the default, will format both).

- **`format_attachments`**: This middleware takes the `:text` key of any attachment and runs it through the [`Linkformatter`](#links). You can configure which link formats to look for with a `:formats` option. You can set `[:html]` (only html links), `[:markdown]` (only markdown links) or `[:html, :markdown]` (the default, will format both).

- **`at`**: This simplifies the process of notifying users and rooms to messages. By adding an `:at` key to the payload w/ an array of symbols the appropriately formatted commands will be prepended to the message. It will accept a single name, or an array.

For example:

```ruby
require "slack-notifier"
notifier = Slack::Notifier.new "WEBHOOK_URL"
notifier.post text: "hello", at: :casper
# => "<@casper> hello"

notifier.post text: "hello", at: [:here, :waldo]
# => "<!here> <@waldo> hello"
```

**`channels`**

If the `channel` argument of a payload is an array this splits the payload to be posted to each channel.

For example:

```ruby
require "slack-notifier"
notifier = Slack::Notifier.new "WEBHOOK_URL"
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

## Tests

To execute gem tests locally, use Docker with the commands below:

```bash
git clone https://github.com/slack-notifier/slack-notifier
cd slack-notifier
docker build -t slack_notifier_specs .

# Then, run this command how many times you want,
# after editing local files, and so on, to get
# feedback from test suite of gem.
docker run --rm -v $(pwd):/app/ -it slack_notifier_specs
```

## Versioning

Since version `1.0` has been released, the aim is to follow [Semantic Versioning](http://semver.org/) as much as possible. However, it is encouraged to check the [CHANGELOG](CHANGELOG.md) when updating to see what changes have been made.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/slack-notifier/slack-notifier. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the slack-notifier project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](CODE_OF_CONDUCT.md).
