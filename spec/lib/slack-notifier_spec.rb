require 'spec_helper'

describe Slack::Notifier do

  describe "#initialize" do
    it "sets the given team" do
      subject = described_class.new 'team', 'token'
      expect( subject.team ).to eq 'team'
    end

    it "sets the given token" do
      subject = described_class.new 'team', 'token'
      expect( subject.token ).to eq 'token'
    end
  end

  describe "#ping" do
    it "passes the message through LinkFormatter" do
      allow( HTTParty ).to receive(:post)
      expect( Slack::Notifier::LinkFormatter ).to receive(:format)
                                              .with("the message")

      described_class.new('team','token').ping "the message", channel: 'foo'
    end

    it "requires a channel to be set" do
      allow( HTTParty ).to receive(:post)

      expect{
        described_class.new('team','token').ping "the message"
      }.to raise_error
    end

    context "with a default channel set" do

      before :each do
        allow( HTTParty ).to receive(:post)
        @subject = described_class.new('team','token')
        @subject.channel = 'default'
      end

      it "does not require a channel to ping" do
        expect{
          @subject.ping "the message"
        }.not_to raise_error
      end

      it "uses default channel" do
        expect( HTTParty ).to receive(:post)
                          .with "https://team.slack.com/services/hooks/incoming-webhook?token=token",
                                body: 'payload={"text":"the message","channel":"default"}'

        @subject.ping "the message"
      end

      it "allows override channel to be set" do
        expect( HTTParty ).to receive(:post)
                          .with "https://team.slack.com/services/hooks/incoming-webhook?token=token",
                                body: 'payload={"text":"the message","channel":"new"}'

        @subject.ping "the message", channel: "new"
      end

    end

    it "posts with the correct endpoint & data" do
        expect( HTTParty ).to receive(:post)
                          .with "https://team.slack.com/services/hooks/incoming-webhook?token=token",
                                body: 'payload={"text":"the message","channel":"channel"}'

        described_class.new("team","token").ping "the message", channel: "channel"
    end
  end

end