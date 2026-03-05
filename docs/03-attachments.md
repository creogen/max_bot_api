# 3. Attachments

Use `uploads` to upload files and then attach them to a message.

## Upload from file

```ruby
photo = client.uploads.upload_photo_from_file(path: "./image.png")

message = MaxBotApi::Builders::MessageBuilder.new
  .set_chat(12345)
  .add_photo(photo)

client.messages.send(message)
```

## Upload from URL

```ruby
audio = client.uploads.upload_media_from_url(type: :audio, url: "https://example.com/audio.mp3")

message = MaxBotApi::Builders::MessageBuilder.new
  .set_chat(12345)
  .add_audio(audio)

client.messages.send(message)
```

## Other attachment helpers

- `add_video(uploaded_info)`
- `add_file(uploaded_info)`
- `add_location(lat, lon)`
- `add_contact(name:, contact_id:, vcf_info:, vcf_phone:)`
- `add_sticker(code)`

## Photo tokens

When you upload photos, you receive a token payload. Pass it to `add_photo`:

```ruby
photo_tokens = client.uploads.upload_photo_from_file(path: "./image.png")

message = MaxBotApi::Builders::MessageBuilder.new
  .set_chat(12345)
  .add_photo(photo_tokens)

client.messages.send(message)
```

You can also attach a photo directly by token:

```ruby
message = MaxBotApi::Builders::MessageBuilder.new
  .set_chat(12345)
  .add_photo_by_token("photo-token")

client.messages.send(message)
```
