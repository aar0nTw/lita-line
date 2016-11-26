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
                log.info "Webhook: #{DateTime.strptime(event['timestamp'].to_s, '%Q')}[#{event.message['id']}##{event.message['type']}]: #{event.message['text']} "
                user = create_user event['source']
                source = Lita::Source.new(user: user, room: event['replyToken'])
                message = Lita::Message.new(robot, event.message['text'], source)
                robot.receive(message)
              end
            end
          end
        end
        response.finish
      end

      def create_user(event_source)
        source_type = event_source['type']
        user = Lita::User.create(event_source["#{source_type}Id"], { type: source_type })
        log.info "Create User: #{user.id} - #{user.metadata}"
        user
      end

      http.post "/callback", :callback

      Lita.register_handler(self)
    end
  end
end
