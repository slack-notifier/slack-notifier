require "uri"
require "json"

require_relative "slack-notifier/util/http_client"
require_relative "slack-notifier/util/link_formatter"
require_relative "slack-notifier/payload_middleware"
require_relative "slack-notifier/config"

module Slack
  class Notifier
    attr_reader :endpoint, :default_payload

    def initialize webhook_url, options={}, &block
      @endpoint        = URI.parse webhook_url
      @default_payload = { http_client: Util::HTTPClient }.merge options
      middleware.set(:legacy)

      config.instance_exec(&block) if block_given?
    end

    def config
      @_config ||= Config.new
    end

    def ping message, options={}
      if message.is_a?(Hash)
        options = message
      else
        options[:text] = message
      end

      post options
    end

    def post payload={}
      params  = {}
      payload = default_payload.merge(payload)
      client  = payload.delete(:http_client)

      params[:http_options] = payload.delete(:http_options) if payload.key?(:http_options)
      params[:payload]      = middleware.call(payload).to_json

      client.post endpoint, params
    end

    def http_client
      default_payload.fetch :http_client
    end

    def channel
      default_payload.fetch :channel
    end

    def channel= channel
      default_payload[:channel] = channel
    end

    def username
      default_payload.fetch :username
    end

    def username= username
      default_payload[:username] = username
    end

    HTML_ESCAPE_REGEXP = /[&><]/
    HTML_ESCAPE        = { "&" => "&amp;", ">" => "&gt;", "<" => "&lt;" }.freeze

    def escape text
      text.gsub(HTML_ESCAPE_REGEXP, HTML_ESCAPE)
    end

    private

      def middleware
        @middleware ||= PayloadMiddleware::Stack.new(self)
      end
  end
end
