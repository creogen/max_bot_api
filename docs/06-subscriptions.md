# 6. Subscriptions (Webhooks)

Use subscriptions to receive webhook updates.

## Subscribe

```ruby
client = MaxBotApi::Client.new(token: ENV.fetch("TOKEN"))

client.subscriptions.subscribe(
  url: "https://example.com/webhook",
  update_types: ["message_created", "message_callback"],
  secret: "my-secret"
)
```

## Unsubscribe

```ruby
client.subscriptions.unsubscribe(url: "https://example.com/webhook")
```

## List subscriptions

```ruby
subscriptions = client.subscriptions.get_subscriptions
puts subscriptions[:subscriptions].inspect
```
