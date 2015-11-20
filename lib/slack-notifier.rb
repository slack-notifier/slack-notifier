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
      if message.is_a?(Hash)
        message, options = nil, message
      end

      if attachments = options[:attachments] || options["attachments"]
        wrap_array(attachments).each do |attachment|
          ["text", :text].each do |key|
            attachment[key] = LinkFormatter.format(attachment[key]) if attachment.has_key?(key)
          end
        end
      end

      payload      = default_payload.merge(options)
      client       = payload.delete(:http_client) || http_client
      http_options = payload.delete(:http_options)

      unless message.nil?
        payload.merge!(text: LinkFormatter.format(message))
      end

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

    HTML_ESCAPE_REGEXP = /[&><]/
    HTML_ESCAPE = { '&' => '&amp;',  '>' => '&gt;',   '<' => '&lt;' }

    def escape(text)
      text.gsub(HTML_ESCAPE_REGEXP, HTML_ESCAPE)
    end

    def wrap_array(object)
      if object.nil?
        []
      elsif object.respond_to?(:to_ary)
        object.to_ary || [object]
      else
        [object]
      end
    end
  end
end
