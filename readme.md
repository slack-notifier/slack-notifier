A simple wrapper to send notifications to slack

## Example

```ruby
require 'slack-notifier'

notifier = Slack::Notifier.new "yourteam", "yourtokenXX"
notifier.ping "Hello World", channel: "#general"
# => if your webhook is setup, will message "Hello World"
# => to the "#general" channel
```
