# frozen_string_literal: true

module MaxBotApi
  module Resources
    # Bots API methods.
    class Bots
      def initialize(client)
        @client = client
      end

      # Get current bot info.
      def get_bot
        @client.request(:get, 'me')
      end

      # Patch current bot info.
      # @param patch [Hash]
      def patch_bot(patch)
        @client.request(:patch, 'me', body: patch)
      end
    end
  end
end
