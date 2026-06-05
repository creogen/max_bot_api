# frozen_string_literal: true

require 'test_helper'

class ChatsTest < Minitest::Test
  def setup
    @client = MaxBotApi::Client.new(token: 'test-token')
  end

  def test_pin_message
    stub_request(:put, 'https://platform-api.max.ru/chats/123/pin')
      .with(
        query: hash_including('v' => '1.2.5'),
        body: '{"message_id":"mid123"}'
      )
      .to_return(status: 200, body: '{"success":true}', headers: { 'Content-Type' => 'application/json' })

    result = @client.chats.pin_message(chat_id: 123, message_id: 'mid123')

    assert_equal true, result[:success]
  end

  def test_get_pinned_message
    stub_request(:get, 'https://platform-api.max.ru/chats/123/pin')
      .with(query: hash_including('v' => '1.2.5'))
      .to_return(
        status: 200,
        body: '{"message":{"body":{"mid":"mid123","text":"Pinned"}}}',
        headers: { 'Content-Type' => 'application/json' }
      )

    result = @client.chats.get_pinned_message(chat_id: 123)

    assert_equal 'mid123', result.dig(:message, :body, :mid)
  end

  def test_unpin_message
    stub_request(:delete, 'https://platform-api.max.ru/chats/123/pin')
      .with(query: hash_including('v' => '1.2.5'))
      .to_return(status: 200, body: '{"success":true}', headers: { 'Content-Type' => 'application/json' })

    result = @client.chats.unpin_message(chat_id: 123)

    assert_equal true, result[:success]
  end
end
