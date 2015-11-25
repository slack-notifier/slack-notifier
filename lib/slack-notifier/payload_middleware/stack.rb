module Slack
  class Notifier
    class PayloadMiddleware

      class Stack

        attr_reader :notifier,
                    :stack

        def initialize notifier
          @notifier = notifier
          @stack    = []
        end

        def set *middlewares
          @stack = middlewares.flatten.map do |middleware_key|
            PayloadMiddleware.registry.fetch(middleware_key).new(notifier)
          end
        end

        def call payload={}
          stack.inject payload do |payload, middleware|
            middleware.call(payload)
          end
        end

      end

    end
  end
end
