# 4. Keyboard

The keyboard builder mirrors the Go client.

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
  .add_callback("Video", "negative", "video")

keyboard
  .add_row
  .add_callback("Picture", "positive", "picture")
  .add_message("Continue")

message = MaxBotApi::Builders::MessageBuilder.new
  .set_chat(12345)
  .add_keyboard(keyboard)
  .set_text("Choose an action")

client.messages.send(message)
```

## Button types

- `add_callback(text, intent, payload)`
- `add_link(text, intent, url)`
- `add_contact(text)`
- `add_geolocation(text, quick)`
- `add_open_app(text, app, payload, contact_id)`
- `add_message(text)`
