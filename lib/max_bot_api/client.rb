# frozen_string_literal: true

require 'uri'

module MaxBotApi
  # Main API client. Holds auth config and provides resource accessors.
  class Client
    # Default API base URL.
    DEFAULT_BASE_URL = 'https://platform-api.max.ru/'
    # Default API version appended as query param.
    DEFAULT_VERSION = '1.2.5'
    # Default pause between update polling loops.
    DEFAULT_PAUSE = 1
    # Default limit for updates requests.
    DEFAULT_UPDATES_LIMIT = 50
    # Max retry attempts for update polling.
    MAX_RETRIES = 3

    # @return [String] bot token
    # @return [String] base URL
    # @return [String] API version
    attr_reader :token, :base_url, :version

    # @param token [String] bot token
    # @param base_url [String] API base URL
    # @param version [String] API version
    # @param faraday [Faraday::Connection, nil] custom Faraday connection
    # @param adapter [Symbol] Faraday adapter
    def initialize(token:, base_url: DEFAULT_BASE_URL, version: DEFAULT_VERSION, faraday: nil,
                   adapter: Faraday.default_adapter)
      raise EmptyTokenError, 'bot token is empty' if token.to_s.empty?

      @token = token
      @base_url = normalize_base_url(base_url)
      @version = version.to_s.empty? ? DEFAULT_VERSION : version.to_s

      @conn = faraday || Faraday.new(url: @base_url) do |f|
        f.request :multipart
        f.request :url_encoded
        f.adapter adapter
      end
    end

    def bots
      Resources::Bots.new(self)
    end

    def chats
      Resources::Chats.new(self)
    end

    def messages
      Resources::Messages.new(self)
    end

    def subscriptions
      Resources::Subscriptions.new(self)
    end

    def uploads
      Resources::Uploads.new(self)
    end

    # Build a debug sender bound to a chat.
    # @param chat_id [Integer]
    def debugs(chat_id: 0)
      Resources::Debugs.new(self, chat_id: chat_id)
    end

    # Fetch updates from the API.
    # @param limit [Integer, nil]
    # @param timeout [Integer, nil]
    # @param marker [Integer, nil]
    # @param types [Array<String>, nil]
    # @param debug [Boolean]
    def get_updates(limit: nil, timeout: nil, marker: nil, types: nil, debug: false)
      query = {}
      query['limit'] = limit if limit && limit.to_i > 0
      query['timeout'] = timeout.to_i if timeout && timeout.to_i > 0
      query['marker'] = marker if marker && marker.to_i > 0
      Array(types).each { |t| (query['types'] ||= []) << t }

      result = request(:get, 'updates', query: query)
      Updates::Parser.parse_update_list(result, debug: debug)
    rescue TimeoutError
      { updates: [], marker: nil }
    end

    # Fetch updates with retry/backoff.
    def get_updates_with_retry(limit: nil, timeout: nil, marker: nil, types: nil, debug: false)
      last_error = nil

      MAX_RETRIES.times do |attempt|
        return get_updates(limit: limit, timeout: timeout, marker: marker, types: types, debug: debug)
      rescue Error => e
        last_error = e
        raise e if attempt == MAX_RETRIES - 1

        sleep(2**attempt)
      end

      raise last_error
    end

    # Returns an enumerator that yields updates indefinitely.
    def updates_enum(pause: DEFAULT_PAUSE, limit: DEFAULT_UPDATES_LIMIT, timeout: nil, types: nil, debug: false)
      Enumerator.new do |yielder|
        marker = nil
        loop do
          updates_list = get_updates_with_retry(limit: limit, timeout: timeout, marker: marker, types: types,
                                                debug: debug)
          updates = Array(updates_list[:updates])

          updates.each { |update| yielder << update }
          marker = updates_list[:marker] if updates_list[:marker]

          sleep(pause)
        end
      end
    end

    # Iterates over updates, yielding each update hash.
    def each_update(pause: DEFAULT_PAUSE, limit: DEFAULT_UPDATES_LIMIT, timeout: nil, types: nil, debug: false, &block)
      return updates_enum(pause: pause, limit: limit, timeout: timeout, types: types, debug: debug) unless block

      updates_enum(pause: pause, limit: limit, timeout: timeout, types: types, debug: debug).each(&block)
    end

    # Parses a single webhook payload into an update hash.
    def parse_webhook(body, debug: false)
      Updates::Parser.parse_update(body.to_s, debug: debug)
    end

    # Perform an HTTP request.
    # @param method [Symbol]
    # @param path [String]
    # @param query [Hash]
    # @param body [Hash, Array, String, nil]
    # @param headers [Hash]
    # @param reset [Boolean]
    def request(method, path, query: nil, body: nil, headers: {}, reset: false)
      query = (query || {}).dup
      query['v'] = version

      response = @conn.public_send(method) do |req|
        req.url(path.to_s.sub(%r{\A/}, ''))
        req.params.update(query) unless query.empty?
        req.headers['User-Agent'] = "max-bot-api-client-ruby/#{VERSION}"
        req.headers['Authorization'] = token unless reset
        headers.each { |k, v| req.headers[k] = v }

        if body
          if body.is_a?(Hash) || body.is_a?(Array)
            if multipart_body?(body)
              req.body = body
            else
              req.headers['Content-Type'] ||= 'application/json'
              req.body = JSON.generate(body)
            end
          else
            req.body = body
          end
        end
      end

      handle_response(response)
    rescue Faraday::TimeoutError => e
      raise TimeoutError.new(op: "#{method.to_s.upcase} #{path}", reason: e.message)
    rescue Faraday::ConnectionFailed, Faraday::SSLError, Faraday::Error => e
      raise NetworkError.new(op: "#{method.to_s.upcase} #{path}", original_error: e)
    rescue JSON::GeneratorError => e
      raise SerializationError.new(op: 'marshal', type: 'request body', original_error: e)
    end

    def http_client
      @conn
    end

    private

    def normalize_base_url(url)
      uri = URI.parse(url.to_s)
      raise InvalidUrlError, 'invalid API URL' if uri.scheme.nil? || uri.host.nil?

      normalized = uri.to_s
      normalized.end_with?('/') ? normalized : "#{normalized}/"
    rescue URI::InvalidURIError => e
      raise InvalidUrlError, "invalid API URL: #{e.message}"
    end

    def multipart_body?(body)
      body.values.any? { |value| value.is_a?(Faraday::Multipart::FilePart) }
    end

    def handle_response(response)
      return parse_body(response) if response.status == 200

      error_payload = parse_error_payload(response)
      raise ApiError.new(code: response.status, message: error_payload[:message], details: error_payload[:details])
    end

    def parse_body(response)
      content_type = response.headers['content-type'].to_s
      return response.body unless content_type.include?('application/json')

      body = response.body.to_s
      return nil if body.empty?

      JSON.parse(body, symbolize_names: true)
    end

    def parse_error_payload(response)
      body = response.body.to_s
      return { message: response.reason_phrase.to_s, details: nil } if body.empty?

      json = JSON.parse(body)
      if json.is_a?(Hash)
        return { message: json['code'], details: json['message'] } if json['code'] && json['message']
        return { message: json['error'], details: json['details'] || json['message'] } if json['error']
        return { message: json['message'], details: json['details'] } if json['message']
      end

      { message: response.reason_phrase.to_s, details: nil }
    rescue JSON::ParserError
      { message: response.reason_phrase.to_s, details: nil }
    end
  end
end
