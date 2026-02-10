# frozen_string_literal: true

require 'test_helper'

class ClientTest < Minitest::Test
  def setup
    @client = MaxBotApi::Client.new(token: 'test-token')
  end

  def test_adds_version_and_authorization
    stub_request(:get, 'https://botapi.max.ru/me')
      .with(query: hash_including('v' => '1.2.5'), headers: { 'Authorization' => 'test-token' })
      .to_return(status: 200, body: '{}', headers: { 'Content-Type' => 'application/json' })

    @client.bots.get_bot
  end

  def test_raises_api_error
    stub_request(:get, 'https://botapi.max.ru/me')
      .with(query: hash_including('v' => '1.2.5'))
      .to_return(status: 400, body: '{"error":"bad"}', headers: { 'Content-Type' => 'application/json' })

    error = assert_raises(MaxBotApi::ApiError) { @client.bots.get_bot }
    assert_match(/bad/, error.message)
  end
end
