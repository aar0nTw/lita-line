module Lita
  module Handlers
    class Webhook < Handler
      attr_reader :client
      attr_reader :robot

      def initialize(robot)
        @robot = robot
        @client = robot.chat_service.client
      end

      def log
        Lita.logger
      end

      def callback(request, response)
        body = request.body.read
        signature = request.env['HTTP_X_LINE_SIGNATURE']
        unless client.validate_signature(body, signature)
          log.info "Unvalidate Signature: #{signature}"
          response.status = 401
        else
          response.status = 200
          events = client.parse_events_from(body)
          events.map do |event|
            case event
            when ::Line::Bot::Event::Message
              case event.type
              when ::Line::Bot::Event::MessageType::Text
                log.info "Webhook: #{DateTime.strptime(event['timestamp'].to_s, '%Q').to_s}[#{event.message['id']}##{event.message['type']}]: #{event.message['text']} "
                # TODO Parse user from event
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

      http.post "/callback", :callback

      Lita.register_handler(self)
    end
  end
end
