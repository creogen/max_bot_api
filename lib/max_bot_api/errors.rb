# frozen_string_literal: true

module MaxBotApi
  # Base error for all library exceptions.
  class Error < StandardError; end

  # Raised when the bot token is missing.
  class EmptyTokenError < Error; end
  # Raised when the base URL is invalid.
  class InvalidUrlError < Error; end

  # Raised when the API responds with a non-200 status code.
  class ApiError < Error
    attr_reader :code, :message, :details

    # @param code [Integer] HTTP status code
    # @param message [String] error message
    # @param details [String, nil] optional details
    def initialize(code:, message:, details: nil)
      @code = code
      @message = message
      @details = details
      super(build_message)
    end

    def ==(other)
      other.is_a?(ApiError) && other.code == code
    end

    def attachment_not_ready?
      message == 'attachment.not.ready'
    end

    private

    def build_message
      return "API error #{code}: #{message} (#{details})" if details && !details.empty?

      "API error #{code}: #{message}"
    end
  end

  # Raised when the HTTP request fails before reaching the API.
  class NetworkError < Error
    attr_reader :op, :original_error

    # @param op [String] operation name
    # @param original_error [Exception] original error
    def initialize(op:, original_error:)
      @op = op
      @original_error = original_error
      super("network error during #{op}: #{original_error}")
    end
  end

  # Raised when the request times out.
  class TimeoutError < Error
    attr_reader :op, :reason

    # @param op [String] operation name
    # @param reason [String, nil] timeout reason
    def initialize(op:, reason: nil)
      @op = op
      @reason = reason
      super(build_message)
    end

    def timeout?
      true
    end

    private

    def build_message
      return "timeout error during #{op}: #{reason}" if reason && !reason.empty?

      "timeout error during #{op}"
    end
  end

  # Raised when serialization or parsing fails.
  class SerializationError < Error
    attr_reader :op, :type, :original_error

    # @param op [String] operation name
    # @param type [String] serialized object type
    # @param original_error [Exception] original error
    def initialize(op:, type:, original_error:)
      @op = op
      @type = type
      @original_error = original_error
      super("serialization error during #{op} of #{type}: #{original_error}")
    end
  end
end
