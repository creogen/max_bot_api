# frozen_string_literal: true

module MaxBotApi
  module Updates
    # Update parsing helpers.
    class Parser
      # Parse a single update JSON string or hash.
      # @param data [String, Hash]
      # @param debug [Boolean]
      # @return [Hash]
      def self.parse_update(data, debug: false)
        raw = data.is_a?(String) ? data : JSON.generate(data)
        update = data.is_a?(Hash) ? deep_symbolize_keys(data) : JSON.parse(raw, symbolize_names: true)

        update[:debug_raw] = raw if debug
        normalize_attachments!(update)
        update
      end

      # Parse a list of updates.
      # @param data [String, Hash]
      # @param debug [Boolean]
      # @return [Hash]
      def self.parse_update_list(data, debug: false)
        list = data.is_a?(Hash) ? data : JSON.parse(data.to_s, symbolize_names: true)
        updates = Array(list[:updates])
        list[:updates] = updates.map { |u| parse_update(u, debug: debug) }
        list
      end

      # Normalize attachment payloads to symbolized hashes.
      def self.normalize_attachments!(update)
        message = update.dig(:message)
        body = message && message[:body]
        if body && body[:attachments].is_a?(Array)
          body[:attachments] = body[:attachments].map { |att| deep_symbolize_keys(att) }
        end

        linked_body = update.dig(:message, :link, :message, :attachments)
        return unless linked_body.is_a?(Array)

        update[:message][:link][:message][:attachments] = linked_body.map { |att| deep_symbolize_keys(att) }
      end

      # Deep symbolize hash keys.
      def self.deep_symbolize_keys(value)
        case value
        when Hash
          value.each_with_object({}) do |(k, v), acc|
            acc[k.to_sym] = deep_symbolize_keys(v)
          end
        when Array
          value.map { |item| deep_symbolize_keys(item) }
        else
          value
        end
      end
    end
  end
end
