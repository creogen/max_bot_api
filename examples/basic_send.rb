# frozen_string_literal: true

require 'max_bot_api'

client = MaxBotApi::Client.new(token: ENV.fetch('TOKEN'))

message = MaxBotApi::Builders::MessageBuilder.new
                                             .set_chat(ENV.fetch('CHAT_ID').to_i)
                                             .set_text('Hello from Ruby')

client.messages.send(message)
puts 'Sent'
