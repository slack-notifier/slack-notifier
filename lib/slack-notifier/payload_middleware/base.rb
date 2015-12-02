module Slack
  class Notifier
    class PayloadMiddleware
      class Base
        class << self
          def middleware_name name
            PayloadMiddleware.register self, name.to_sym
          end
        end

        attr_reader :notifier

        def initialize notifier
          @notifier = notifier
        end

        # rubocop:disable Lint/UnusedMethodArgument
        def call payload={}
          raise NoMethodError, "method `call` not defined for class #{self.class}"
        end
        # rubocop:enable Lint/UnusedMethodArgument
      end
    end
  end
end
