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
        @client = Client.new(robot, config)
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
      Lita.register_handler(:line_callback) do
        http.post 'callback' do |request, response|
          client = robot.chat_service.client
          body = request.body.read
          signature = request.env['HTTP_X_LINE_SIGNATURE']
          unless robot.chat_service.client.validate_signature(body, signature)
            Lita.logger.info "Unvalidate Signature: #{signature}"
            response.status = 401
          else
            response.status = 200
            events = client.parse_events_from(body)
            events.map do |event|
              case event
              when ::Line::Bot::Event::Message
                case event.type
                when ::Line::Bot::Event::MessageType::Text
                  Lita.logger.info "Income: #{DateTime.strptime(event['timestamp'].to_s, '%Q').to_s}[#{event.message['id']}##{event.message['type']}]: #{event.message['text']} "
                  user = Lita::User.create('guest', {
                    name: 'Guest'
                  })
                  source = Lita::Source.new(user: user, room: event['replyToken'])
                  message = Lita::Message.new(robot, event.message['text'], source)
                  robot.receive(message)
                end
              end
            end
          end
          response.finish
        end
      end
    end
  end
end
