# frozen_string_literal: true
RSpec.describe Slack::Notifier::PayloadMiddleware::FormatAttachments do
  it "passes the text of attachments through linkformatter with options[:formats]" do
    subject = described_class.new(:notifier, formats: [:html])
    expect(Slack::Notifier::Util::LinkFormatter).to receive(:format)
      .with("hello", [:html])
    subject.call(attachments: [{ text: "hello" }])
  end

  it "searches through string or symbol keys" do
    subject = described_class.new(:notifier)
    expect(Slack::Notifier::Util::LinkFormatter).to receive(:format)
      .with("hello")
    subject.call("attachments" => [{ "text" => "hello" }])

    subject = described_class.new(:notifier)
    expect(Slack::Notifier::Util::LinkFormatter).to receive(:format)
      .with("hello")
    subject.call(attachments: [{ text: "hello" }])
  end

  it "can handle a single attachment" do
    subject = described_class.new(:notifier)
    expect(Slack::Notifier::Util::LinkFormatter).to receive(:format)
      .with("hello")
    subject.call(attachments: { text: "hello" })
  end

  it "returns the payload unmodified if not :attachments key" do
    payload = { foo: :bar }
    subject = described_class.new(:notifier)

    expect(subject.call(payload)).to eq payload
  end
end
