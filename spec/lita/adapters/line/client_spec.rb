require 'spec_helper'
require 'line/bot'

describe Lita::Adapters::Line::Client, lita: true do
  subject { described_class.new(registry.config) }
  let(:line_client) {instance_double("Line::Bot::Client")}
  let(:reply_token) { "reply_token" }
  before do
    allow(Line::Bot::Client).to receive(:new).and_return(line_client)
    allow(line_client).to receive(:reply_message)
  end

  it 'Should have a client' do
    expect(subject.client).to eq(line_client)
  end

  it 'When send messages format_msg should be called' do
    expect(subject).to receive(:format_msg)
    subject.send_messages(reply_token, ['foo'])
  end

  it 'format_msg should return a dictionary' do
    expect(subject.format_msg(['foo'])).to eq [{ type: :text, text: 'foo' }]
  end

end
