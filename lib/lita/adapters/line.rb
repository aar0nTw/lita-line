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

      def send_messages(target, messages)
        client.send_messages(target.room, messages)
      end

      Lita.register_adapter(:line, self)
    end
  end
end
