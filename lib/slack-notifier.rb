require 'net/http'
require 'uri'
require 'json'

require_relative 'slack-notifier/link_formatter'

module Slack
  class Notifier

    # these act as defaults
    # if they are set
    attr_accessor :channel, :username

    attr_reader :team, :token, :hook_name

    def initialize team, token, hook_name = default_hook_name
      @team  = team
      @token = token
      @hook_name = hook_name
    end

    def ping message, options={}
      message = LinkFormatter.format(message)
      payload = { text: message }.merge(default_payload).merge(options)

      req = Net::HTTP::Post.new(endpoint.request_uri)
      req.set_form_data(payload: payload.to_json)
      http = Net::HTTP.new(endpoint.host, endpoint.port)
      http.use_ssl = (endpoint.scheme == "https")
      http.request(req)
    end

    private

      def default_hook_name
        'incoming-webhook'
      end

      def default_payload
        payload = {}
        payload[:channel]  = channel  if channel
        payload[:username] = username if username
        payload
      end

      def endpoint
        URI.parse "https://#{team}.slack.com/services/hooks/#{hook_name}?token=#{token}"
      end

  end
end
