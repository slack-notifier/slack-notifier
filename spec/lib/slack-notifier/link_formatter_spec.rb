require 'spec_helper'

describe Slack::Notifier::LinkFormatter do

  describe "::format" do

    it "formats html links" do
      formatted = described_class.format("Hello World, enjoy <a href='http://example.com'>this</a>.")
      expect( formatted ).to include("<http://example.com|this>")
    end

    it "formats markdown links" do
      formatted = described_class.format("Hello World, enjoy [this](http://example.com).")
      expect( formatted ).to include("<http://example.com|this>")
    end

    it "formats markdown links with no title" do
      formatted = described_class.format("Hello World, enjoy [](http://example.com).")
      expect( formatted ).to include("<http://example.com>")
    end

  end

end