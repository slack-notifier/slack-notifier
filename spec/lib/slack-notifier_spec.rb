# frozen_string_literal: true

RSpec.describe Slack::Notifier do
  let(:mock_http) do
    class_double("Slack::Notifier::Util::HTTPClient", post: :posted)
  end

  subject { described_class.new "http://example.com", http_client: mock_http }

  describe "#initialize" do
    it "sets the given hook_url to the endpoint URI" do
      expect(subject.endpoint).to eq URI.parse("http://example.com")
    end

    it "sets the default_payload options" do
      subject = described_class.new "http://example.com", channel: "foo"
      expect(subject.config.defaults[:channel]).to eq "foo"
    end

    it "sets a custom http client" do
      subject = described_class.new "http://example.com", http_client: mock_http
      expect(subject.config.http_client).to eq mock_http
    end

    describe "when given a block" do
      it "yields the config object" do
        test_double = double("Slack::Notifier::Config", defaults: {}, middleware: [])
        allow_any_instance_of(Slack::Notifier).to receive(:config).and_return(test_double)

        expect(test_double).to receive(:test_init_method).with("foo")

        described_class.new "http://example.com" do
          test_init_method "foo"
        end
      end
    end
  end

  describe "#ping" do
    it "calls #post with the message as the text key in #post" do
      subject = described_class.new "http://example.com"
      expect(subject).to receive(:post).with text: "message"

      subject.ping "message"
    end
  end

  describe "#post" do
    def notifier_with_defaults
      mock_client = mock_http
      described_class.new "http://example.com" do
        defaults channel: "default",
                 user:    "rocket"
        http_client mock_client
      end
    end

    it "uses the defaults set on initialization" do
      subject = notifier_with_defaults

      expect(mock_http).to receive(:post).with(
        URI.parse("http://example.com"),
        payload: '{"channel":"default","user":"rocket","text":"hello"}'
      )

      subject.post text: "hello"
    end

    it "allows overriding the set defaults" do
      subject = notifier_with_defaults

      expect(mock_http).to receive(:post).with(
        URI.parse("http://example.com"),
        payload: '{"channel":"new","user":"ship","text":"hello"}'
      )

      subject.post text: "hello", channel: "new", user: "ship"
    end

    # TODO: clean up middleware expectations

    it "allows sending only an attachment" do
      expect(mock_http).to receive(:post).with(
        URI.parse("http://example.com"),
        payload: '{"channel":"foo","attachments":[{"text":"attachment","fallback":"fallback"}]}'
      )

      expect do
        subject.post channel: "foo",
                     attachments: [{
                       text: "attachment",
                       fallback: "fallback"
                     }]
      end.not_to raise_error
    end

    it "passes the message through LinkFormatter" do
      expect(Slack::Notifier::Util::LinkFormatter)
        .to receive(:format)
        .with("the message")

      described_class.new("http://example.com").post text: "the message", channel: "foo"
    end

    it "passes attachment messages through LinkFormatter" do
      expect(Slack::Notifier::Util::LinkFormatter)
        .to receive(:format).with("the message")
      expect(Slack::Notifier::Util::LinkFormatter)
        .to receive(:format).with("attachment message")

      described_class.new("http://example.com").post text: "the message",
                                                     channel: "foo",
                                                     attachments: [{
                                                       color: "#000",
                                                       text: "attachment message",
                                                       fallback: "fallback message"
                                                     }]
    end

    it "passes attachment messages through LinkFormatter, even if a single value is passed" do
      expect(Slack::Notifier::Util::LinkFormatter).to receive(:format).with("a random message")
      expect(Slack::Notifier::Util::LinkFormatter).to receive(:format).with("attachment message")

      attachment = {
        color: "#000",
        text: "attachment message",
        fallback: "fallback message"
      }
      subject.post text: "a random message", attachments: attachment
    end
  end
end
