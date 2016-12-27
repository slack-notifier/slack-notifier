# frozen_string_literal: true

RSpec.describe Slack::Notifier::Config do
  describe "#endpoint=" do
    it "sets #endpoint with parsed URI" do
      subject = described_class.new
      subject.endpoint = "http://example.com"

      expect(subject.endpoint).to be_a URI
      expect(subject.endpoint.host).to eq "example.com"
    end
  end

  describe "#http_client" do
    it "is Util::HTTPClient if not set" do
      subject = described_class.new
      expect(subject.http_client).to eq Slack::Notifier::Util::HTTPClient
    end

    it "sets a new client class if given one" do
      new_client = class_double("Slack::Notifier::Util::HTTPClient", post: nil)
      subject    = described_class.new
      subject.http_client new_client
      expect(subject.http_client).to eq new_client
    end

    it "raises an ArgumentError if given class does not respond to ::post" do
      subject = described_class.new
      expect do
        subject.http_client :nope
      end.to raise_error ArgumentError
    end
  end

    end
  end

  %w[client defaults middleware].each do |config_method|
    it "sets the value(s) when called with arguments, returns when called with none" do
      args = %w[one two]
      subject = described_class.new
      subject.send(config_method, args[0])

      expect( subject.send(config_method) ).to eq args[0]

      subject.send(config_method, *args)
      expect( subject.send(config_method) ).to eq args
    end
  end
end
