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
        message[:text] = add_ats(message[:text], options.delete(:at)) if options[:at]
        options = message
      else
        message = add_ats(message, options.delete(:at)) if options[:at]
        options[:text] = message
      end

      post options
    end

    def post payload={}
      params  = {}
      client  = payload.delete(:http_client) || config.http_client
      payload = config.defaults.merge(payload)

      params[:http_options] = payload.delete(:http_options) if payload.key?(:http_options)
      params[:payload]      = middleware.call(payload).to_json

      client.post endpoint, params
    end

    private

      def add_ats(message, ats)
        special_commands = [:here, :channel, :everyone, :group]
        ats = Array(ats)
        ats.reverse.reduce(message) do |message, at|
          command_chr = special_commands.include?(at) ? '!' : '@'
          "<#{command_chr}#{at}> #{message}"
        end
      end
    
      def middleware
        @middleware ||= PayloadMiddleware::Stack.new(self)
      end
  end
end
