Recently slack changed the way incoming webhooks are handled. Instead of taking a team name and token, they now provide a unique (obfuscated) webhook url.

To upgrade the slack-notifier gem, you'll need to find your webhook url. In slack:
- go to you're configured integrations (https://team-name.slack.com/services)
- select **Incoming Webhooks**
- select the webhook that uses the slack-notifier gem
- find the webhook url under the heading **Integration Settings**

You'll then change the way you initialize your notifier

From:
```ruby
notifier = Slack::Notifier.new 'team', 'token'
```

To:
```ruby
notifier = Slack::Notifier.new 'WEBHOOK_URL'
```

Defaults & attachemnts will continue to work like they have

```ruby
notifier = Slack::Notifier.new 'WEBHOOK_URL', icon_emoji: ":ghost:"
notifier.ping "I'm feeling spooky"
```
