# frozen_string_literal: true

require 'max_bot_api'
require 'rack'

client = MaxBotApi::Client.new(token: ENV.fetch('TOKEN'))

app = lambda do |env|
  req = Rack::Request.new(env)
  if req.post? && req.path == '/webhook'
    update = client.parse_webhook(req.body.read)

    if update[:update_type] == 'message_created'
      chat_id = update.dig(:message, :recipient, :chat_id)
      message = MaxBotApi::Builders::MessageBuilder.new
                                                   .set_chat(chat_id)
                                                   .set_text('Hello from webhook')

      client.messages.send(message)
    end

    [200, { 'Content-Type' => 'text/plain' }, ['ok']]
  else
    [404, { 'Content-Type' => 'text/plain' }, ['not found']]
  end
end

Rack::Handler::WEBrick.run(app, Port: 10_888)
