require 'net/http'
require 'uri'
require 'json'

require_relative 'slack-notifier/default_http_client'
require_relative 'slack-notifier/link_formatter'

module Slack
  class Notifier
    attr_reader :endpoint, :default_payload

    def initialize webhook_url, options={}
      @endpoint        = URI.parse webhook_url
      @default_payload = options
    end

    def ping message, options={}
      message      = LinkFormatter.format(message)
      payload      = default_payload.merge(options).merge(text: message)
      client       = payload.delete(:http_client) || http_client
      http_options = payload.delete(:http_options)

      params = { payload: payload.to_json }
      params[:http_options] = http_options if http_options

      client.post endpoint, params
    end

    def http_client
      default_payload.fetch :http_client, DefaultHTTPClient
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
