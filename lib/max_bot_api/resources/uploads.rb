# frozen_string_literal: true

require 'base64'
require 'stringio'

module MaxBotApi
  module Resources
    # Upload helpers for media and photos.
    class Uploads
      UPLOAD_TYPES = {
        photo: 'image',
        video: 'video',
        audio: 'audio',
        file: 'file'
      }.freeze

      def initialize(client)
        @client = client
      end

      # Upload media from a local file.
      # @param type [Symbol, String]
      # @param filename [String]
      def upload_media_from_file(type:, filename:)
        File.open(filename, 'rb') do |fh|
          upload_media_from_reader_with_name(type: type, io: fh, name: File.basename(filename))
        end
      end

      # Upload media from a remote URL.
      # @param type [Symbol, String]
      # @param url [String]
      def upload_media_from_url(type:, url:)
        response = Faraday.get(url.to_s)
        raise Error, "fetch URL failed: HTTP #{response.status}" unless response.status.between?(200, 299)

        name = attachment_name(response.headers)
        upload_media_from_reader_with_name(type: type, io: StringIO.new(response.body), name: name)
      rescue Faraday::Error => e
        raise NetworkError.new(op: 'GET upload source', original_error: e)
      end

      # Upload media from an IO object.
      # @param type [Symbol, String]
      # @param io [#read]
      def upload_media_from_reader(type:, io:)
        upload_media_from_reader_with_name(type: type, io: io, name: nil)
      end

      # Upload media from IO with explicit name.
      # @param type [Symbol, String]
      # @param io [#read]
      # @param name [String, nil]
      def upload_media_from_reader_with_name(type:, io:, name: nil)
        upload_media_from_reader_internal(type: type, io: io, name: name)
      end

      # Upload a photo from a local file.
      # @param path [String]
      def upload_photo_from_file(path:)
        upload_media_from_file(type: :photo, filename: path)
      end

      # Upload a photo from base64 content.
      # @param code [String]
      def upload_photo_from_base64_string(code:)
        decoded = Base64.decode64(code)
        upload_media_from_reader_with_name(type: :photo, io: StringIO.new(decoded), name: nil)
      end

      # Upload a photo from a remote URL.
      # @param url [String]
      def upload_photo_from_url(url:)
        upload_media_from_url(type: :photo, url: url)
      end

      # Upload a photo from an IO object.
      # @param io [#read]
      def upload_photo_from_reader(io:)
        upload_media_from_reader(type: :photo, io: io)
      end

      # Upload a photo from IO with explicit name.
      # @param io [#read]
      # @param name [String]
      def upload_photo_from_reader_with_name(io:, name:)
        upload_media_from_reader_with_name(type: :photo, io: io, name: name)
      end

      private

      def upload_media_from_reader_internal(type:, io:, name: nil)
        upload_type = UPLOAD_TYPES.fetch(type.to_sym) { type.to_s }
        endpoint = @client.request(:post, 'uploads', query: { 'type' => upload_type })

        file_name = name.to_s.empty? ? 'file' : File.basename(name.to_s)
        file_part = Faraday::Multipart::FilePart.new(io, nil, file_name)

        response = Faraday.post(endpoint[:url]) do |req|
          req.body = { 'data' => file_part }
        end

        raise upload_api_error(response) unless response.status.between?(200, 299)

        return { token: endpoint[:token] } if %w[audio video].include?(upload_type) && endpoint[:token]

        JSON.parse(response.body, symbolize_names: true)
      rescue Faraday::Error => e
        raise NetworkError.new(op: 'POST uploads', original_error: e)
      end

      def upload_api_error(response)
        body = response.body.to_s
        return Error.new("upload failed: HTTP #{response.status}") if body.empty?

        json = begin
          JSON.parse(body)
        rescue StandardError
          nil
        end
        if json.is_a?(Hash)
          if json['code'] && json['message']
            return ApiError.new(code: response.status, message: json['code'], details: json['message'])
          end

          if json['error']
            return ApiError.new(code: response.status, message: json['error'],
                                details: json['details'] || json['message'])
          end
          if json['message']
            return ApiError.new(code: response.status, message: json['message'], details: json['details'])
          end
        end

        Error.new("upload failed: HTTP #{response.status}")
      end

      def attachment_name(headers)
        disposition = headers['content-disposition'].to_s
        return '' if disposition.empty?

        match = disposition.match(/filename="?([^";]+)"?/)
        match ? match[1] : ''
      end
    end
  end
end
