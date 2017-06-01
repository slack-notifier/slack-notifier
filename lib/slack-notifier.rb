# frozen_string_literal: true
require "uri"
require "json"

require_relative "slack-notifier/util/http_client"
require_relative "slack-notifier/util/link_formatter"
require_relative "slack-notifier/util/escape"
require_relative "slack-notifier/payload_middleware"
require_relative "slack-notifier/config"

module Slack
  class Notifier
    attr_reader :endpoint

    def initialize webhook_url, options={}, &block
      @endpoint = URI.parse webhook_url

      config.http_client(options.delete(:http_client)) if options.key?(:http_client)
      config.defaults options
      config.instance_exec(&block) if block_given?

      middleware.set config.middleware
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
      client  = payload.delete(:http_client) || config.http_client
      payload = config.defaults.merge(payload)
      payload = recursive_compact(payload)

      params[:http_options] = payload.delete(:http_options) if payload.key?(:http_options)
      params[:payload]      = middleware.call(payload).to_json

      client.post endpoint, params
    end

    private

      def middleware
        @middleware ||= PayloadMiddleware::Stack.new(self)
      end

      def recursive_compact(hsh)
        hsh.delete_if {|k,v| recursive_compact(v) if v.is_a?(Hash); v.nil? }
      end
  end
end
