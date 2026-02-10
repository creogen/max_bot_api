# frozen_string_literal: true

require 'max_bot_api'

client = MaxBotApi::Client.new(token: ENV.fetch('TOKEN'))

url = ENV.fetch('WEBHOOK_URL')

client.subscriptions.subscribe(
  url: url,
  update_types: %w[message_created message_callback],
  secret: 'my-secret'
)

puts "Subscribed to #{url}"
