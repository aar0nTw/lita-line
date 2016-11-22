require "spec_helper"
# Main test
describe Lita::Adapters::Line, lita: true do
  subject { described_class.new(robot) }

  let(:robot) { Lita::Robot.new(registry) }
  let(:secret) { 'channel-secret' }
  let(:client_type) { described_class::Client }
  let(:client) { instance_double("#{described_class}::Client") }
  let(:token) { 'channel-token' }

  before do
    registry.register_adapter(:line, described_class)
    registry.config.adapters.line.channel_secret = secret
    registry.config.adapters.line.channel_token = token
    robot.config.robot.adapter = :line

    allow(client).to receive(:run)
  end

  it 'Register adapter' do
    expect(Lita.adapters[:line]).to eql(described_class)
  end

  it 'running' do
    described_class::Client.any_instance.stub(:run)
    subject.run
    expect(subject.client).to be_a client_type
  end

  describe "Client#run" do
    before do
      allow(
        described_class::Client
      ).to receive(:new).with(subject.config).and_return(client)
    end
    it 'client will run when adapter run' do
      expect(client).to receive(:run)
      subject.run
    end

    it 'Only run once' do
      expect(client).to receive(:run).once
      subject.run
      subject.run
    end

    it 'Chat service' do
      subject.run
      expect(subject.chat_service).to eq(client)
    end

    it 'Shut down will call client.stop' do
      expect(client).to receive(:stop)
      subject.run
      subject.shut_down
    end

    describe 'Client#send_messages' do
      let(:room_source) {Lita::Source.new(room: "reply_token")}
      let(:messages) {["Hello world"]}

      it "Send messages by client" do
        expect(client).to receive(:send_messages).with(room_source.room, messages)
        subject.run
        subject.send_messages(room_source, messages)
      end
    end
  end
end

