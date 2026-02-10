# 2. Listen and Respond

You can receive updates via long polling or webhooks.

## Long polling

```ruby
client = MaxBotApi::Client.new(token: ENV.fetch("TOKEN"))

client.each_update do |update|
  case update[:update_type]
  when "message_created"
    text = update.dig(:message, :body, :text)
    puts "New message: #{text}"
  when "bot_started"
    puts "Bot started"
  end
end
```

### Advanced polling options

```ruby
client.each_update(
  limit: 50,
  timeout: 30,
  pause: 1,
  types: ["message_created", "message_callback"]
) do |update|
  # ...
end
```

## Webhook handling

```ruby
post "/webhook" do
  update = client.parse_webhook(request.body.read)

  case update[:update_type]
  when "message_created"
    # ...
  end

  status 200
end
```

## Updates model

Updates are returned as hashes. The `update_type` field maps to the official types:

- `message_created`
- `message_edited`
- `message_removed`
- `message_callback`
- `bot_added`
- `bot_removed`
- `bot_started`
- `user_added`
- `user_removed`
- `chat_title_changed`

If you enable `debug: true` in `parse_webhook` or `each_update`, the update includes `:debug_raw`.
