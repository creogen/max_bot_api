# frozen_string_literal: true

require 'cgi'

module MaxBotApi
  module Resources
    # Messages API methods.
    class Messages
      def initialize(client)
        @client = client
      end

      # List messages with filters.
      def get_messages(chat_id: nil, message_ids: nil, from: nil, to: nil, count: nil)
        query = {}
        query['chat_id'] = chat_id if chat_id && chat_id.to_i != 0
        Array(message_ids).each do |mid|
          query['message_ids'] ||= []
          query['message_ids'] << mid
        end
        query['from'] = from if from && from.to_i != 0
        query['to'] = to if to && to.to_i != 0
        query['count'] = count if count && count.to_i > 0

        @client.request(:get, 'messages', query: normalize_array_query(query))
      end

      # Fetch a single message by ID.
      # @param message_id [String]
      def get_message(message_id:)
        path = "messages/#{CGI.escape(message_id.to_s)}"
        @client.request(:get, path)
      end

      # Edit a message by ID.
      # @param message_id [String]
      # @param message [MaxBotApi::Builders::MessageBuilder, Hash]
      def edit_message(message_id:, message:)
        body = message_payload(message)
        result = @client.request(:put, 'messages', query: { 'message_id' => message_id }, body: body)
        return true if result.is_a?(Hash) && result[:success]

        raise Error, (result[:message] || 'message update failed')
      end

      # Delete a message by ID.
      # @param message_id [String]
      def delete_message(message_id:)
        @client.request(:delete, 'messages', query: { 'message_id' => message_id })
      end

      # Answer a callback button press.
      # @param callback_id [String]
      # @param answer [Hash]
      def answer_on_callback(callback_id:, answer:)
        @client.request(:post, 'answers', query: { 'callback_id' => callback_id }, body: answer)
      end

      # Build a keyboard using the helper.
      def new_keyboard_builder
        Builders::KeyboardBuilder.new
      end

      # Send a message builder without returning the created message.
      # @param message [MaxBotApi::Builders::MessageBuilder, Hash]
      def send(message)
        send_message(message, with_result: false)
      end

      # Send a message builder and return the created message hash.
      # @param message [MaxBotApi::Builders::MessageBuilder, Hash]
      def send_with_result(message)
        send_message(message, with_result: true)
      end

      # Check if a message can be sent to the provided phone numbers.
      # @param message [MaxBotApi::Builders::MessageBuilder, Hash]
      def check(message)
        message = ensure_builder(message)
        query = {}
        query['access_token'] = message.bot_token if message.reset?
        query['phone_numbers'] = Array(message.phone_numbers).join(',') if message.phone_numbers

        result = @client.request(:get, 'notify/exists', query: query, reset: message.reset?)
        numbers = Array(result[:existing_phone_numbers])
        [!numbers.empty?, result]
      end

      # List phone numbers that exist in MAX.
      # @param message [MaxBotApi::Builders::MessageBuilder, Hash]
      def list_exist(message)
        message = ensure_builder(message)
        query = {}
        query['access_token'] = message.bot_token if message.reset?
        query['phone_numbers'] = Array(message.phone_numbers).join(',') if message.phone_numbers

        result = @client.request(:get, 'notify/exists', query: query, reset: message.reset?)
        numbers = Array(result[:existing_phone_numbers])
        [numbers.empty? ? nil : numbers, result]
      end

      private

      def send_message(message, with_result:)
        message = ensure_builder(message)
        query = {}
        query['chat_id'] = message.chat_id if message.chat_id && message.chat_id.to_i != 0
        query['user_id'] = message.user_id if message.user_id && message.user_id.to_i != 0

        response = @client.request(:post, 'messages', query: query, body: message_payload(message),
                                                      reset: message.reset?)
        return response[:message] if with_result && response.is_a?(Hash)

        nil
      end

      def message_payload(message)
        message.is_a?(Builders::MessageBuilder) ? message.to_h : message
      end

      def ensure_builder(message)
        return message if message.is_a?(Builders::MessageBuilder)

        Builders::MessageBuilder.from_hash(message)
      end

      def normalize_array_query(query)
        query.each_with_object({}) do |(key, value), acc|
          acc[key] = if value.is_a?(Array)
                       value
                     else
                       value
                     end
        end
      end
    end
  end
end
