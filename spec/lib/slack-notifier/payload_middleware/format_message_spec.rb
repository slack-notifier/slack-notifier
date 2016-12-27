# frozen_string_literal: true
RSpec.describe Slack::Notifier::PayloadMiddleware::FormatMessage do
  it "passes the text through linkformatter with options[:formats]" do
    subject = described_class.new(:notifier, formats: [:html])
    expect(Slack::Notifier::Util::LinkFormatter).to receive(:format)
      .with("hello", [:html])
    subject.call(text: "hello")

    subject = described_class.new(:notifier)
    expect(Slack::Notifier::Util::LinkFormatter).to receive(:format)
      .with("hello")
    subject.call(text: "hello")

    subject = described_class.new(:notifier, formats: [:markdown])
    expect(Slack::Notifier::Util::LinkFormatter).to receive(:format)
      .with("hello", [:markdown])
    subject.call(text: "hello")
  end

  it "returns the payload unmodified if not :text key" do
    payload = { foo: :bar }
    subject = described_class.new(:notifier)

    expect(subject.call(payload)).to eq payload
  end
end
