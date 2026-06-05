# frozen_string_literal: true

require 'test_helper'

class MessagesTest < Minitest::Test
  def setup
    @client = MaxBotApi::Client.new(token: 'test-token')
  end

  def test_send_retries_on_attachment_not_ready
    stub_request(:post, 'https://platform-api.max.ru/messages')
      .with(query: hash_including('v' => '1.2.5', 'chat_id' => '123'))
      .to_return(
        {
          status: 400,
          body: '{"code":"attachment.not.ready","message":"not ready"}',
          headers: { 'Content-Type' => 'application/json' }
        },
        {
          status: 200,
          body: '{}',
          headers: { 'Content-Type' => 'application/json' }
        }
      )

    message = MaxBotApi::Builders::MessageBuilder.new
                                                 .set_chat(123)
                                                 .set_text('hello')

    @client.messages.send(message)

    assert_requested(:post, 'https://platform-api.max.ru/messages',
                     times: 2,
                     query: hash_including('v' => '1.2.5', 'chat_id' => '123'))
  end

  def test_send_passes_disable_link_preview_when_enabled
    stub_request(:post, 'https://platform-api.max.ru/messages')
      .with(query: hash_including('v' => '1.2.5', 'chat_id' => '123', 'disable_link_preview' => 'true'))
      .to_return(status: 200, body: '{}', headers: { 'Content-Type' => 'application/json' })

    message = MaxBotApi::Builders::MessageBuilder.new
                                                 .set_chat(123)
                                                 .set_text('hello')
                                                 .set_disable_link_preview(true)

    @client.messages.send(message)

    assert_requested(:post, 'https://platform-api.max.ru/messages',
                     query: hash_including('v' => '1.2.5', 'chat_id' => '123', 'disable_link_preview' => 'true'))
  end

  def test_send_omits_disable_link_preview_when_disabled
    stub_request(:post, 'https://platform-api.max.ru/messages')
      .with(query: hash_including('v' => '1.2.5', 'chat_id' => '123'))
      .to_return(status: 200, body: '{}', headers: { 'Content-Type' => 'application/json' })

    message = MaxBotApi::Builders::MessageBuilder.new
                                                 .set_chat(123)
                                                 .set_text('hello')

    @client.messages.send(message)

    assert_requested(:post, 'https://platform-api.max.ru/messages',
                     query: hash_including('v' => '1.2.5', 'chat_id' => '123'))
    assert_not_requested(:post, 'https://platform-api.max.ru/messages',
                         query: hash_including('disable_link_preview' => 'true'))
  end
end
