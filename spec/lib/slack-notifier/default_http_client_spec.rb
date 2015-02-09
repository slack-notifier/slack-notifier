require 'spec_helper'

describe Slack::Notifier::DefaultHTTPClient do

  describe "::post" do
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

  describe "#initialize" do
    it "allows setting of options for Net::HTTP" do
      net_http_double = instance_double("Net::HTTP")
      http_client     = described_class.new( URI.parse('http://example.com'), http_options: { open_timeout: 5 })

      allow( Net::HTTP ).to receive(:new)
                        .and_return(net_http_double)
      allow( net_http_double ).to receive(:use_ssl=)
      allow( net_http_double ).to receive(:request)

      expect( net_http_double ).to receive(:open_timeout=).with(5)

      http_client.call
    end
  end

end
