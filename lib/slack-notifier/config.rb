module Slack
  class Notifier
    class Config
      attr_reader :endpoint

      def initialize
        @http_client = Util::HTTPClient
      end

      def endpoint= url
        @endpoint = URI.parse url
      end

      def http_client client_class=nil
        return @http_client if client_class.nil?

        if client_class.respond_to?(:post)
          @http_client = client_class
        else
          raise ArgumentError, "the http client must respond to ::post"
        end
      end

      %w[client defaults middleware].each do |m|
        define_method m do |*args|
          return instance_variable_get("@_#{m}") if args.empty?

          args = args.first if args.length == 1
          instance_variable_set("@_#{m}", args)
        end
      end
    end
  end
end
