# 1. Your First Bot

This guide shows how to create a basic bot using the Ruby client.

## Get a token

Open a dialog with [MasterBot](https://max.ru/masterbot) and create a bot. You will receive a token.

## Install the gem

```bash
gem install max_bot_api
```

## Minimal bot

```ruby
require "max_bot_api"

client = MaxBotApi::Client.new(token: ENV.fetch("TOKEN"))

me = client.bots.get_bot
puts "Hello, #{me[:name]}"
```

## Send a message

```ruby
message = MaxBotApi::Builders::MessageBuilder.new
  .set_chat(12345)
  .set_text("Hello from Ruby")

client.messages.send(message)
```

## Configuration

```ruby
client = MaxBotApi::Client.new(
  token: ENV.fetch("TOKEN"),
  base_url: "https://botapi.max.ru/",
  version: "1.2.5"
)
```
