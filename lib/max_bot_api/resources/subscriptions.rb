# frozen_string_literal: true

module MaxBotApi
  module Resources
    # Webhook subscription methods.
    class Subscriptions
      def initialize(client)
        @client = client
      end

      # List active subscriptions.
      def get_subscriptions
        @client.request(:get, 'subscriptions')
      end

      # Create a webhook subscription.
      # @param url [String]
      # @param update_types [Array<String>]
      # @param secret [String, nil]
      def subscribe(url:, update_types: [], secret: nil)
        body = {
          url: url,
          update_types: update_types,
          secret: secret,
          version: @client.version
        }.compact

        @client.request(:post, 'subscriptions', body: body)
      end

      # Remove a webhook subscription.
      # @param url [String]
      def unsubscribe(url:)
        @client.request(:delete, 'subscriptions', query: { 'url' => url })
      end
    end
  end
end
