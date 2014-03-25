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

    it 'sets the optional service hook name' do
      subject = described_class.new 'team', 'token', 'custom_hook_name'
      expect( subject.hook_name ).to eq 'custom_hook_name'
    end
  end

  describe "#ping" do
    before :each do
      allow( Net::HTTP ).to receive(:post_form)
    end

    it "passes the message through LinkFormatter" do
      expect( Slack::Notifier::LinkFormatter ).to receive(:format)
                                              .with("the message")

      described_class.new('team','token').ping "the message", channel: 'foo'
    end

    context "with a default channel set" do

      before :each do
        @endpoint_double = instance_double "URI::HTTP"
        allow( URI ).to receive(:parse)
                    .and_return(@endpoint_double)
        @subject = described_class.new('team','token')
        @subject.channel = 'default'
      end

      it "does not require a channel to ping" do
        expect{
          @subject.ping "the message"
        }.not_to raise_error
      end

      it "uses default channel" do
        expect( Net::HTTP ).to receive(:post_form)
                          .with @endpoint_double,
                                payload: '{"text":"the message","channel":"default"}'

        @subject.ping "the message"
      end

      it "allows override channel to be set" do
        expect( Net::HTTP ).to receive(:post_form)
                          .with @endpoint_double,
                                payload: '{"text":"the message","channel":"new"}'

        @subject.ping "the message", channel: "new"
      end

    end

    context "with default webhook" do
      it "posts with the correct endpoint & data" do
          @endpoint_double = instance_double "URI::HTTP"
          allow( URI ).to receive(:parse)
                      .with("https://team.slack.com/services/hooks/incoming-webhook?token=token")
                      .and_return(@endpoint_double)

          expect( Net::HTTP ).to receive(:post_form)
                            .with @endpoint_double,
                                  payload: '{"text":"the message","channel":"channel"}'

          described_class.new("team","token").ping "the message", channel: "channel"
      end
    end

    context "with custom webhook name" do
      it "posts with the correct endpoint & data" do
        @endpoint_double = instance_double "URI::HTTP"
        allow( URI ).to receive(:parse)
                    .with("https://team.slack.com/services/hooks/custom_hook_name?token=token")
                    .and_return(@endpoint_double)

        expect( Net::HTTP ).to receive(:post_form)
                          .with @endpoint_double,
                                payload: '{"text":"the message","channel":"channel"}'

        described_class.new("team","token","custom_hook_name").ping "the message", channel: "channel"
      end
    end
  end

end
