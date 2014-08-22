require 'net/http'
require 'uri'
require 'json'

require_relative 'slack-notifier/default_http_client'
require_relative 'slack-notifier/link_formatter'

module Slack
  class Notifier
    attr_reader :team, :token, :http_client,
                :hook_name, :default_payload

    def initialize team, token, options={} # hook_name=default_hook_name, default_payload={}
      @team      = team
      @token     = token
      @http_client = options.delete(:http_client) || DefaultHTTPClient
      @hook_name   = options.delete(:hook_name) || default_hook_name
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

    private

      def default_hook_name
        'incoming-webhook'
      end

      def endpoint
        URI.parse "https://#{team}.slack.com/services/hooks/#{hook_name}?token=#{token}"
      end

  end
end
