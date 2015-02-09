module Slack
  class Notifier

    class DefaultHTTPClient

      class << self
        def post uri, params
          DefaultHTTPClient.new( uri, params ).call
        end
      end

      attr_reader :uri, :params, :http_options

      def initialize uri, params
        @uri          = uri
        @http_options = params.delete(:http_options) || {}
        @params       = params
      end

      def call
        http_obj.request request_obj
      end

      private

        def request_obj
          req = Net::HTTP::Post.new uri.request_uri
          req.set_form_data params

          return req
        end

        def http_obj
          http = Net::HTTP.new uri.host, uri.port
          http.use_ssl = (uri.scheme == "https")

          http_options.each do |opt, val|
            if http.respond_to? "#{opt}="
              http.send "#{opt}=", val
            else
              warn "Net::HTTP doesn't respond to `#{opt}=`, ignoring that option"
            end
          end

          return http
        end

    end

  end
end
