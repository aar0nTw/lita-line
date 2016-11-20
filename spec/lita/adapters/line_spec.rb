require "spec_helper"
require "pry"

describe Lita::Adapters::Line, lita: true do
  subject { described_class.new(robot) }

  let(:robot) { Lita::Robot.new(registry) }
  let(:secret) { 'channel-secret' }
  let(:token) { 'channel-token' }

  before do
    registry.register_adapter(:line, described_class)
    registry.config.adapters.line.channel_secret = secret
    registry.config.adapters.line.channel_token = token
  end

  it 'Register adapter' do
    expect(Lita.adapters[:line]).to eql(described_class)
  end

  it 'running' do
    subject.run
    expect(subject.client).to be_a(described_class::Client)
  end

  describe 'send messages' do
    let(:room_source) {Lita::Source.new(room: "reply_token")}
    let(:messages) {["Hello world"]}
    let(:client) {instance_double('Lita::Adapters::Line::Client')}
    before do
      allow(described_class::Client).to receive(:new).with(subject.config).and_return(client)
      allow(client).to receive(:send_messages).with(room_source.room, messages)
    end

    it "Send messages by client" do
      expect(client).to receive(:send_messages).with(room_source.room, messages)
      subject.run
      subject.send_messages(room_source, messages)
    end
  end

end
