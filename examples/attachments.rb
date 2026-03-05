# frozen_string_literal: true

require 'max_bot_api'

client = MaxBotApi::Client.new(token: ENV.fetch('TOKEN'))
chat_id = ENV.fetch('CHAT_ID').to_i

photo_token = ENV['PHOTO_TOKEN']

message = MaxBotApi::Builders::MessageBuilder.new
                                             .set_chat(chat_id)
                                             .set_text('Photo attached')

if photo_token && !photo_token.empty?
  message.add_photo_by_token(photo_token)
else
  photo = client.uploads.upload_photo_from_file(path: './image.png')
  message.add_photo(photo)
end

client.messages.send(message)
