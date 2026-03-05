# frozen_string_literal: true

require 'test_helper'
require 'tempfile'
require 'stringio'

class UploadsTest < Minitest::Test
  def setup
    @client = MaxBotApi::Client.new(token: 'test-token')
  end

  def test_uploads_media_using_upload_endpoint
    stub_request(:post, 'https://platform-api.max.ru/uploads')
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

  def test_uploads_media_returns_token_for_audio_and_video
    stub_request(:post, 'https://platform-api.max.ru/uploads')
      .with(query: hash_including('type' => 'audio', 'v' => '1.2.5'))
      .to_return(
        status: 200,
        body: '{"url":"https://upload.example.com/audio","token":"audio-token"}',
        headers: { 'Content-Type' => 'application/json' }
      )

    stub_request(:post, 'https://platform-api.max.ru/uploads')
      .with(query: hash_including('type' => 'video', 'v' => '1.2.5'))
      .to_return(
        status: 200,
        body: '{"url":"https://upload.example.com/video","token":"video-token"}',
        headers: { 'Content-Type' => 'application/json' }
      )

    stub_request(:post, 'https://upload.example.com/audio')
      .to_return(status: 200, body: '<retval>1</retval>')

    stub_request(:post, 'https://upload.example.com/video')
      .to_return(status: 200, body: '<retval>1</retval>')

    audio = @client.uploads.upload_media_from_reader(type: :audio, io: StringIO.new('data'))
    video = @client.uploads.upload_media_from_reader(type: :video, io: StringIO.new('data'))

    assert_equal({ token: 'audio-token' }, audio)
    assert_equal({ token: 'video-token' }, video)
  end
end
