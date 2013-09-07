require 'httparty'
require 'json'

module Slack
  class Notifier

    # these act as defaults
    # if they are set
    attr_accessor :channel, :username

    attr_reader :team, :token

    def initialize team, token
      @team  = team
      @token = token
    end

    def ping message, options={}
      message = LinkFormatter.format(message)
      payload = { text: message }.merge(default_payload).merge(options)

      unless payload.has_key? :channel
        raise ArgumentError, "You must set a channel"
      end

      HTTParty.post( endpoint, body: "payload=#{payload.to_json}" )
    end

    private

      def default_payload
        payload = {}
        payload[:channel]  = channel  if channel
        payload[:username] = username if username
        payload
      end

      def endpoint
        "https://#{team}.slack.com/services/hooks/incoming-webhook?token=#{token}"
      end

      class LinkFormatter
        class << self
          def format string
            LinkFormatter.new(string).formatted
          end
        end

        def initialize string
          @orig = string
        end

        def formatted
          @orig.gsub( html_pattern ) do |match|
            link = Regexp.last_match[1]
            text = Regexp.last_match[2]
            slack_link link, text
          end.gsub( markdown_pattern ) do |match|
            link = Regexp.last_match[1]
            text = Regexp.last_match[2]
            slack_link link, text
          end
        end

        private

          def slack_link link, text=nil
            out = "<#{link}"
            out << "|#{text}" if text && !text.empty?
            out << ">"

            return out
          end

          def html_pattern
            / <a (?:.*?) href=['"](.+)['"] (?:.*)> (.+?) <\/a> /x
          end

          def markdown_pattern
            /\[(.+?)\]\((.*?)\)/
          end
      end

  end
end