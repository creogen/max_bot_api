# 5. Uploads

Uploads use a two-step flow:

1. `POST /uploads?type=...` to get a temporary upload URL.
2. `POST` multipart data to that URL with field `data`.

This is handled automatically by `MaxBotApi::Resources::Uploads`.

## Media upload types

- `:photo` (image)
- `:video`
- `:audio`
- `:file`

## From disk

```ruby
video = client.uploads.upload_media_from_file(type: :video, filename: "./video.mp4")
message = MaxBotApi::Builders::MessageBuilder.new
  .set_chat(12345)
  .add_video(video)

client.messages.send(message)
```

## From URL

```ruby
doc = client.uploads.upload_media_from_url(type: :file, url: "https://example.com/doc.pdf")
message = MaxBotApi::Builders::MessageBuilder.new
  .set_chat(12345)
  .add_file(doc)

client.messages.send(message)
```

## From IO

```ruby
File.open("./audio.mp3", "rb") do |io|
  audio = client.uploads.upload_media_from_reader(type: :audio, io: io)
  message = MaxBotApi::Builders::MessageBuilder.new
    .set_chat(12345)
    .add_audio(audio)

  client.messages.send(message)
end
```
