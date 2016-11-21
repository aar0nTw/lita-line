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
    let(:body) { double }
    let(:signature) { double }
    let(:env) { {'HTTP_X_LINE_SIGNATURE': signature} }

    before do
      allow(
        response
      ).to receive(:finish)
      request.stub_chain(:body, :read).and_return body
      request.stub(:env).and_return env
    end

    it 'HTTP 401 when Line signature unvalidated' do
      client.stub(:validate_signature).and_return false
      allow(response).to receive(:status=).with(401)
      subject.callback(request, response)
      expect(response).to have_received(:status=)
    end
  end
end

