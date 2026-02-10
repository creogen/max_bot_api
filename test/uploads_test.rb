# frozen_string_literal: true

require 'test_helper'
require 'tempfile'

class UploadsTest < Minitest::Test
  def setup
    @client = MaxBotApi::Client.new(token: 'test-token')
  end

  def test_uploads_media_using_upload_endpoint
    stub_request(:post, 'https://botapi.max.ru/uploads')
      .with(query: hash_including('type' => 'image', 'v' => '1.2.5'))
      .to_return(
        status: 200,
        body: '{"url":"https://upload.example.com/abc","token":"t"}',
        headers: { 'Content-Type' => 'application/json' }
      )

    stub_request(:post, 'https://upload.example.com/abc')
      .to_return(
        status: 200,
        body: '{"photos":{}}',
        headers: { 'Content-Type' => 'application/json' }
      )

    file = Tempfile.new('photo')
    file.write('data')
    file.rewind

    result = @client.uploads.upload_photo_from_reader(io: file)
    assert_equal({ photos: {} }, result)
  ensure
    file.close
    file.unlink
  end
end
