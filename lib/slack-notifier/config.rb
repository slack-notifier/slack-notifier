module Slack
  class Notifier
    class Config
      def initialize
        @http_client = Util::HTTPClient
        @defaults    = {}
        @middleware  = [:legacy]
      end

      def http_client client_class=nil
        return @http_client if client_class.nil?

        if client_class.respond_to?(:post)
          @http_client = client_class
        else
          raise ArgumentError, "the http client must respond to ::post"
        end
      end

      def defaults new_defaults=nil
        return @defaults if new_defaults.nil?

        if new_defaults.is_a?(Hash)
          @defaults = new_defaults
        else
          raise ArgumentError, "the defaults must be a Hash"
        end
      end

      def middleware *args
        return @middleware if args.empty?

        if args.length == 1 && args.first.is_a?(Array)
          @middleware = args.first
        else
          @middleware = args
        end
      end
    end
  end
end
