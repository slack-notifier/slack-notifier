RSpec.describe Slack::Notifier::Config do
  describe "#endpoint=" do
    it "sets #endpoint with parsed URI" do
      subject = described_class.new
      subject.endpoint = "http://example.com"

      expect( subject.endpoint ).to be_a URI
      expect( subject.endpoint.host ).to eq "example.com"
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
