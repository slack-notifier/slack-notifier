RSpec.describe Slack::Notifier::PayloadMiddleware::Base do

  after(:each) do
    # cleanup middleware registry
    Slack::Notifier::PayloadMiddleware.remove_instance_variable(:@registry)

    # cleanup object constants
    Object.remove_const(:Subject) if Object.constants.include?(:Subject)
  end

  describe "::middleware_name" do
    it "registers class w/ given name" do
      expect( Slack::Notifier::PayloadMiddleware ).to receive(:register)
                                                  .with(duck_type(:notifier), :subject)

      class Subject < Base
        middleware_name :subject
      end
    end

    it "uses symbolized name to register" do
      expect( Slack::Notifier::PayloadMiddleware ).to receive(:register)
                                                  .with(duck_type(:notifier), :subject)

      class Subject < Base
        middleware_name 'subject'
      end
    end
  end

  describe "#initialize" do
    it "sets given notifier as notifier" do
      expect( described_class.new(:notifier).notifier ).to eq :notifier
    end
  end

  describe "#call" do
    it "raises NoMethodError (expects subclass to define)" do
      expect{
        described_class.new(:notifier).call
      }.to raise_exception NoMethodError
    end
  end

end
