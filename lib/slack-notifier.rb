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
      @default_payload = { http_client: DefaultHTTPClient }.merge options
    end

    def ping message, options={}
      message, options = nil, message if message.is_a?(Hash) # rubocop:disable Style/ParallelAssignment

      params  = {}
      payload = default_payload.merge(options).tap { |h| h[:text] = message if message }
      client  = payload.delete(:http_client)

      params[:http_options] = payload.delete(:http_options) if payload.key?(:http_options)
      params[:payload]      = middleware(:legacy).call(payload).to_json

      client.post endpoint, params
    end

    def http_client
      default_payload.fetch :http_client
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
    HTML_ESCAPE        = { '&' => '&amp;', '>' => '&gt;', '<' => '&lt;' }.freeze

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
