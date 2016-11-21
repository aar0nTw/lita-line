require "spec_helper"

describe Lita::Handlers::Webhook, lita_handler: true do

  let(:client) { double }

  before do
    robot.stub_chain(:chat_service, :client).and_return client
  end

  describe 'Handler Initialize' do

    it 'attr client' do
      expect(subject.client).to eq(client)
    end

    it 'Lita.logger alias' do
      expect(subject.log).to be Lita.logger
    end

    it 'should register callback http route' do
      is_expected.to route_http(:post, '/callback').to(:callback)
    end
  end

  describe 'Handler callback' do
    let(:request) { double }
    let(:response) { double }
    let(:config) { double }
    let(:body) { <<EOS
{
  "events": [
      {
        "replyToken": "reply_token",
        "type": "message",
        "timestamp": 1462629479859,
        "source": {
             "type": "user",
             "userId": "U206d25c2ea6bd87c17655609a1c37cb8"
         },
         "message": {
             "id": "325708",
             "type": "text",
             "text": "Hello, world"
          }
      }
  ]
    }
EOS
    }
    let(:signature) { double }
    let(:env) { {'HTTP_X_LINE_SIGNATURE': signature} }

    before do
      allow(
        response
      ).to receive(:finish)
      request.stub_chain(:body, :read).and_return body
      request.stub(:env).and_return env
      config.stub(:channel_secret).and_return 'secret'
      config.stub(:channel_token).and_return 'token'
      robot.stub_chain(:chat_service, :client).and_return(Lita::Adapters::Line::Client.new(robot, config).client)
    end

    it 'HTTP 401 when Line signature unvalidated' do
      Line::Bot::Client.any_instance.stub(:validate_signature => false)
      allow(response).to receive(:status=)
      subject.callback(request, response)
      expect(response).to have_received(:status=).with(401)
    end

    it "HTTP 200 when validate_signature" do
      Line::Bot::Client.any_instance.stub(:validate_signature => true)
      expect(response).to receive(:status=).with(200)
      subject.callback(request, response)
    end
  end
end

