require 'net/http'
require 'uri'
require 'json'

require_relative 'slack-notifier/default_http_client'
require_relative 'slack-notifier/link_formatter'

module Slack
  class Notifier
    attr_reader :endpoint, :http_client, :default_payload

    def initialize webhook_url, options={}
      @endpoint        = URI.parse webhook_url
      @http_client     = options.delete(:http_client) || DefaultHTTPClient
      @default_payload = options
    end

    def ping message, options={}
      message = LinkFormatter.format(message)
      payload = { text: message }.merge(default_payload).merge(options)


      http_client.post endpoint, payload: payload.to_json
    end

    def channel
      default_payload[:channel]
    end

    def channel= channel
      default_payload[:channel] = channel
    end

    def username
      default_payload[:username]
    end

    def username= username
      default_payload[:username] = username
    end

  end
end
