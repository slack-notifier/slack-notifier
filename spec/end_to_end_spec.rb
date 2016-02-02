require 'spec_helper'

RSpec.describe Slack::Notifier do

  before :each do
    @http_client = double("Slack::Notifier::DefaultHTTPClient")
  end

  {
    ['hello', {}] =>
      { payload: { text:"hello" }.to_json },

    ['[hello](http://example.com/world)', {}] =>
      { payload: { text: '<http://example.com/world|hello>' }.to_json },

    ['<a href="http://example.com">example</a>', {}] =>
      { payload: { text: '<http://example.com|example>' }.to_json }

  }.each do |args, payload|

    it "sends correct payload for #{args}" do
      msg, options = *args
      msg, options = '', msg if options.nil?

      notifier = Slack::Notifier.new 'http://example.com', http_client: @http_client

      expect( @http_client ).to receive(:post)
                            .with( URI.parse('http://example.com'),
                                    payload )

      notifier.ping msg, options
    end
  end


end
