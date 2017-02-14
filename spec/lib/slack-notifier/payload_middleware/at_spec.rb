RSpec.describe Slack::Notifier::PayloadMiddleware::At do

  it "can handle array at" do
    subject = described_class.new(:notifier, at: [])
    payload = {text: "hello", at: [:john, :ken, :here]}
    modified_payload = subject.call(payload)
    expect(modified_payload).to eq({text: "<@john> <@ken> <!here> hello"})
  end

  it "can handle single at option" do
    subject = described_class.new(:notifier, at: [])
    payload = {text: "hello", at: :alice}
    modified_payload = subject.call(payload)
    expect(modified_payload).to eq({text: "<@alice> hello"})
  end

  it "returns the payload unmodified if not :text key" do
    subject = described_class.new(:notifier, at: [])
    payload = { foo: :bar }
    expect(subject.call(payload)).to eq payload
  end
end
