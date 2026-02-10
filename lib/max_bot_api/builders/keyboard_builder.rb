# frozen_string_literal: true

module MaxBotApi
  module Builders
    # Builder for inline keyboards.
    class KeyboardBuilder
      def initialize
        @rows = []
      end

      # Add a new row to the keyboard.
      def add_row
        row = KeyboardRowBuilder.new
        @rows << row
        row
      end

      # Build keyboard payload.
      def build
        { buttons: @rows.map(&:build) }
      end
    end

    # Builder for a single keyboard row.
    class KeyboardRowBuilder
      def initialize
        @cols = []
      end

      # Add a prebuilt button hash.
      def add_button(button)
        @cols << button
        self
      end

      # Add a link button.
      def add_link(text, _intent, url)
        button = {
          type: 'link',
          text: text,
          url: url
        }
        add_button(button)
      end

      # Add a callback button.
      def add_callback(text, intent, payload)
        button = {
          type: 'callback',
          text: text,
          payload: payload,
          intent: intent
        }
        add_button(button)
      end

      # Add a contact request button.
      def add_contact(text)
        button = {
          type: 'request_contact',
          text: text
        }
        add_button(button)
      end

      # Add a geolocation request button.
      def add_geolocation(text, quick)
        button = {
          type: 'request_geo_location',
          text: text,
          quick: quick
        }
        add_button(button)
      end

      # Add an open app button.
      def add_open_app(text, app, payload, contact_id)
        button = {
          type: 'open_app',
          text: text,
          web_app: app,
          payload: payload,
          contact_id: contact_id
        }
        add_button(button)
      end

      # Build row payload.
      def build
        @cols
      end
    end
  end
end
