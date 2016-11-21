require 'spec_helper'
require 'line/bot'
require 'pry'

describe Lita::Adapters::Line::Client, lita: true do
  subject { described_class.new(robot, config) }
  let(:robot) { Lita::Robot.new(registry) }
  let(:line_client) {instance_double("Line::Bot::Client")}
  let(:reply_token) { "reply_token" }
  let(:config) { double }
  let(:EM) { double }
  before do
    allow(line_client).to receive(:reply_message)
    config.stub(:channel_secret)
    config.stub(:channel_token)
  end

  it 'Should have a client' do
    allow(Line::Bot::Client).to receive(:new).and_return(line_client)
    expect(subject.client).to eq(line_client)
  end

  it 'LineBotClien init' do
    expect(config).to receive(:channel_secret)
    expect(config).to receive(:channel_token)
    described_class.new(nil, config)
  end

  it 'run should use EventMachine' do
    allow(EM).to receive(:run)
    subject.run
    expect(EM).to have_received(:run)
  end

  it 'run should receive log' do
    allow(EM).to receive(:run)
    allow(subject).to receive(:log).and_return(Lita.logger)
    expect(subject).to receive(:log)
    subject.run
  end

  it 'Graceful stop by EM.stop' do
    allow(EM).to receive(:stop)
    allow(EM).to receive(:reactor_running?).and_return(true)
    subject.stop
    expect(EM).to have_received(:stop)
  end

  it 'Doesnt call EM.stop when EM.reactor not running' do
    allow(EM).to receive(:stop)
    allow(EM).to receive(:reactor_running?).and_return(false)
    subject.stop
    expect(EM).not_to have_received(:stop)
  end

  it 'When send messages format_msg should be called' do
    expect(subject).to receive(:format_msg)
    subject.send_messages(reply_token, ['foo'])
  end

  it 'use client.reply_message for send message' do
    allow(Line::Bot::Client).to receive(:new).and_return(line_client)
    expect(line_client).to receive(:reply_message)
    subject.send_messages(reply_token, ['foo'])
  end

  it 'format_msg should return a dictionary' do
    expect(subject.format_msg(['foo'])).to eq [{ type: :text, text: 'foo' }]
  end

end
