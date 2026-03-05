# frozen_string_literal: true

require 'max_bot_api'

client = MaxBotApi::Client.new(token: ENV.fetch('TOKEN'))
chat_id = ENV.fetch('CHAT_ID').to_i

keyboard = client.messages.new_keyboard_builder
keyboard
  .add_row
  .add_geolocation('Share location', true)
  .add_contact('Share contact')

keyboard
  .add_row
  .add_link('Open MAX', 'positive', 'https://max.ru')
  .add_callback('Audio', 'negative', 'audio')
  .add_message('Continue')

message = MaxBotApi::Builders::MessageBuilder.new
                                             .set_chat(chat_id)
                                             .add_keyboard(keyboard)
                                             .set_text('Choose an action')

client.messages.send(message)
