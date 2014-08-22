require 'spec_helper'

describe Slack::Notifier::DefaultHTTPClient do

  describe "::to" do
    it "initializes DefaultHTTPClient with the given uri and params then calls" do
      http_post_double = instance_double("Slack::Notifier::DefaultHTTPClient")

      expect( described_class ).to receive(:new)
                               .with( 'uri', 'params' )
                               .and_return( http_post_double )
      expect( http_post_double ).to receive(:call)

      described_class.post 'uri', 'params'
    end

    # http_post is really tested in the integration spec,
    # where the internals are run through
  end

end