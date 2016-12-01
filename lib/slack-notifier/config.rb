module Slack
  class Notifier
    class Config
      attr_reader :endpoint

      def endpoint= url
        @endpoint = URI.parse url
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
