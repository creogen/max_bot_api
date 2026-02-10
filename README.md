# MaxBotApi Ruby Client

Ruby client for the MAX Bot API, mirroring the official Go client.

## Installation

```bash
gem install max_bot_api
```

Or in your Gemfile:

```ruby
gem "max_bot_api"
```

## Quick start

```ruby
require "max_bot_api"

client = MaxBotApi::Client.new(token: ENV.fetch("TOKEN"))

me = client.bots.get_bot
puts "Bot: #{me[:name]}"

client.messages.send(
  MaxBotApi::Builders::MessageBuilder.new
    .set_chat(12345)
    .set_text("Hello from Ruby")
)
```

## Features

- Full API coverage: Bots, Chats, Messages, Subscriptions, Uploads, Debugs.
- Builder helpers for messages and keyboards.
- Long polling updates with retry and backoff.
- Webhook parsing helper.
- Upload helpers for files, photos, audio, video.

## Configuration

```ruby
client = MaxBotApi::Client.new(
  token: ENV.fetch("TOKEN"),
  base_url: "https://botapi.max.ru/",
  version: "1.2.5"
)
```

Notes:

- The client uses `Authorization: <token>` (no `Bearer`).
- Every request includes `v=<version>` query param.

## Common tasks

### Send messages

```ruby
message = MaxBotApi::Builders::MessageBuilder.new
  .set_chat(12345)
  .set_text("Hello, chat!")

client.messages.send(message)
```

### Send with result

```ruby
message = MaxBotApi::Builders::MessageBuilder.new
  .set_chat(12345)
  .set_text("Hello, chat!")

sent = client.messages.send_with_result(message)
puts sent[:body][:mid]
```

### Reply to a message

```ruby
message = MaxBotApi::Builders::MessageBuilder.new
  .set_chat(12345)
  .set_reply("Thanks!", "mid123")

client.messages.send(message)
```

### Long polling updates

```ruby
client.each_update do |update|
  case update[:update_type]
  when "message_created"
    text = update.dig(:message, :body, :text)
    puts "New message: #{text}"
  end
end
```

### Webhook parsing

```ruby
body = request.body.read
update = client.parse_webhook(body)
```

## Builders

### Keyboard

```ruby
keyboard = client.messages.new_keyboard_builder
keyboard
  .add_row
  .add_geolocation("Share location", true)
  .add_contact("Share contact")

keyboard
  .add_row
  .add_link("Open MAX", "positive", "https://max.ru")
  .add_callback("Audio", "negative", "audio")

message = MaxBotApi::Builders::MessageBuilder.new
  .set_chat(12345)
  .add_keyboard(keyboard)
  .set_text("Choose an action")

client.messages.send(message)
```

### Attachments

```ruby
photo = client.uploads.upload_photo_from_file(path: "./image.png")

message = MaxBotApi::Builders::MessageBuilder.new
  .set_chat(12345)
  .add_photo(photo)

client.messages.send(message)
```

## Error handling

```ruby
begin
  client.bots.get_bot
rescue MaxBotApi::ApiError => e
  puts "API error: #{e.message}"
rescue MaxBotApi::TimeoutError => e
  puts "Timeout: #{e.message}"
end
```

## More docs

- `docs/01-your-first-bot.md`
- `docs/02-listen-and-respond.md`
- `docs/03-attachments.md`
- `docs/04-keyboard.md`
- `docs/05-uploads.md`
- `docs/06-subscriptions.md`

## Examples

See `examples/` for ready-to-run scripts.
