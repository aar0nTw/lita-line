require 'line/bot'
require 'lita/adapters/line/client'

module Lita
  module Adapters
    class Line < Adapter
      config :channel_secret, type: String, required: true
      config :channel_token, type: String, required: true

      attr_reader :client

      def run
        return if client
        @client = Client.new(config)
        client.run
      end

      def chat_service
        @client
      end

      def send_messages(target, messages)
        client.send_messages(target.room, messages)
      end

      def shut_down
        client.stop
      end

      Lita.register_adapter(:line, self)

    end
  end
end
