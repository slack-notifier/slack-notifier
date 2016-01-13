require 'net/http'
require 'uri'
require 'json'

require_relative 'slack-notifier/default_http_client'
require_relative 'slack-notifier/link_formatter'
require_relative 'slack-notifier/payload_middleware'

module Slack
  class Notifier
    attr_reader :endpoint, :default_payload

    def initialize webhook_url, options={}
      @endpoint        = URI.parse webhook_url
      @default_payload = options
    end

    def ping message, options={}
      message, options = nil, message if message.is_a?(Hash) # rubocop:disable Style/ParallelAssignment

      payload      = default_payload.merge(options)
      client       = payload.delete(:http_client) || http_client
      http_options = payload.delete(:http_options)

      payload.merge!(text: message) if message

      payload = middleware(:legacy).call(payload)
      params  = { payload: payload.to_json }

      params[:http_options] = http_options if http_options

      client.post endpoint, payload: payload.to_json
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

    HTML_ESCAPE_REGEXP = /[&><]/
    HTML_ESCAPE        = { '&' => '&amp;', '>' => '&gt;', '<' => '&lt;' }

    def escape text
      text.gsub(HTML_ESCAPE_REGEXP, HTML_ESCAPE)
    end

    private

      def middleware *list
        stack = PayloadMiddleware::Stack.new(self)
        stack.set(*list)

        stack
      end

  end
end
