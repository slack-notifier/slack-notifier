require 'spec_helper'

describe Slack::Notifier do

  describe Slack::Notifier::LinkFormatter do
    it "formats html links" do
      formatted = Slack::Notifier::LinkFormatter.format("Hello World, enjoy <a href='http://example.com'>this</a>.")
      expect( formatted ).to include("<http://example.com|this>")
    end

    it "formats markdown links" do
      formatted = Slack::Notifier::LinkFormatter.format("Hello World, enjoy [http://example.com](this).")
      expect( formatted ).to include("<http://example.com|this>")
    end

    it "formats markdown links with no title" do
      formatted = Slack::Notifier::LinkFormatter.format("Hello World, enjoy [http://example.com]().")
      expect( formatted ).to include("<http://example.com>")
    end
  end

end