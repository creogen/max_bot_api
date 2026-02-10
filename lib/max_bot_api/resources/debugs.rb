# frozen_string_literal: true

module MaxBotApi
  module Resources
    # Debug helper for sending raw updates/errors to a chat.
    class Debugs
      def initialize(client, chat_id: 0)
        @client = client
        @chat_id = chat_id
      end

      # Send raw update debug text to the configured chat.
      # @param update [Hash]
      def send(update)
        message = Builders::MessageBuilder.new
                                          .set_chat(@chat_id)
                                          .set_text(update[:debug_raw].to_s)

        @client.request(:post, 'messages', query: { 'chat_id' => @chat_id }, body: message.to_h)
        true
      end

      # Send an error message to the configured chat.
      # @param error [Exception, String]
      def send_err(error)
        message = Builders::MessageBuilder.new
                                          .set_chat(@chat_id)
                                          .set_text(error.to_s)

        @client.request(:post, 'messages', query: { 'chat_id' => @chat_id }, body: message.to_h)
        true
      end
    end
  end
end
