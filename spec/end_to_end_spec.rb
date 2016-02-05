# encoding: utf-8
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
      { payload: { text: '<http://example.com|example>' }.to_json },

    ['hello/こんにちは from notifier test', {}] =>
      { payload: { text: 'hello/こんにちは from notifier test' }.to_json },

    ['Hello World, enjoy [](http://example.com).', {}] =>
      { payload: { text: 'Hello World, enjoy <http://example.com>.' }.to_json },

    ['Hello World, enjoy [this](http://example.com)[this2](http://example2.com)', {}] =>
      { payload: { text: 'Hello World, enjoy <http://example.com|this><http://example2.com|this2>'}.to_json },

    ['[John](mailto:john@example.com)', {}] =>
      { payload: { text: "<mailto:john@example.com|John>"}.to_json },

    ['<a href="mailto:john@example.com">John</a>', {}] =>
      { payload: { text: "<mailto:john@example.com|John>"}.to_json },

    ['hello', { channel: 'hodor'}] =>
      { payload: { channel: 'hodor', text: 'hello' }.to_json },

    ['the message', { channel: 'foo', attachments: [{ color: '#000',
                                                      text: 'attachment message',
                                                      fallback: 'fallback message' }] }] =>
      { payload: { channel: 'foo',
                   attachments: [ { color: '#000',
                                    text: 'attachment message',
                                    fallback: 'fallback message' } ],
                   text: 'the message' }.to_json },

   [{ attachments: [{ color: '#000',
                      text: 'attachment message',
                      fallback: 'fallback message' }] }] =>
    { payload: { attachments: [{ color: '#000',
                                 text: 'attachment message',
                                 fallback: 'fallback message' }] }.to_json },

   [{ attachments: { color: '#000',
                     text: 'attachment message [hodor](http://winterfell.com)',
                     fallback: 'fallback message' } }] =>
    { payload: { attachments: { color: '#000',
                                text: 'attachment message <http://winterfell.com|hodor>',
                                fallback: 'fallback message' } }.to_json },

   ['hello', { http_options: { timeout: 5 } }] =>
    { http_options: { timeout: 5 }, payload: { text: 'hello' }.to_json }


  }.each do |args, payload|

    it "sends correct payload for #{args}" do
      notifier = Slack::Notifier.new 'http://example.com', http_client: @http_client

      expect( @http_client ).to receive(:post)
                            .with( URI.parse('http://example.com'),
                                    payload )

      notifier.ping *args
    end
  end


end
