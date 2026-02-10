# frozen_string_literal: true

module MaxBotApi
  module Builders
    # Builder for message payloads.
    class MessageBuilder
      attr_reader :user_id, :chat_id, :reset

      # Create a builder from an existing hash payload.
      # @param hash [Hash]
      # @return [MessageBuilder]
      def self.from_hash(hash)
        builder = new
        return builder if hash.nil?

        builder.set_user(hash[:user_id] || hash['user_id']) if hash.key?(:user_id) || hash.key?('user_id')
        builder.set_chat(hash[:chat_id] || hash['chat_id']) if hash.key?(:chat_id) || hash.key?('chat_id')
        builder.set_reset(hash[:reset] || hash['reset']) if hash.key?(:reset) || hash.key?('reset')

        payload = hash[:message] || hash['message'] || hash
        builder.apply_payload(payload)
        builder
      end

      # Initialize a new builder with empty payload.
      def initialize
        @user_id = nil
        @chat_id = nil
        @reset = false
        @message = {
          attachments: []
        }
      end

      # Set recipient user ID.
      def set_user(user_id)
        @user_id = user_id
        self
      end

      # Set recipient chat ID.
      def set_chat(chat_id)
        @chat_id = chat_id
        self
      end

      # Toggle reset mode (skip Authorization header).
      def set_reset(reset)
        @reset = !!reset
        self
      end

      # Set message text.
      def set_text(text)
        @message[:text] = text
        self
      end

      # Set message format (markdown/html).
      def set_format(format)
        @message[:format] = format
        self
      end

      # Toggle notification flag.
      def set_notify(notify)
        @message[:notify] = notify
        self
      end

      # Set reply with explicit message ID.
      def set_reply(text, message_id)
        @message[:text] = text
        @message[:link] = { type: 'reply', mid: message_id }
        self
      end

      # Reply to a message hash with inferred recipient.
      def reply(text, reply_message)
        recipient = reply_message[:recipient] || reply_message['recipient'] || {}
        set_user(recipient[:user_id] || recipient['user_id']) if recipient[:user_id] || recipient['user_id']
        set_chat(recipient[:chat_id] || recipient['chat_id']) if recipient[:chat_id] || recipient['chat_id']

        body = reply_message[:body] || reply_message['body'] || {}
        @message[:text] = text
        @message[:link] = { type: 'reply', mid: body[:mid] || body['mid'] }
        self
      end

      # Add user mention markup.
      def add_markup(user_id, from, length)
        @message[:markup] ||= []
        @message[:markup] << { user_id: user_id, from: from, length: length, type: 'user_mention' }
        self
      end

      # Attach a keyboard.
      def add_keyboard(keyboard)
        payload = keyboard.is_a?(Builders::KeyboardBuilder) ? keyboard.build : keyboard
        add_attachment(type: 'inline_keyboard', payload: payload)
      end

      # Attach a photo payload.
      def add_photo(photo_tokens)
        payload = photo_tokens.is_a?(Hash) ? photo_tokens : { photos: photo_tokens }
        add_attachment(type: 'image', payload: { photos: payload[:photos] || payload['photos'] })
      end

      # Attach audio payload.
      def add_audio(uploaded_info)
        add_attachment(type: 'audio', payload: uploaded_info)
      end

      # Attach video payload.
      def add_video(uploaded_info)
        add_attachment(type: 'video', payload: uploaded_info)
      end

      # Attach file payload.
      def add_file(uploaded_info)
        add_attachment(type: 'file', payload: uploaded_info)
      end

      # Attach a location.
      def add_location(lat, lon)
        add_attachment(type: 'location', latitude: lat, longitude: lon)
      end

      # Attach a contact card.
      def add_contact(name:, contact_id:, vcf_info: nil, vcf_phone: nil)
        payload = {
          name: name,
          contact_id: contact_id,
          vcf_info: vcf_info,
          vcf_phone: vcf_phone
        }.compact
        add_attachment(type: 'contact', payload: payload)
      end

      # Attach a sticker.
      def add_sticker(code)
        add_attachment(type: 'sticker', payload: { code: code })
      end

      # Set bot token for reset mode.
      def set_bot_token(token)
        @message[:bot_token] = token
        self
      end

      # Set phone numbers for notify/exists.
      def set_phone_numbers(numbers)
        @message[:phone_numbers] = Array(numbers)
        self
      end

      # Return bot token used for reset mode.
      def bot_token
        @message[:bot_token]
      end

      # Return phone numbers used for notify/exists.
      def phone_numbers
        @message[:phone_numbers]
      end

      # Whether reset mode is enabled.
      def reset?
        @reset
      end

      # Return the message payload hash.
      def to_h
        @message
      end

      protected

      def apply_payload(payload)
        return if payload.nil?

        payload.each do |key, value|
          @message[key.to_sym] = value
        end
      end

      private

      def add_attachment(attachment)
        @message[:attachments] ||= []
        @message[:attachments] << attachment
        self
      end
    end
  end
end
