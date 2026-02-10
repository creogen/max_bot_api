# frozen_string_literal: true

require 'max_bot_api'

client = MaxBotApi::Client.new(token: ENV.fetch('TOKEN'))

client.each_update do |update|
  next unless update[:update_type] == 'message_created'

  chat_id = update.dig(:message, :recipient, :chat_id)
  text = update.dig(:message, :body, :text)

  message = MaxBotApi::Builders::MessageBuilder.new
                                               .set_chat(chat_id)
                                               .set_text("Echo: #{text}")

  client.messages.send(message)
end
