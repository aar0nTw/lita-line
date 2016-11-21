require 'line/bot'

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
          if robot.config.robot.adapter == :line
            robot.registry.register_handler(:line_callback) do
              http.post '/callback' do |request, response|
                body = request.body.read

                signature = request.env['HTTP_X_LINE_SIGNATURE']
                unless robot.chat_service.client.validate_signature(body, signature)
                  response.status '401'
                  response.write 'Unauthorized'
                  response.finish!
                end
                response.write 'OK'
              end
            end
          end
        end

        def run
          EM.run do
            log.info "Running client"
          end
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

        private
        def log
          Lita.logger
        end
      end
    end
  end
end
