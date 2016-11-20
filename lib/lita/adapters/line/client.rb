require 'line/bot'

module Lita
  module Adapters
    class Line < Adapter
      class Client
        attr_reader :client
        def initialize(config)
          @client = ::Line::Bot::Client.new { |c|
            c.channel_secret = config.channel_secret
            c.channel_token = config.channel_token
          }
        end

        def send_messages(reply_token, messages)
          client.reply_message(reply_token, format_msg(messages))
        end

        def format_msg(messages)
          messages.map do |message|
            {
              type: :text,
              text: message
            }
          end
        end
      end
    end
  end
end
