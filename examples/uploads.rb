# frozen_string_literal: true

require 'max_bot_api'

client = MaxBotApi::Client.new(token: ENV.fetch('TOKEN'))
chat_id = ENV.fetch('CHAT_ID').to_i

audio = client.uploads.upload_media_from_file(type: :audio, filename: './audio.mp3')

message = MaxBotApi::Builders::MessageBuilder.new
                                             .set_chat(chat_id)
                                             .add_audio(audio)

client.messages.send(message)
