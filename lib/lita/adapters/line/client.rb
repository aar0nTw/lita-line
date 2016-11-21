require 'line/bot'
require 'eventmachine'

module Lita
  module Adapters
    class Line < Adapter
      class Client
        attr_reader :client
        def initialize(robot, config)
          @client = ::Line::Bot::Client.new { |c|
            c.channel_secret = config.channel_secret
            c.channel_token = config.channel_token
          }
        end

        def run
          log.info "Running client"
          EM.run do
          end
        end

        def stop
          EM.stop if EM.reactor_running?
        end

        def send_messages(reply_token, messages)
          messages = format_msg messages
          log.info "Send message to ##{reply_token}, #{messages}"
          client.reply_message(reply_token, messages)
        end

        def format_msg(messages)
          messages.map do |message|
            {
              type: :text,
              text: message
            }
          end
        end

        private
        def log
          Lita.logger
        end
      end
    end
  end
end
