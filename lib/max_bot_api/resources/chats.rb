# frozen_string_literal: true

module MaxBotApi
  module Resources
    # Chats API methods.
    class Chats
      def initialize(client)
        @client = client
      end

      # List chats with pagination.
      # @param count [Integer, nil]
      # @param marker [Integer, nil]
      def get_chats(count: nil, marker: nil)
        query = {}
        query['count'] = count if count && count.to_i > 0
        query['marker'] = marker if marker && marker.to_i > 0
        @client.request(:get, 'chats', query: query)
      end

      # Fetch a single chat.
      # @param chat_id [Integer]
      def get_chat(chat_id:)
        @client.request(:get, "chats/#{chat_id}")
      end

      # Fetch current bot membership info.
      # @param chat_id [Integer]
      def get_chat_membership(chat_id:)
        @client.request(:get, "chats/#{chat_id}/members/me")
      end

      # List chat members.
      # @param chat_id [Integer]
      def get_chat_members(chat_id:, count: nil, marker: nil)
        query = {}
        query['count'] = count if count && count.to_i > 0
        query['marker'] = marker unless marker.nil?
        @client.request(:get, "chats/#{chat_id}/members", query: query)
      end

      # Fetch specific members by user IDs.
      # @param chat_id [Integer]
      # @param user_ids [Array<Integer>]
      def get_specific_chat_members(chat_id:, user_ids:)
        ids = Array(user_ids).map(&:to_s).join(',')
        @client.request(:get, "chats/#{chat_id}/members", query: { 'user_ids' => ids })
      end

      # List chat admins.
      # @param chat_id [Integer]
      def get_chat_admins(chat_id:)
        @client.request(:get, "chats/#{chat_id}/members/admins")
      end

      # Leave a chat.
      # @param chat_id [Integer]
      def leave_chat(chat_id:)
        @client.request(:delete, "chats/#{chat_id}/members/me")
      end

      # Patch chat info.
      # @param chat_id [Integer]
      # @param update [Hash]
      def edit_chat(chat_id:, update:)
        @client.request(:patch, "chats/#{chat_id}", body: update)
      end

      # Add members to chat.
      # @param chat_id [Integer]
      # @param users [Hash]
      def add_member(chat_id:, users:)
        @client.request(:post, "chats/#{chat_id}/members", body: users)
      end

      # Remove a member from chat.
      # @param chat_id [Integer]
      # @param user_id [Integer]
      def remove_member(chat_id:, user_id:)
        @client.request(:delete, "chats/#{chat_id}/members", query: { 'user_id' => user_id })
      end

      # Send a chat action.
      # @param chat_id [Integer]
      # @param action [String]
      def send_action(chat_id:, action:)
        @client.request(:post, "chats/#{chat_id}/actions", body: { action: action })
      end
    end
  end
end
