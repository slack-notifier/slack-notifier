**A fork of [slack-notifier](https://github.com/stevenosloan/slack-notifier).**

**This fork is compatible with Ruby 1.8.7+**

A simple wrapper to send notifications to [Slack](https://slack.com/) webhooks.

## Example

```ruby
require 'slack-notifier'

notifier = Slack::Notifier.new "WEBHOOK_URL"
notifier.ping "Hello World"
# => if your webhook is setup, will message "Hello World"
# => to the default channel you set in slack
# => hound ci test
```


#### Setting Defaults

On initialization you can set default payloads by passing an options hash.

```ruby
notifier = Slack::Notifier.new "WEBHOOK_URL", :channel => '#default',
                                              :username => 'notifier'

notifier.ping "Hello default"
# => will message "Hello default"
# => to the "#default" channel as 'notifier'
```

Once a notifier has been initialized, you can update the default channel and/or user.

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
notifier.ping "Hello random", :channel => "#random"
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

## Formatting

Slack supports various different formatting options.  For example, if you want to alert an entire channel you include `<!channel>` in your message

```ruby
message = "<!channel> hey check this out"
notifier.ping message

#ends up posting "@channel hey check this out" in your Slack channel
```

You can see [Slack's message documentation here](https://api.slack.com/docs/formatting)

## Escaping

Since sequences starting with < have special meaning in Slack, you should use `notifier.escape` if your messages may contain &, < or >.

```ruby
link_text = notifier.escape("User <user@example.com>")
message = "Write to [#{link_text}](mailto:user@example.com)"
notifier.ping message
```

## Additional parameters

Any key passed to the `ping` method is posted to the webhook endpoint. Check out the [Slack webhook documentation](https://my.slack.com/services/new/incoming-webhook) for the available parameters.

Setting an icon:

```ruby
notifier.ping "feeling spooky", :icon_emoji => ":ghost:"
# or
notifier.ping "feeling chimpy", :icon_url => "http://static.mailchimp.com/web/favicon.png"
```

Adding attachments:

```ruby
a_ok_note = {
  fallback: "Everything looks peachy",
  text: "Everything looks peachy",
  color: "good"
}
notifier.ping "with an attachment", :attachments => [a_ok_note]
```


## HTTP options

With the default HTTP client, you can send along options to customize its behavior as `:http_options` params when you ping or initialize the notifier.

```ruby
notifier = Slack::Notifier.new 'WEBHOOK_URL', :http_options => { open_timeout: 5 }
notifier.ping "hello", :http_options => { open_timeout: 10 }
```

**Note**: you should only send along options that [`Net::HTTP`](http://ruby-doc.org/stdlib-2.2.0/libdoc/net/http/rdoc/Net/HTTP.html) has as setters, otherwise the option will be ignored and show a warning.


## Custom HTTP Client

There is a packaged default client wrapping Net::HTTP, but your HTTP needs might be a little different. In that case, you can pass in your own wrapper to handle sending the notifications. It just needs to respond to `::post` with the arguments of the endpoint URI, and the payload [pretty much the same as Net:HTTP.post_form](http://ruby-doc.org/stdlib-2.1.2/libdoc/net/http/rdoc/Net/HTTP.html#method-c-post_form).

A simple example:
```ruby
module Client
  def self.post uri, params={}
    Net::HTTP.post_form uri, params
  end
end

notifier = Slack::Notifier.new 'WEBHOOK_URL', :http_client => Client
```

It's also encouraged for any custom HTTP implementations to accept the `:http_options` key in params.

**Setting client per ping**

You can also set the http_client per-ping if you need to special case certain pings.

```ruby
notifier.ping "hello", :http_client => CustomClient
```

**Setting a No-Op client**

In development (or testing), you may want to watch the behavior of the notifier without posting to slack. This can be handled with a no-op client.

```ruby
class NoOpHTTPClient
  def self.post uri, params={}
    # bonus, you could log or observe posted params here
  end
end

notifier = Slack::Notifier.new 'WEBHOOK_URL', :http_client => NoOpHTTPClient
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
