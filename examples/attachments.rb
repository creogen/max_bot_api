# frozen_string_literal: true

require 'max_bot_api'

client = MaxBotApi::Client.new(token: ENV.fetch('TOKEN'))
chat_id = ENV.fetch('CHAT_ID').to_i

photo = client.uploads.upload_photo_from_file(path: './image.png')

message = MaxBotApi::Builders::MessageBuilder.new
                                             .set_chat(chat_id)
                                             .add_photo(photo)
                                             .set_text('Photo attached')

client.messages.send(message)
